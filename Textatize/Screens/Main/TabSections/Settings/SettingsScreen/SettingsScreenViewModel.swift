//
//  SettingsScreenViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/28/23.
//


import SwiftUI
import StoreKit

enum PurchaseProduct: String, CaseIterable {
    case getPoints = "com.textatize.test.points100"
}

class SettingsScreenViewModel: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = SettingsScreenViewModel()
    
    @Published var products = [SKProduct]()
    @Published var userPoints = TextatizeLoginManager.shared.loggedInUser?.points ?? 0
    @Published var userAPIKey: String = ""
    
    private let api = TextatizeAPI.shared
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func fetchProducts() {
        let request = SKProductsRequest(
            productIdentifiers: Set(PurchaseProduct.allCases.compactMap { $0.rawValue  })
        )
        request.delegate = self
        request.start()
    }
    
    func purchase(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            switch $0.transactionState {
            case .purchased:
                complete(transaction: $0)
            case .failed:
                failed(transaction: $0)
            case .restored:
                restore(transaction: $0)
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("Purchase Complete")
        SKPaymentQueue.default().finishTransaction(transaction)
        if let reciptData = NSData(contentsOf: Bundle.main.appStoreReceiptURL!) {
            let base64Encoded = reciptData.base64EncodedString()
            apiPurchase(appleReceipt: base64Encoded, points: "100")
        }
    }
    
    private func failed(transaction: SKPaymentTransaction) {
        print("Purchase Failed")
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        print("Purchase Restore")
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func apiPurchase(appleReceipt: String, points: String) {
        api.purchase(appleReceipt: appleReceipt, points: points) { error, userResponse in
            if let error = error {
                print(error.getMessage() ?? "No Error Message")
            }
            
            if let userResponse = userResponse, let user = userResponse.user, let points = user.points {
                self.userPoints = points
                print("Success: \(user)")
            }
        }
    }
    
    func getAPIKey() {
        if let apiKey = TextatizeLoginManager.shared.loggedInUser?.apiKey {
            userAPIKey = apiKey
        }
    }
    
}

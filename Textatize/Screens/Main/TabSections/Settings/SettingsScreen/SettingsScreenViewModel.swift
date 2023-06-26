//
//  SettingsScreenViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/26/23.
//

import SwiftUI
import StoreKit

class SettingsScreenViewModel: ObservableObject {
    static let shared = SettingsScreenViewModel()
    
    @Published var products = [Product]()
    
    private let api = TextatizeAPI.shared
    private let productID = ["com.textatize.test.points100"]
    
        
    private init() { }
    
    func fetchProducts() async {
            do {
                let results = try await Product.products(for: productID)
                DispatchQueue.main.async { [unowned self] in
                    withAnimation {
                        self.products = results
                    }
                }
                print(results)
            } catch {
                print("Product Error: \(error)")
            }
    }
    
    func purchase(product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(.verified(let transaction)):
                await transaction.finish()
                
            default:
                break
            }
        } catch {
            print(error)
        }
    }
    
    func apiPurchase(appleReceipt: String, points: String) {
        api.purchase(appleReceipt: appleReceipt, points: points) { error, userResponse in
            if let error = error {
                print(error.getMessage() ?? "No Error Message")
            }
            
            if let userResponse = userResponse, let user = userResponse.user {
                print("Success: \(user)")
            }
        }
    }
    
}

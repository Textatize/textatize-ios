//
//  DataManager.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/24/23.
//

import SwiftUI

class DataManager: ObservableObject {
    
    @Published var user: User?
    @Published var event: Event?

    static let shared = DataManager()
    private let loginManager = TextatizeLoginManager()
    private let textatizeAPI = TextatizeAPI.shared
    
    private init() {
        
        textatizeAPI.login(username: loginManager.getUsername(), password: loginManager.getPassword()) { [weak self] _, response in
            
            guard let self = `self` else { return }
            
            if let response = response, let user = response.user {
                self.user = user
                print("Successful User Login")
            }
        }
        
    }
    
}

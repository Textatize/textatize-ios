//
//  TextatizeLoginManager.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/19/23.
//

import UIKit

class TextatizeLoginManager {
    static let shared = TextatizeLoginManager()
    
    var loggedInUser: User? = nil
    
    func storeUsername(username: String) {
            UserDefaults.standard.set(username, forKey: "username")
        }
        
        func storePassword(password: String) {
            Keychain.storePassword(password: password)
        }
        
        func getUsername() -> String? {
            return UserDefaults.standard.string(forKey: "username")
        }
        
        func getPassword() -> String? {
            return Keychain.loadPassword()
        }
}

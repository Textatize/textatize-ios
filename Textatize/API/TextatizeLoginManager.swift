//
//  TextatizeLoginManager.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/19/23.
//

import UIKit

class TextatizeLoginManager: ObservableObject {
    static let shared = TextatizeLoginManager()
    
    var loggedInUser: User? = nil
    @Published var is_logged_in = false
    
    
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
    
    func resetPassword(newPassword: String) {
        Keychain.clear()
        storePassword(password: newPassword)
    }
    
    func checkRegistration(completion: @escaping (String?, LoginStatus) -> Void) {
        if TextatizeLoginManager.shared.loggedInUser != nil {
            completion(nil, .success)
            return
        }
        
        
        if let userName = getUsername(), let password = getPassword() {
            TextatizeAPI.shared.login(username: userName, password: password) { [weak self] error, userResponse in
                guard let self = `self` else { return }
                
                if let error = error {
                    completion(error.getMessage(), .notLoggedIn)
                }
                if let userResponse = userResponse, let user = userResponse.user {
                    loggedInUser = user
                    is_logged_in = true
                    completion(nil, .success)
                } else {
                    completion("Not Logged In", .notLoggedIn)
                }
                
            }
        } else {
            completion("No User", .notLoggedIn)
        }
        
    }
    
    func logout() {
        
        do {
            try Services.instance.imageBox.removeAll()
        } catch let error {
            print("Could not delete persistent data. Error:\(error)")
        }

        let defaults = UserDefaults.standard
        defaults.setValue(nil, forKey: "user_id")
        defaults.setValue(nil, forKey: "username")
        defaults.setValue(nil, forKey: "sessionToken")
        defaults.synchronize()
        Keychain.clear()
        self.loggedInUser = nil
        self.is_logged_in = false
        NotificationCenter.default.post(name:Notification.Name(rawValue:"LogoutNotification"),
                                        object: nil,
                                        userInfo: nil)
    }
}

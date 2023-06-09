//
//  LoginViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/19/23.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var loginSuccess = false
    //@Published var email = "test@bortnet.com"
    //@Published var password = "zzz123"
    @Published var email = ""
    @Published var password = ""
    
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
       
    let api = TextatizeAPI.shared
    let manager = DataManager.shared
    
    func login() {
        
        let trimUsername = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        api.login(username: trimUsername, password: trimPassword) { [weak self] error, userResponse in
            guard let self = `self` else { return }
            
            if let error = error, let errorMessage = error.getMessage() {
                self.alertTitle = "Login Error"
                self.alertMessage = errorMessage
                self.showAlert = true
            }
            
            if let userResponse = userResponse, let user = userResponse.user {
                self.manager.user = user
                self.loginSuccess = true
            }
        }
    }
    
    
}

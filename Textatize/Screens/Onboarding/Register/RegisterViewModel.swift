//
//  RegisterViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/23/23.
//

import SwiftUI

class RegisterViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    @Published var registerSuccess = false

    let api = TextatizeAPI.shared

    
    private func checkFields() -> Bool {
        guard !name.isEmpty else {
            alertTitle = "Name Error"
            alertMessage = "Name field is empty"
            showAlert = true
            return false
        }
        
        guard name.components(separatedBy: " ").count == 2 else {
            alertTitle = "Name Error"
            alertMessage = "Please enter your first and last name"
            showAlert = true
            return false
        }
        
        guard !email.isEmpty else {
            alertTitle = "Email Error"
            alertMessage = "Email field is empty"
            showAlert = true
            return false
        }
        
        guard !phone.isEmpty else {
            alertTitle = "Phone Error"
            alertMessage = "Phone field is empty"
            showAlert = true
            return false
        }
        
        guard !password.isEmpty else {
            alertTitle = "Password Error"
            alertMessage = "Password field is empty"
            showAlert = true
            return false
        }
        
        guard !confirmPassword.isEmpty else {
            alertTitle = "confirmPassword Error"
            alertMessage = "confirmPassword field is empty"
            showAlert = true
            return false
        }
        
        guard password == confirmPassword else {
            alertTitle = "Password Error Error"
            alertMessage = "Password and ConfirmPassword do not match"
            showAlert = true
            return false
        }
        return true
    }
    
    func createAccount() {
        guard checkFields() else { return }
        
        let firstName = name.components(separatedBy: " ")[0]
        let lastName = name.components(separatedBy: " ")[1]
                        
        api.register(first_name: firstName, last_name: lastName, username: email, email: email, phone: phone, password: password) { [weak self] error, response in
            
            guard let `self` = self else { return }
            
            if let error = error, let errorMessage = error.getMessage() {
                self.alertTitle = "Register Error"
                self.alertMessage = errorMessage
                self.showAlert = true
            }
            
            if let response = response {
                self.registerSuccess = true
            }
        }

    }
    
    
}

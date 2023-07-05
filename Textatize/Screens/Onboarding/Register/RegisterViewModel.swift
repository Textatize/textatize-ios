//
//  RegisterViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/23/23.
//

import SwiftUI

class RegisterViewModel: ObservableObject {
    
    @Published var firstName = ""
    @Published var lastName = ""
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
        guard !firstName.isEmpty else {
            alertTitle = "Name Error"
            alertMessage = "First Name field is empty"
            showAlert = true
            return false
        }
        
        guard !lastName.isEmpty else {
            alertTitle = "Name Error"
            alertMessage = "Last Name field is empty"
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
            alertTitle = "Password Error"
            alertMessage = "Confirm Password field is empty"
            showAlert = true
            return false
        }
        
        guard password == confirmPassword else {
            alertTitle = "Password Error"
            alertMessage = "Password and Confirm Password do not match"
            showAlert = true
            return false
        }
        return true
    }
    
    func createAccount(completion: @escaping ((Bool) -> Void)) {
        guard checkFields() else { return }
                        
        api.register(first_name: firstName, last_name: lastName, username: email, email: email, phone: phone, password: password) { [weak self] error, response in
            
            guard let `self` = self else { return }
            
            if let error = error, let errorMessage = error.getMessage() {
                self.alertTitle = "Register Error"
                self.alertMessage = errorMessage
                self.showAlert = true
                completion(false)
            }
            
            if let response = response {
                completion(true)
                self.registerSuccess = true
            }
        }

    }
    
    
}

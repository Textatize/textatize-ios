//
//  LoginViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/19/23.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var loginSuccess = false
    @Published var email = "test@bortnet.com"
    @Published var password = "zzz123"
       
    let api = TextatizeAPI.shared
    
    func login() {
        api.login(username: email, password: password) { [weak self] error, userResponse in
            guard let self = `self` else { return }
            
            if let userResponse = userResponse {
                self.loginSuccess = true
            }
        }
    }
    
    
}

//
//  ContentView.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/25/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoginPresented = false
    @StateObject private var loginManager = TextatizeLoginManager.shared
    var body: some View {
        if loginManager.is_logged_in {
            VerificationScreen()
        } else {
            SpinnerView()
                .foregroundColor(AppColors.Onboarding.loginButton)
                .frame(width: 200, height: 200)
                .fullScreenCover(isPresented: $isLoginPresented) {
                    LoginScreen()
                }
                .task {
                    loginManager.checkRegistration { error, status in
                        switch status {
                        case .success:
                            print("SUCCESS \(loginManager.is_logged_in)")

                        case .error:
                            print(error)
                            self.isLoginPresented = true

                        case .notLoggedIn:
                            print("Not Logged in")
                            self.isLoginPresented = true
                        }
                    }
                }

        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

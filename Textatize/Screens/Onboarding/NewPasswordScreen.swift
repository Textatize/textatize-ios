//
//  NewPasswordScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/15/23.
//

import SwiftUI

struct NewPasswordScreen: View {
    
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ZStack {
            
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea()
            
            VStack {
                
                Text("New password")
                    .onboardingTitle()
                    .padding(.top, 30)
                
                VStack {
                    // Password
                    VStack(alignment: .leading) {
                        Text("Password")
                            .font(.caption)
                        
                        TextField("Enter your email", text: $password)
                            .padding()
                            .frame(height: 50)
                            .onboardingBorder()
                    }
                    .padding()
                    
                    // Confirm Password
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Confirm the password")
                            .font(.caption)
                        
                        TextField("Enter your password again", text: $confirmPassword)
                            .padding()
                            .frame(height: 50)
                            .onboardingBorder()
                        
                        Text(Texts.Onboarding.confirmPasswordText)
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                    Spacer()
                    
                    NavigationLink {
                        LoginScreen()
                    } label: {
                        CustomButtonView(filled: true, name: "Continue")
                            .padding()
                    }
                    
                    
                    
                    
                }
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal, 20)
        }
    }
    
    private func continueAction() {
        print("Continue Pressed")
    }
}

struct NewPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewPasswordScreen()
    }
}

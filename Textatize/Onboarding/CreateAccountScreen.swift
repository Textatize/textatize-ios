//
//  CreateAccountScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/15/23.
//

import SwiftUI

struct CreateAccountScreen: View {
    
    @State private var nameTxt = ""
    @State private var emailTxt = ""
    @State private var phoneNumberTxt = ""
    @State private var passwordTxt = ""
    @State private var confirmPasswordTxt = ""
    
    var body: some View {
        ZStack {
            
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea()
            
            VStack {
                
                Text("Create \n your account")
                    .onboardingTitle()
                    .padding(.top, 30)
                                
                VStack(spacing: 20) {
                   
                    VStack(alignment: .leading) {
                        Text("Your name")
                            .font(.caption)
                        
                        TextField("Enter your name", text: $nameTxt)
                            .padding()
                            .frame(height: 50)
                            .onboardingBorder()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Your email")
                            .font(.caption)
                        
                        TextField("Enter your email", text: $emailTxt)
                            .padding()
                            .frame(height: 50)
                            .onboardingBorder()

                    }
                    
                    VStack(alignment: .leading) {
                        Text("Phone Number")
                            .font(.caption)
                        
                        TextField("Enter your phone number", text: $phoneNumberTxt)
                            .padding()
                            .frame(height: 50)
                            .onboardingBorder()

                    }
                    
                    VStack(alignment: .leading) {
                        Text("Password")
                            .font(.caption)

                        ZStack {
                            SecureField("Enter your password", text: $passwordTxt)
                                .padding()
                                .frame(height: 50)
                                .onboardingBorder()
                            
                            Button {
                                // Show Password
                            } label: {
                                AppImages.Onboarding.eyeIcon
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.trailing, 5)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Confirm the password")
                            .font(.caption)

                        ZStack {
                            SecureField("Enter your password", text: $confirmPasswordTxt)
                                .padding()
                                .frame(height: 50)
                                .onboardingBorder()

                            
                            Button {
                                // Show Password
                            } label: {
                                AppImages.Onboarding.eyeIcon
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.trailing, 5)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    
                    Spacer()
                    
                    // Continue Button
                    CustomButton(filled: true, name: "Register", action: register)
                    
                }
                .padding()
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal, 20)
            
        }
    }
    
    private func register() {
        print("Register Pressed")
    }
}

struct CreateAccountScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountScreen()
    }
}

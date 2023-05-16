//
//  LoginScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/15/23.
//

import SwiftUI

struct LoginScreen: View {
    
    @State private var emailTxt = ""
    @State private var passwordTxt = ""
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [AppColors.Onboarding.topColor, AppColors.Onboarding.bottomColor], startPoint: .top, endPoint: .bottom)
            
            VStack(spacing: 10) {
                
                
                Text("Welcome \n to the Textatize!")
                    .onboardingTitle()
                    .padding(.top, 30)
                
                VStack(alignment: .leading, spacing: 30) {
                    
                    VStack(spacing: 10) {
                        Text("Log in")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Please fill in all fields")
                            .font(.callout)
                            .fontWeight(.light)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Email
                    VStack(alignment: .leading) {
                        Text("Email")
                            .font(.caption)
                        
                        TextField("Enter your email", text: $emailTxt)
                            .padding()
                            .frame(height: 50)
                            .onboardingBorder()
                    }
                    
                    // Password
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
                    
                    // Remember me and Forgot Password
                    HStack {
                        Button {
                            // check remember me
                        } label: {
                            HStack {
                                AppImages.Onboarding.checkIcon
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                
                                Text("Remember me")
                                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                                    .font(.subheadline)
                                    .fontWeight(.light)
                            }
                        }
                        
                        Spacer()
                        
                        // Forgot Password
                        Button {
                            
                        } label: {
                            Text("Forgot the password?")
                                .underline()
                                .font(.caption)
                                .foregroundColor(AppColors.Onboarding.topColor)
                        }
                        
                    }
                    .padding(.top, -10)
                    
                    Spacer()
                    
                    // Log in and sign up buttons
                    VStack(spacing: 20) {
                       
                        // Log in Button
                        CustomButton(filled: true, name: "Log in", action: login)
                        
                        // Separator
                        HStack {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(height: 1)
                            
                            Text("Or")
                                .font(.caption)
                                .foregroundColor(Color.gray)
                            
                            Rectangle()
                                .fill(Color.gray)
                                .frame(height: 1)
                                
                        }
                        
                        // Sign up Button
                        CustomButton(filled: false, name: "Sign up", action: signUp)

                    }
                            
                }
                .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                .padding(.vertical, 30)
                .padding()

            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal, 20)
        }
        .ignoresSafeArea()
    }
    
    private func login() {
        print("Log in pressed")

    }
    
    private func signUp() {
        print("Sign up pressed")
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}

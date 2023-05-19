//
//  LoginScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/15/23.
//

import SwiftUI

struct LoginScreen: View {
    
    @State private var emailTxt = "test@bortnet.com"
    @State private var passwordTxt = "zzz123"
    
    @State private var loginPressed = false
    @State private var signupPressed = false
    @State private var forgotPasswordPressed = false
    
    
    var body: some View {
        ZStack {
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea()
            
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
                        Spacer()
                        
                        // Forgot Password
                        Text("Forgot the password?")
                            .underline()
                            .font(.caption)
                            .foregroundColor(AppColors.Onboarding.topColor)
                            .onTapGesture {
                                forgotPasswordPressed = true
                            }
                        
                    }
                    .padding(.top, -10)
                    
                    Spacer()
                    
                    // Log in and sign up buttons
                    VStack(spacing: 20) {
                        
                        CustomButtonView(filled: true, name: "Log in")
                            .onTapGesture {
                                loginPressed = true
                            }
                        
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
                        
                        CustomButtonView(filled: false, name: "Sign up")
                            .onTapGesture {
                                signupPressed = true
                            }
                        
                        
                    }
                    
                }
                .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                .padding(.vertical, 30)
                .padding()
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $loginPressed) {
                MainTabView()
            }
            .fullScreenCover(isPresented: $signupPressed) {
                CreateAccountScreen()
            }
            .fullScreenCover(isPresented: $forgotPasswordPressed) {
                ForgotPasswordScreen()
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}

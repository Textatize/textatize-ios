//
//  CreateAccountScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/15/23.
//

import SwiftUI

struct CreateAccountScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var vm = RegisterViewModel()
        
    var body: some View {
        ZStack {
            
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea()
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "arrow.left")
                    Text("Back")
                }
                .accentColor(AppColors.Onboarding.loginScreenForegroundColor)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            
            VStack {
                
                Text("Create \n your account")
                    .onboardingTitle()
                    .padding(.top, 30)
                                
                VStack(spacing: 20) {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("Your name")
                                .font(.caption)
                            
                            TextField("Enter your name", text: $vm.name)
                                .padding()
                                .frame(height: 50)
                                .onboardingBorder()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Your email")
                                .font(.caption)
                            
                            TextField("Enter your email", text: $vm.email)
                                .padding()
                                .frame(height: 50)
                                .onboardingBorder()

                        }
                        
                        VStack(alignment: .leading) {
                            Text("Phone Number")
                                .font(.caption)
                            
                            TextField("Enter your phone number", text: $vm.phone)
                                .padding()
                                .frame(height: 50)
                                .onboardingBorder()

                        }
                        
                        VStack(alignment: .leading) {
                            Text("Password")
                                .font(.caption)

                            ZStack {
                                SecureField("Enter your password", text: $vm.password)
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
                                SecureField("Enter your password", text: $vm.confirmPassword)
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
                    }
                    
                    Spacer()
                    
                    CustomButtonView(filled: true, name:"Register")
                        .onTapGesture {
                            vm.createAccount()
                        }

                }
                .padding()
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $vm.registerSuccess) {
                VerificationScreen()
            }
            .alert(isPresented: $vm.showAlert) {
                Alert(title: Text(vm.alertTitle), message: Text(vm.alertMessage), dismissButton: .default(Text("Dismiss")))
            }
        }
    }
}

struct CreateAccountScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountScreen()
    }
}

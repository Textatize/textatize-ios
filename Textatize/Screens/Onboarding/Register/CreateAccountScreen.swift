//
//  CreateAccountScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/15/23.
//

import SwiftUI

struct CreateAccountScreen: View {
    @Binding var path: [OnboardingNav]
    
    @StateObject private var vm = RegisterViewModel()
        
    var body: some View {
        ZStack {
            
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea()
            
            VStack {
                
                Text("Create \n your account")
                    .onboardingTitle()
                    .padding(.top, 30)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("First name")
                                .font(.caption)
                            
                            TextField("Enter your first name", text: $vm.firstName)
                                .padding()
                                .frame(height: 50)
                                .onboardingBorder()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Last name")
                                .font(.caption)
                            
                            TextField("Enter your last name", text: $vm.lastName)
                                .padding()
                                .frame(height: 50)
                                .onboardingBorder()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Email")
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
                }
                .padding()
                
                Spacer()
                
                Button {
                    vm.createAccount { result in
                        if result {
                            path.removeAll()
                        }
                    }
                } label: {
                    CustomButtonView(filled: true, name:"Register")
                }
                .padding()
            }
            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
            .customBackground()
            .fullScreenCover(isPresented: $vm.registerSuccess) {
                VerificationScreen()
            }
            .alert(isPresented: $vm.showAlert) {
                Alert(title: Text(vm.alertTitle), message: Text(vm.alertMessage), dismissButton: .default(Text("Dismiss")))
            }
            
            CustomOnboardingBackButtom(path: $path)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct CreateAccountScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountScreen(path: .constant([OnboardingNav.createAccountScreen]))
    }
}

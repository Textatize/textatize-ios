//
//  ChangePassword.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI

struct ChangePasswordScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var changeSuccess = false
    
    var body: some View {
        ZStack {
            
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea(edges: .top)

            VStack {
                
                Spacer()
                
                Text("Change Password")
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                
                VStack {
                    
                    Text("Fill out the forms")
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .fontWeight(.semibold)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        
                        VStack(alignment: .leading) {
                            Text("Old password")
                                .font(.caption)

                            ZStack {
                                SecureField("Enter your password", text: $oldPassword)
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
                            Text("New password")
                                .font(.caption)

                            ZStack {
                                SecureField("Enter your password", text: $newPassword)
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
                            Text("Confirm password")
                                .font(.caption)

                            ZStack {
                                SecureField("Enter your password", text: $confirmPassword)
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
                    .padding()
                    
                    Spacer()
                    
                    Button {
                        changePassword()
                    } label: {
                        CustomButtonView(filled: true, name: "Save")
                            .padding()
                    }
                    
                }
                .foregroundColor(.black)
                
            }
            .customBackground()
        }
        .alert(alertTitle, isPresented: $showAlert, actions: {
            if changeSuccess {
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    Text("Dismiss")
                }
            } else {
                Button(role: .cancel) {
                    screenReset()
                } label: {
                    Text("Retry")
                }
            }
        }, message: {
            Text(alertMessage)
        })
    }
    private func changePassword() {
        if newPassword == confirmPassword {
            TextatizeAPI.shared.changePassword(oldPassword: oldPassword, newPassword: newPassword) { error, userResponse in
                if let error = error {
                    alertTitle = "Password Error"
                    alertMessage = error.getMessage() ?? "No Error"
                    changeSuccess = false
                    showAlert = true
                }
                
                if userResponse != nil {
                    alertTitle = "Success"
                    alertMessage = "Password Changed!"
                    changeSuccess = true
                    showAlert = true
                }
                
            }
        } else {
            alertTitle = "Password Error"
            alertMessage = "Password's do not match"
            changeSuccess = false
            showAlert = true
        }
    }
    private func screenReset() {
        oldPassword = ""
        newPassword = ""
        confirmPassword = ""
    }
}

struct ChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordScreen()
    }
}

//
//  ChangePassword.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI

struct ChangePasswordScreen: View {

    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ZStack {
            
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea()
            
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
                    
                    CustomButtonView(filled: true, name: "Save")
                        .padding()
                    
                }
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal)
            
        }
    }
}

struct ChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordScreen()
    }
}

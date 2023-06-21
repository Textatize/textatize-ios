//
//  NewPasswordScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/15/23.
//

import SwiftUI

struct NewPasswordScreen: View {
    @Binding var path: [OnboardingNav]
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

                        ZStack {
                            SecureField("Enter your password", text: $password)
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
                    .padding()
                    
                    // Confirm Password
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Confirm the password")
                            .font(.caption)

                        ZStack {
                            SecureField("Enter your password again", text: $confirmPassword)
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
                        
                        Text(Texts.Onboarding.confirmPasswordText)
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button {
                        path.removeAll()
                    } label: {
                        CustomButtonView(filled: true, name: "Log in")
                    }

                }
                .padding()
            }
            .customBackground()
            
            CustomOnboardingBackButtom(path: $path)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private func continueAction() {
        print("Continue Pressed")
    }
}

struct NewPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewPasswordScreen(path: .constant([.newPasswordScreen]))
    }
}

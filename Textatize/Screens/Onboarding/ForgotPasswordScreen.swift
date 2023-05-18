//
//  ForgotPasswordScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/15/23.
//

import SwiftUI

struct ForgotPasswordScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var emailTxt = ""
    @State private var continuePressed = false
    
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
            
            VStack(spacing: 10) {
                
                Spacer()
                
                Text("Forgot \n password?")
                    .onboardingTitle()
                    .padding(.top, 30)
                
                VStack(spacing: 20) {
                    
                    // Recovery
                    VStack(spacing: 10) {
                        Text("Recovery")
                            .lineLimit(nil)
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(Texts.Onboarding.recoveryText)
                            .font(.callout)
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
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
                    
                    Spacer()
                    
                    CustomButtonView(filled: true, name: "Continue")
                        .onTapGesture {
                            continuePressed = true
                        }

                    
                }
                .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                .padding(.vertical, 20)
                .padding()
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $continuePressed) {
                RecoveryScreen()
            }
        }
    }
    
    private func continueAction() {
        print("Continue Pressed")
    }
}

struct ForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordScreen()
    }
}

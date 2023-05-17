//
//  ForgotPasswordScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/15/23.
//

import SwiftUI

struct ForgotPasswordScreen: View {
    
    @State private var emailTxt = ""
    
    var body: some View {
        ZStack {
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea()
            
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
                    
                    NavigationLink {
                        RecoveryScreen()
                    } label: {
                        CustomButtonView(filled: true, name: "Continue")
                    }
                    
                }
                .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                .padding(.vertical, 20)
                .padding()
                
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

struct ForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordScreen()
    }
}

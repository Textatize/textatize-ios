//
//  ForgotPasswordScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/15/23.
//

import SwiftUI

struct ForgotPasswordScreen: View {
    @Binding var path: [OnboardingNav]
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
                    
                    NavigationLink(value: OnboardingNav.recoveryScreen) {
                        CustomButtonView(filled: true, name: "Continue")
                    }

                }
                .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
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

struct ForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordScreen(path: .constant([.forgotPasswordScreen]))
    }
}

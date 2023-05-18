//
//  RecoveryScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/15/23.
//

import SwiftUI

struct RecoveryScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var verificationTxt = ""
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
            
            VStack {
                
                Spacer()
                
                Text("Recovery")
                    .onboardingTitle()
                    .padding(.top, 30)
                
                VStack(spacing: 10) {
                    Text("Verification")
                        .lineLimit(nil)
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(Texts.Onboarding.verificationText)
                        .font(.callout)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                .padding(.vertical, 20)
                .padding()
                
                VStack {
                    TextField("Enter Your Verification Code", text: $verificationTxt)
                        .padding()
                        .frame(height: 50)
                        .onboardingBorder()
                    
                    HStack(spacing: 5) {
                        Text("You can request the code again via:")
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)

                            
                        Text("01:00")
                            .font(.caption)
                            .foregroundColor(AppColors.Onboarding.loginButton)

                    }
                    .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    
                   CustomButtonView(filled: true, name: "Continue")
                        .onTapGesture {
                            continuePressed = true
                        }
                }
                .padding()
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $continuePressed) {
                NewPasswordScreen()
            }
        }
    }
}

struct RecoveryScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecoveryScreen()
    }
}

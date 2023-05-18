//
//  ThanksScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/16/23.
//

import SwiftUI

struct ThanksScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var loginPressed = false
    
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
            
            VStack(spacing: 20) {
                AppImages.Onboarding.smile
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Text("Thanks!")
                    .onboardingTitle()
                    .padding(.top, 30)
                
                Text("Your account has been \n successfully created")
                    .lineLimit(nil)
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                CustomButtonView(filled: true, name: "Log in")
                    .onTapGesture {
                        loginPressed = true
                    }
                    .padding()
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $loginPressed) {
                LoginScreen()
            }
            
        }
    }
}

struct ThanksScreen_Previews: PreviewProvider {
    static var previews: some View {
        ThanksScreen()
    }
}

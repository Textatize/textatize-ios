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
                
                NavigationLink {
                    LoginScreen()
                } label: {
                    CustomButtonView(filled: true, name: "Log in")
                }
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal, 20)

            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButtom(action: dismiss)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct ThanksScreen_Previews: PreviewProvider {
    static var previews: some View {
        ThanksScreen()
    }
}

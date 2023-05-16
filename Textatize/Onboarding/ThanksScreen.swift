//
//  ThanksScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/16/23.
//

import SwiftUI

struct ThanksScreen: View {
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
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal, 20)
            
        }
    }
}

struct ThanksScreen_Previews: PreviewProvider {
    static var previews: some View {
        ThanksScreen()
    }
}

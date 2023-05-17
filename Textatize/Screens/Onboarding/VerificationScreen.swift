//
//  VerificationScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/16/23.
//

import SwiftUI

struct VerificationScreen: View {
    
    @State private var verificationTxt = ""
    
    var body: some View {
        ZStack {
            
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea()
            
            VStack {
                
                Text("Verification")
                    .onboardingTitle()
                    .padding(.top, 30)
                
                VStack(spacing: 5) {
                    Text("Enter the code")
                        .lineLimit(nil)
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Please enter the code sent to \n +8 850  7758989")
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
                    
                    NavigationLink {
                        ThanksScreen()
                    } label: {
                        Text("Verify")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.gray)
                            )
                            .opacity(0.4)
                    }
                    
                }
                .padding()
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal, 20)
            
        }
    }
}

struct VerificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        VerificationScreen()
    }
}

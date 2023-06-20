//
//  VerificationScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/16/23.
//

import SwiftUI

struct VerificationScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var verificationTxt = ""
    @State private var isVerified = false
    @StateObject private var loginManager = TextatizeLoginManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                
                AppColors.Onboarding.redLinearGradientBackground
                    .ignoresSafeArea()
                
    //            Button {
    //                dismiss()
    //            } label: {
    //                HStack {
    //                    Image(systemName: "arrow.left")
    //                    Text("Back")
    //                }
    //                .accentColor(AppColors.Onboarding.loginScreenForegroundColor)
    //            }
                //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
               // .padding()
                
                
                VStack {
                    
                    Text("Verification")
                        .padding()
                        .onboardingTitle()
                    
                    VStack(spacing: 5) {
                        Text("Enter the code")
                            .lineLimit(nil)
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .font(.title2)
                            .fontWeight(.semibold)
                        if let user = loginManager.loggedInUser, let number = user.phone {
                            Text("Please enter the code sent to \n \(number)")
                                .font(.callout)
                                .fontWeight(.light)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .fixedSize(horizontal: false, vertical: true)
                        }
    
                    }
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
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
                            
                            Button {
                                resentCode()
                            } label: {
                                Text("Resend Code")
                                    .font(.caption)
                                    .foregroundColor(AppColors.Onboarding.loginButton)
                            }
                            
                        }
                        .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        Button {
                            verify { result in
                                if result {
                                    isVerified = true
                                }
                            }
                        } label: {
                            CustomButtonView(filled: true, name: "Verify")
                        }                        
                    }
                    .padding()
                }
                .customBackground()
            }
            .toolbar(.hidden, for: .navigationBar)
            .background {
                NavigationLink(isActive: $isVerified) {
                    MainTabView()
                } label: {
                    EmptyView()
                }

            }
        }
    }
    private func verify(completion: @escaping ((Bool) -> Void)) {
        TextatizeAPI.shared.verifyUser(code: verificationTxt) { error, response in
            if let error = error {
                print(error.getMessage() ?? "No Error Message Text")
            }
            
            if let response = response, let user = response.user {
                if user.getIsEmailVerified {
                   completion(true)
                } else {
                    print("Failed")
                }
            }
            
        }
    }
    
    private func resentCode() {
        TextatizeAPI.shared.resendVerificationCode { _, _ in }
    }
}

struct VerificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        VerificationScreen()
    }
}

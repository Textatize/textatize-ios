//
//  ContactInformationScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI

struct ContactInformationScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var nameTxt = ""
    @State private var emailTxt = ""
    @State private var numberTxt = ""
    
    var body: some View {
        ZStack {
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea(edges: .top)

            VStack {
                
                Spacer()
                
                Text("Contact Information")
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                
                VStack {
                    
                    Text("Fill out the forms")
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .fontWeight(.semibold)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        
                        VStack(alignment: .leading) {
                            Text("Name")
                                .font(.caption)
                            
                            TextField("Enter your name", text: $nameTxt)
                                .padding()
                                .frame(height: 50)
                                .onboardingBorder()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Email")
                                .font(.caption)
                            
                            TextField("Enter your email", text: $emailTxt)
                                .padding()
                                .frame(height: 50)
                                .onboardingBorder()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Number")
                                .font(.caption)
                            
                            TextField("+123456", text: $numberTxt)
                                .padding()
                                .frame(height: 50)
                                .onboardingBorder()
                        }
                        
                    }
                    .padding()
                    
                    Spacer()
                    
                    CustomButtonView(filled: true, name: "Save")
                        .padding()
                    
                }
                
            }
            .customBackground()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButtom(action: dismiss)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct ContactInformationScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContactInformationScreen()
    }
}

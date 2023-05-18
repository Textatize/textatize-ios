//
//  TemplatesScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct TemplatesScreen: View {
    
    let isiPad = UIDevice.current.userInterfaceIdiom == .pad
    
    let iPadLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let iPhoneLayout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea()
            
            VStack {
                
                Text("Templates")
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                
                VStack {
                    
                    Text("Choose the templates")
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .fontWeight(.semibold)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    
                    
                    ScrollView {
                        LazyVGrid(columns: isiPad ? iPadLayout : iPhoneLayout) {
                            ForEach(0..<10) { item in
                                if item == 0 {
                                    AddCard(title: "Upload")
                                        .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40, height: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40)
                                        .padding()
                                } else {
                                    TemplateCard()
                                        .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40, height: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40)
                                        .padding()

                                }
                            }
                        }
                    }
                    
                    CustomButtonView(filled: true, name: "Choose")
                        .padding()
                    
                }
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal)
            
            
        }
    }
}

struct TemplatesScreen_Previews: PreviewProvider {
    static var previews: some View {
        TemplatesScreen()
    }
}

//
//  TemplateEditingScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI

struct TemplateEditingScreen: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea(edges: .top)

            VStack {
                
                Spacer()
                Text("Template Editing")
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.4)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(.gray, lineWidth: 4)
                    )
                
                Spacer()
                
                HStack {
                    
                    Button {
                        print("Add Image Pressed")
                    } label: {
                        VStack {
                            AppImages.imageIcon
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1)
                            Text("Add Image")
                        }
                        .foregroundColor(AppColors.Onboarding.loginButton)
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.2)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(AppColors.Onboarding.loginButton, lineWidth: 4)
                    )
                    .padding()
                    
                    Button {
                        print("Add Text Pressed")
                    } label: {
                        VStack {
                            AppImages.textIcon
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1)
                            Text("Add Text")
                        }
                        .foregroundColor(AppColors.Onboarding.loginButton)
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.2)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(AppColors.Onboarding.loginButton, lineWidth: 4)
                    )
                    .padding()


                    
                }
                
                Spacer()
                
                CustomButtonView(filled: true, name: "Save")
                    .padding()
                
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal)
            .padding()
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButtom(action: dismiss)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct TemplateEditingScreen_Previews: PreviewProvider {
    static var previews: some View {
        TemplateEditingScreen()
    }
}

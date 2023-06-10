//
//  FrameEditingScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI
import Kingfisher

struct FrameEditingScreen: View {
    @Environment(\.dismiss) var dismiss
    var frameImage: Image? = nil
    var body: some View {
        ZStack {
            
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea(edges: .top)

            VStack {
                
                Spacer()
                Text("Frame Editing")
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                
                if let frameImage = frameImage {
                    frameImage
                        .resizable()
                        .padding()
                }
                
                Spacer()
                
                HStack {
                    FrameEditButton(title: "Background", image: AppImages.imageIcon, action: addBackgroundPressed)
                    FrameEditButton(title: "Image", image: AppImages.imageIcon, action: addImagePressed)
                    FrameEditButton(title: "Text", image: AppImages.textIcon, action: addTextPressed)
                }
                
                Spacer()
                
                CustomButtonView(filled: true, name: "Save")
                    .padding()
                
                
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
    
    private func addBackgroundPressed() {
        print("Add Background Pressed")
    }
    
    private func addImagePressed() {
        print("Add Image Presssed")
    }
    
    private func addTextPressed() {
        print("Add Text Pressed")
    }
}

struct FrameEditButton: View {
    
    var title: String
    var image: Image
    var action: () -> Void
    
    var body: some View {
        
        Button {
            action()
        } label: {
            VStack {
                image
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.075)
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(AppColors.Onboarding.loginButton)
            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.2)
        }
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(AppColors.Onboarding.loginButton, lineWidth: 3)
        )
        
    }
}

struct FrameEditingScreen_Previews: PreviewProvider {
    static var previews: some View {
        FrameEditingScreen()
    }
}

//
//  FrameScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI

struct FrameScreen: View {
    @Environment(\.dismiss) var dismiss
    
    let isiPad = UIDevice.current.userInterfaceIdiom == .pad
    
    @State private var editTemplateSelected = false
    @State private var watermarkSwitch = false
    @State private var transparencyValue = 50.0
    @State private var nextPressed = false
    
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
                
                Text("Frame")
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                
                Spacer()
                
                VStack {
                    
                    HStack {
                        Group {
                            VStack(spacing: 10) {
                                Text("Choose the frame")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("Next Step: Check information")
                                    .font(.caption2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        AppImages.diagramFull
                            .overlay {
                                Text("2 of 2")
                                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            }
                        
                    }
                    
                    VStack {
                        
                        Text("Your Frames:")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<10) { item in
                                    if item == 0 {
                                        AddCard(title: "Upload")
                                            .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30, height: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30)
                                            .padding()
                                    } else {
                                        TemplateCard(editSelected: $editTemplateSelected, showDuplicate: false)
                                            .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30, height: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30)
                                            .padding()

                                    }
                                }
                            }
                        }
                        
                        Text("Watermark")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                            Toggle("Add a watermark instead of a frame", isOn: $watermarkSwitch)
                                .tint(AppColors.Onboarding.topColor)
                        
                        if watermarkSwitch {
                            VStack(spacing: 20) {
                                HStack(spacing: 20) {
                                    Text("Position")
                                    
                                    HStack {
                                        Button {
                                            print("Position 1")
                                        } label: {
                                            AppImages.position1
                                        }
                                        
                                        Button {
                                            print("Position 2")
                                        } label: {
                                            AppImages.position2
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    Text("Transparency")
                                    
                                    Slider(value: $transparencyValue, in: 0...100)
                                    Text("\(transparencyValue, specifier: "%.2f") %")
                                }
                                
                                HStack {
                                    CustomButtonView(filled: true, name: "Upload New")
                                    CustomButtonView(filled: false, name: "Delete")

                                }
  
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Spacer()

                        
                        CustomButtonView(filled: true, name: "Next")
                            .onTapGesture {
                                nextPressed = true
                            }
                            .padding()

                    }
                    
                    
                }
                .padding()
                .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal)
            .fullScreenCover(isPresented: $nextPressed) {
                CheckAllInfoScreen(name: "Holidays", date: "10/11/12", location: "Rome", orientation: "Portrait", camera: "Front", hostName: "Anna")
            }
            
        }
    }
}

struct FrameScreen_Previews: PreviewProvider {
    static var previews: some View {
        FrameScreen()
    }
}

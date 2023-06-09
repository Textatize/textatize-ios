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
    @StateObject private var vm = FrameSelectionViewModel.shared
     
    @State var frameSelected = false
    @State var selectedFrame: Frame? = nil
    
    var name: String
    var eventHostName: String
    var date: String
    var location: String
    var orientation: Orientation
    var camera: Camera
    @State private var addFrameSelected = false
    
    @State private var watermarkImage: UIImage? = UIImage(systemName: "person")
    @State private var watermarkTransparency: Double = 0.0
    @State private var watermarkPosition: WatermarkPosition = .bottomLeft
    
    @State private var editFrameSelected = false
    @State private var watermarkSwitch = false
    @State private var nextPressed = false
    
    var body: some View {
        ZStack {
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea(edges: .top)

            
            VStack {
                
                Text("Frame")
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                
                Spacer()
                
                ScrollView {
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
                            
                            
                            
                            if let selectedFrame = selectedFrame {
                                Text("Selected Frame:")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                FrameSelectionCard(frameSelected: $selectedFrame, frame: selectedFrame)
                                    .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30, height: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30)
                                    .padding()


                            }
                            
                            
                            Text("Your Frames:")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(0..<vm.frames.count, id: \.self) { item in
                                        let frame = vm.frames[item]
                                        FrameSelectionCard(frameSelected: $selectedFrame, frame: frame)
                                            .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30, height: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30)
                                            .padding()
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
                                                watermarkPosition = .bottomLeft
                                                print("BottomLeft")
                                            } label: {
                                                AppImages.position1
                                            }
                                            
                                            Button {
                                                watermarkPosition = .bottomRight
                                                print("BottomRight")
                                            } label: {
                                                AppImages.position2
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    HStack {
                                        Text("Transparency")
                                        
                                        Slider(value: $watermarkTransparency, in: 0...100)
                                        Text("\(watermarkTransparency, specifier: "%.1f") %")
                                    }
                                    
                                    HStack {
                                        CustomButtonView(filled: true, name: "Upload New")
                                        CustomButtonView(filled: false, name: "Delete")
                                        
                                    }
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Spacer()
                            
                            NavigationLink {
                                CheckAllInfoScreen(name: name, date: "10/11/12", location: location, orientation: orientation, camera: camera, hostName: eventHostName, watermarkImage: watermarkImage!, watermarkTransparency: watermarkTransparency, watermarkPosition: watermarkPosition, frame: selectedFrame)
                            } label: {
                                CustomButtonView(filled: true, name: "Next")
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    .padding()
                .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                }
                
            }
            .customBackground()
            .padding(.vertical, 25)
            .padding(.horizontal)
            .frame(height: UIScreen.main.bounds.height * 0.8)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButtom(action: dismiss)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            vm.getFrames(orientation: orientation)
        }
    }
}

struct FrameScreen_Previews: PreviewProvider {
    static var previews: some View {
        FrameScreen(name: "Test Name", eventHostName: "Test Host Name", date: "Test Date", location: "Test Location", orientation: .landscape, camera: .back)
    }
}

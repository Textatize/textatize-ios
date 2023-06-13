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
    
    @Binding var path: [Int]
     
    @State var frameSelected = false
    @State var selectedFrame: Frame? = nil
    
    var event: Event? = nil
    @State var name: String
    @State var eventHostName: String
    @State var date: String
    @State var location: String
    @State var orientation: Orientation
    @State var camera: Camera
    
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
                            
                            if let event = event {
                                if let selectedFrame = selectedFrame {
                                    Text("Selected Frame:")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    FrameSelectionCard(frameSelected: $selectedFrame, frame: selectedFrame)
                                        .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30, height: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30)
                                        .padding()


                                }
                            } else {
                                if let selectedFrame = selectedFrame {
                                    Text("Selected Frame:")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    FrameSelectionCard(frameSelected: $selectedFrame, frame: selectedFrame)
                                        .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30, height: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30)
                                        .padding()


                                }
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
                                CheckAllInfoScreen(path: $path, event: event, name: name, date: "10/11/12", location: location, orientation: orientation, camera: camera, hostName: eventHostName, watermarkImage: watermarkImage!, watermarkTransparency: watermarkTransparency, watermarkPosition: watermarkPosition, frame: selectedFrame)
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
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButtom(action: dismiss)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            vm.getFrames(orientation: orientation)
            if let event = event {
                watermarkPosition = event.getWatermarkPosition
                watermarkTransparency = event.getWatermarkTransparency
                if let frame = event.frame {
                    selectedFrame = frame
                    frameSelected = true
                }
            }
        }
    }
}

struct FrameScreen_Previews: PreviewProvider {
    static var previews: some View {
        FrameScreen(path: .constant([1]), name: "Test Name", eventHostName: "Test Host Name", date: "Test Date", location: "Test Location", orientation: .landscape, camera: .back)
    }
}

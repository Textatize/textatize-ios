//
//  FrameScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI

struct FrameScreen: View {
    @StateObject private var vm = FrameSelectionViewModel.shared
    @StateObject private var mvm = EventViewModel.shared
    
    @Binding var path: [Int]
    var event: Event? = nil
    
    let isiPad = UIDevice.current.userInterfaceIdiom == .pad
    
    @State var frameSelected = false
    @State var selectedFrame: Frame? = nil
    
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
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
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
                            
                            if event != nil {
                                if let selectedFrame = selectedFrame {
                                    Text("Selected Frame:")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    FrameSelectionCard(frameSelected: $selectedFrame, frame: selectedFrame, frameImage: vm.getFrameImage(frame: selectedFrame))
                                        .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30, height: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30)
                                        .padding()
                                    
                                    
                                }
                            } else {
                                if let selectedFrame = selectedFrame {
                                    Text("Selected Frame:")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    FrameSelectionCard(frameSelected: $selectedFrame, frame: selectedFrame, frameImage: vm.getFrameImage(frame: selectedFrame))
                                        .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30, height: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30)
                                        .padding()
                                    
                                    
                                }
                            }
                            
                            
                            Text("Your Frames:")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(vm.frames) { frame in
                                        FrameSelectionCard(frameSelected: $selectedFrame, frame: frame, frameImage: vm.getFrameImage(frame: frame))
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
                            
                            
                            
                        }
                        
                        Button {
                            if selectedFrame == nil {
                                withAnimation {
                                    alertTitle = "Frame Error"
                                    alertMessage = "Select a Frame"
                                    showAlert = true
                                }
                            } else {
                                mvm.frameName = name
                                mvm.frameDate = date
                                mvm.frameLocation = location
                                mvm.FrameCamera = camera
                                mvm.frameOrientation = orientation
                                mvm.frameHostName = name
                                mvm.frameWatermarkPosition = watermarkPosition
                                mvm.frameWatermarkTransparency = watermarkTransparency
                                mvm.selectedFrame = selectedFrame
                                path.append(4)
                            }
                        } label: {
                            CustomButtonView(filled: true, name: "Next")
                                .padding()
                        }
                        
                    }
                    .padding()
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                }
            }
            .customBackground()
            
            BackButton(path: $path)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
            
        }
        .navigationBarHidden(true)
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
        .alert(alertTitle, isPresented: $showAlert) {
            Button(role: .cancel) {
                print("Dismiss Selected")
            } label: {
                Text("Dismiss")
            }
        } message: {
            Text(alertMessage)
        }
    }
}

struct FrameScreen_Previews: PreviewProvider {
    static var previews: some View {
        FrameScreen(path: .constant([3]), name: "Test Name", eventHostName: "Test Host Name", date: "Test Date", location: "Test Location", orientation: .landscape, camera: .back)
    }
}

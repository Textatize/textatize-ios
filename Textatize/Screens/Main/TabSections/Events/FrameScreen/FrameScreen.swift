//
//  FrameScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI
import Kingfisher

struct FrameScreen: View {
    @StateObject private var vm = FrameSelectionViewModel.shared
    @StateObject private var mvm = EventViewModel.shared
    
    @Binding var path: [Int]
    var event: Event? = nil
    
    let isiPad = UIDevice.current.userInterfaceIdiom == .pad
    
    @State var selectedFrame: Frame? = nil
    @State var frameSelected = false
    
    @State var selectedWatermark: UIImage? = nil
    @State var watermarkSelected = false
    
    @State var orientation: Orientation
    
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
    @State private var deleteOption = false
    @State private var showingImagePicker = false
    
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
                            
                            if !watermarkSwitch {
                                if event != nil {
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
                                        ForEach(vm.frames) { frame in
                                            FrameSelectionCard(frameSelected: $selectedFrame, frame: frame)
                                                .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30, height: isiPad ?  UIScreen.main.bounds.width * 0.20 : UIScreen.main.bounds.width * 0.30)
                                                .padding()
                                        }
                                        
                                    }
                                }
                                .padding(.bottom)
                            }

                            
                            
                            Toggle(watermarkSwitch ? "Add Frame" : "Add Watermark" , isOn: $watermarkSwitch.animation())
                                .padding()
                                .tint(AppColors.Onboarding.topColor)
                            
                            if watermarkSwitch {
                                VStack(spacing: 20) {
                                    
                                    Text("Watermark")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    if let image = selectedWatermark {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 150, height: 150)
                                    }
                                   
                                    
                                    HStack(spacing: 20) {
                                        Text("Position")
                                        
                                        HStack {
                                            Button {
                                                withAnimation {
                                                    watermarkPosition = .bottomLeft
                                                }
                                            } label: {
                                                    AppImages.position1
                                                        .renderingMode(.template)
                                                        .scaleEffect(watermarkPosition == .bottomLeft ? 1.25 : 1)
                                                        .foregroundColor(watermarkPosition == .bottomLeft ? AppColors.Onboarding.bottomColor : AppColors.Onboarding.topColor)
                                                        .padding(5)
                                            }
                                            
                                            Button {
                                                withAnimation {
                                                    watermarkPosition = .bottomRight
                                                }
                                            } label: {
                                                AppImages.position2
                                                    .renderingMode(.template)
                                                    .scaleEffect(watermarkPosition == .bottomRight ? 1.25 : 1)
                                                    .foregroundColor(watermarkPosition == .bottomRight ? AppColors.Onboarding.bottomColor : AppColors.Onboarding.topColor)
                                                    .padding(5)
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
                                        Button {
                                            withAnimation {
                                                showingImagePicker = true
                                            }
                                        } label: {
                                            CustomButtonView(filled: true, name: "Upload New")
                                        }
                                        
                                        Button {
                                            alertTitle = "Delete"
                                            alertMessage = "Are you sure you want to delete this watermark Image?"
                                            deleteOption = true
                                            withAnimation {
                                                showAlert = true
                                            }
                                        } label: {
                                            CustomButtonView(filled: false, name: "Delete")
                                                .padding()
                                        }
                                        
                                    }
                                    
                                }
                                .padding(.top)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                
                            }
                            
                            Spacer()
                        }
                        
                        Button {
                            
                            if selectedFrame == nil && selectedWatermark == nil {
                                withAnimation {
                                    alertTitle = "Error"
                                    alertMessage = "Please Select a Frame or Watermark Image"
                                    showAlert = true
                                }
                            } else {
                                if frameSelected {
                                    if let frame = selectedFrame {
                                        mvm.selectedFrame = frame
                                        mvm.addon = .frame
                                        print("Using Frame")
                                    } else {
                                        mvm.addon = nil
                                        print("Using Nothing")
                                    }
                                } else if watermarkSelected {
                                    if let watermark = selectedWatermark {
                                        mvm.selectedWatermark = watermark
                                        mvm.addon = .watermark
                                        print("Using Watermark")
                                    }
                                }
                                
                               
                                mvm.watermarkPosition = watermarkPosition
                                mvm.watermarkTransparency = watermarkTransparency
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
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $watermarkImage)
        }
        .onChange(of: watermarkImage, perform: { _ in
            if let image = watermarkImage {
                selectedWatermark = image
            } else {
                selectedWatermark = nil
            }
        })
        .onChange(of: selectedFrame) { _ in
            if let frame = selectedFrame {
                frameSelected = true
            }
        }
        .onChange(of: selectedWatermark) { _ in
            if let watermark = selectedWatermark {
                watermarkSelected = true
            } else {
                watermarkSelected = false
            }
        }
        .onChange(of: watermarkSwitch) { _ in
            if watermarkSwitch {
                frameSelected = false
                watermarkSelected = true
            } else {
                frameSelected = true
                watermarkSelected = false
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            vm.getFrames(orientation: orientation)
            if let event = event {
                watermarkPosition = event.getWatermarkPosition
                watermarkTransparency = event.getWatermarkTransparency
                
                switch event.getUseFrame {
                case true:
                    watermarkSwitch = false
                case false:
                    watermarkSwitch = true
                }
                
                if let watermark = event.watermarkUrl {
                    guard let watermarkURL = URL(string: watermark) else { return }
                    KingfisherManager.shared.retrieveImage(with: watermarkURL) { response in
                        switch response {
                        case .success(let value):
                            selectedWatermark = value.image
                            mvm.addon = .watermark
                        case .failure:
                            selectedWatermark = nil
                            mvm.selectedWatermark = nil
                        }
                    }
                    // get and update watermark image
                } else {
                    selectedWatermark = nil
                    mvm.selectedWatermark = nil
                }
                
                if let frame = event.frame {
                    selectedFrame = frame
                    mvm.addon = .frame
                } else {
                    selectedFrame = nil
                    mvm.selectedFrame = nil
                }
            }
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button(role: .cancel) {
                print("Dismiss Selected")
            } label: {
                Text("Dismiss")
            }
            if deleteOption {
                Button(role: .destructive) {
                    withAnimation {
                        selectedWatermark = nil
                        mvm.selectedWatermark = nil
                    }
                    deleteOption = false
                } label: {
                    Text("Delete")
                }
            }

        } message: {
            Text(alertMessage)
        }
    }
}

struct FrameScreen_Previews: PreviewProvider {
    static var previews: some View {
        FrameScreen(path: .constant([3]), orientation: .landscape)
    }
}

//
//  CheckAllInfoScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI

struct CheckAllInfoScreen: View {
    @StateObject private var vm = CheckInfoViewModel()

    @Binding var path: [Int]
    
    var event: Event? = nil
    
    var name: String
    var date: String?
    var location: String
    var orientation: Orientation
    var camera: Camera
    var hostName: String
    var watermarkImage: UIImage? = nil
    var watermarkTransparency: Double
    var watermarkPosition: WatermarkPosition
    var frame: Frame? = nil
    var addon: AddOn? = nil
    @State var useFrame: String = ""
    
    var body: some View {
        ZStack {
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea(edges: .top)
            
            VStack {
                
                Text("Check all Information")
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                    .padding(.vertical, 20)
                
                Spacer()
                
                ScrollView {
                    VStack {
                        HStack {
                            
                            VStack(spacing: 10) {
                                VStack {
                                    Text("Event Name")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.subheadline.bold())
                                    Text(name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.caption)
                                }
                                
                                
                                VStack {
                                    Text("Event Date")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.subheadline.bold())
                                    if let date = date {
                                        Text(date)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.caption)
                                    }
                                }
                                
                                VStack {
                                    Text("Event Location")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.subheadline.bold())
                                    Text(location)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.caption)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 10) {
                                VStack {
                                    Text("Event Orientation")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.subheadline.bold())
                                    Text(orientation.rawValue)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.caption)
                                }
                                
                                VStack {
                                    Text("Event Camera")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.subheadline.bold())
                                    Text(camera.rawValue)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.caption)
                                }
                                
                                VStack {
                                    Text("Event Host")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.subheadline.bold())
                                    Text(name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.caption)
                                }
                                
                                
                            }
                        }
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .padding(.horizontal)
                        
                        if frame != nil {
                            Text("Frame")
                                .font(.headline)
                                .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                            
                            if let frame = frame {
                                if let frameImage = vm.getFrameImage(frame: frame) {
                                    frameImage
                                        .resizable()
                                        .frame(width: 75, height: 75)
                                }
                            }
                        }
                        
                        if watermarkImage != nil {
                            Text("Watermark")
                                .font(.headline)
                                .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                            
                            if let watermarkImage = watermarkImage {
                                    Image(uiImage: watermarkImage)
                                        .resizable()
                                        .frame(width: 75, height: 75)
                            }
                        }
                    }
                }
                
                Spacer()
                
                if let event = event {
                    CustomButtonView(filled: true, name: "Update")
                        .padding()
                        .onTapGesture {
                            if let eventID = event.unique_id {
                                vm.updateEvent(eventID: eventID, date: date, name: name, orientation: orientation, camera: camera, watermarkPosition: watermarkPosition, location: location, watermarkImage: watermarkImage, watermarkTransparency: String(watermarkTransparency), frame: frame, useFrame: useFrame)
                                path.removeAll()
                            }
                        }
                } else {
                    CustomButtonView(filled: true, name: "Save")
                        .padding()
                        .onTapGesture {
                            vm.createEvent(name: name, date: date, orientation: orientation, camera: camera, watermarkPosition: watermarkPosition, location: location, watermarkImage: watermarkImage, watermarkTransparency: String(watermarkTransparency), frame: frame, useFrame: useFrame)
                            path.removeAll()
                        }
                    
                }
            }
            .customBackground()
            
            BackButton(path: $path)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
        }
        .onAppear {
            switch addon {
            case .frame:
                useFrame = "true"
            case .watermark:
                useFrame = "false"
            case nil:
                break
            }


        }
        .navigationBarHidden(true)
    }
}

struct CheckAllInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        CheckAllInfoScreen(path: .constant([4]), name: "Holidays", date: "10/11/12", location: "Rome", orientation: .portrait, camera: .front, hostName: "Anna", watermarkImage: UIImage(systemName: "person")!, watermarkTransparency: 0.50, watermarkPosition: .bottomRight)
    }
}

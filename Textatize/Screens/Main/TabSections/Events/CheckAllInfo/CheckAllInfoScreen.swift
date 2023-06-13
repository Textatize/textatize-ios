//
//  CheckAllInfoScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI

struct CheckAllInfoScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var vm = CheckInfoViewModel()
    
    @Binding var path: [Int]
    
    var event: Event? = nil
        
    var name: String
    var date: String
    var location: String
    var orientation: Orientation
    var camera: Camera
    var hostName: String
    var watermarkImage: UIImage
    var watermarkTransparency: Double
    var watermarkPosition: WatermarkPosition
    var frame: Frame? = nil
    
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
                
                Spacer()
                
                ScrollView {
                    VStack {
                        
                        Text("Description")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .padding()
                        
                        
                        HStack(spacing: 0) {
                            
                            Spacer()
                            
                            VStack(spacing: 15) {
                                Group {
                                    VStack {
                                        Text("Name ")
                                            .font(.subheadline.bold())
                                        Text(name)
                                            .font(.caption)
                                    }
                                    
                                    VStack {
                                        Text("Date ")
                                            .font(.subheadline.bold())
                                        Text(date)
                                            .font(.caption)
                                    }
                                    
                                    VStack {
                                        Text("Location ")
                                            .font(.subheadline.bold())
                                        Text(location)
                                            .font(.caption)
                                    }
                                   
                                }
                            }
                            
                            Spacer()
                            Spacer()
                            
                            VStack(spacing: 15) {
                                
                                Group {
                                    VStack {
                                        Text("Orientation ")
                                            .font(.subheadline.bold())

                                        Text("\(orientation.rawValue)")
                                            .font(.caption)
                                    }
                                    
                                    VStack {
                                        Text("Camera ")
                                            .font(.subheadline.bold())

                                        Text("\(camera.rawValue)")
                                            .font(.caption)
                                    }
                                    
                                    VStack {
                                        Text("Host Name ")
                                            .font(.subheadline.bold())

                                        Text(hostName)
                                            .font(.caption)
                                    }
                                   
                                }
                                
                            }
                            
                            Spacer()
                        }
                        
                        Text("Frame")
                            .font(.headline)
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        
                        if let frame = frame {
                            if let frameImage = vm.getFrameImage(frame: frame) {
                                frameImage
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                        }

//                        HStack {
//                            ForEach(0..<3) { _ in
//                                Image(systemName: "photo")
//                                    .resizable()
//                                    .padding()
//                                    .frame(width: UIScreen.main.bounds.width * 0.20, height: UIScreen.main.bounds.width * 0.20)
//                            }
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.horizontal)
                        
                        Text("Gallery")
                            .font(.headline)
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()

                        HStack {
                            ForEach(0..<3) { _ in
                                Image(systemName: "photo")
                                    .resizable()
                                    .padding()
                                    .frame(width: UIScreen.main.bounds.width * 0.20, height: UIScreen.main.bounds.width * 0.20)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    }
                }
                
                Spacer()
                
                if let event = event {
                    CustomButtonView(filled: true, name: "Update")
                        .padding()
                        .onTapGesture {
                            if let eventID = event.unique_id {
                                vm.updateEvent(eventID: eventID, name: name, orientation: orientation, camera: camera, watermarkPosition: watermarkPosition, location: location, watermarkImage: watermarkImage, watermarkTransparency: String(watermarkTransparency), frame: frame)
                                path.removeAll()
                            }
                        }
                } else {
                    CustomButtonView(filled: true, name: "Save")
                        .padding()
                        .onTapGesture {
                            vm.createEvent(name: name, orientation: orientation, camera: camera, watermarkPosition: watermarkPosition, location: location, watermarkImage: watermarkImage, watermarkTransparency: String(watermarkTransparency), frame: frame)
                            path.removeAll()
                        }

                }                
            }
            .customBackground()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 20, height: 15)
                    .accentColor(AppColors.Onboarding.loginScreenForegroundColor)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            .padding(.leading)
        }
        .navigationBarHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                CustomBackButtom(action: dismiss)
//            }
//        }
        .navigationBarBackButtonHidden()
    }
}

//struct CheckAllInfoScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckAllInfoScreen(name: "Holidays", date: "10/11/12", location: "Rome", orientation: .portrait, camera: .front, hostName: "Anna", watermarkImage: UIImage(systemName: "person")!, watermarkTransparency: 0.50, watermarkPosition: .bottomRight)
//    }
//}

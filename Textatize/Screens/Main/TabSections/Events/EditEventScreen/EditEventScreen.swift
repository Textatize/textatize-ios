//
//  EditEventScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct EditEventScreen: View {
    @StateObject private var mvm = EventViewModel.shared

    
    @Binding var path: [Int]
    
    var event: Event? = nil
   
    @State private var eventName: String = ""
    @State private var eventHostName: String = ""
    @State private var eventDate: String = ""
    @State private var eventLocation: String = ""
    @State private var orientation: Orientation = .portrait
    @State private var camera: Camera = .back
    
    @State private var nextButtonPressed = false

    var orientationOptions: [Orientation] = [.landscape, .portrait, .square]
    var cameraOptions: [Camera] = [.front, .back]
    
    var body: some View {
        ZStack {
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea(edges: .top)
            
            VStack {
                
                Spacer()
                
                Text("Edit Event")
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                
                ScrollView {
                    VStack(spacing: 10) {
                        
                        HStack {
                            Group {
                                VStack(spacing: 10) {
                                    Text("Editing on event")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("Next Step: Frame")
                                        .font(.caption2)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            
                            AppImages.diagramIcon
                                .overlay {
                                    Text("1 of 2")
                                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                                }
                            
                        }
                        
                        
                        VStack(alignment: .leading) {
                            
                            VStack(alignment: .leading) {
                                Text("Name")
                                    .font(.caption)
                                
                                TextField("Enter the name of event", text: $eventName)
                                    .padding()
                                    .frame(height: 50)
                                    .onboardingBorder()
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Date")
                                    .font(.caption)
                                
                                TextField("Choose the date", text: $eventDate)
                                    .padding()
                                    .frame(height: 50)
                                    .onboardingBorder()
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Location")
                                    .font(.caption)
                                
                                TextField("Choose the location", text: $eventLocation)
                                    .padding()
                                    .frame(height: 50)
                                    .onboardingBorder()
                            }
                            
                        }
                        .padding(.bottom, 5)
                        
                        Text("Orientation")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.caption)
                        
                        HStack(spacing: 15) {
                            ForEach(0..<orientationOptions.count) { item in
                                
                                HStack {
                                    Button {
                                        withAnimation {
                                            orientation = orientationOptions[item]
                                        }
                                    } label: {
                                        Circle()
                                            .fill(AppColors.Onboarding.loginButton)
                                            .frame(width: 20, height: 20)
                                            .overlay {
                                                Circle()
                                                    .fill(.white)
                                                    .frame(width: 30)
                                                
                                            }
                                            .overlay {
                                                if orientation == orientationOptions[item] {
                                                    Circle()
                                                        .fill(AppColors.Onboarding.loginButton)
                                                        .frame(width: 10)
                                                }
                                            }
                                        
                                    }
                                    Text(orientationOptions[item].rawValue)
                                        .font(.caption2)
                                }
                                
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        Text("Camera")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.caption)
                        
                        HStack(spacing: 15) {
                            ForEach(0..<cameraOptions.count) { item in
                                
                                HStack {
                                    Button {
                                        withAnimation {
                                            camera = cameraOptions[item]
                                        }
                                    } label: {
                                        Circle()
                                            .fill(AppColors.Onboarding.loginButton)
                                            .frame(width: 20, height: 20)
                                            .overlay {
                                                Circle()
                                                    .fill(.white)
                                                    .frame(width: 30)
                                                
                                            }
                                            .overlay {
                                                if camera == cameraOptions[item] {
                                                    Circle()
                                                        .fill(AppColors.Onboarding.loginButton)
                                                        .frame(width: 10)
                                                }
                                            }
                                    }
                                    Text(cameraOptions[item].rawValue)
                                        .font(.caption2)
                                }
                                
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Event host name")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("Enter the host's name", text: $eventHostName)
                            .padding()
                            .frame(height: 50)
                            .onboardingBorder()
                        
                        Spacer()
                        
                        Button {
                            mvm.editName = eventName
                            mvm.editDate = eventDate
                            mvm.editLocation = eventLocation
                            mvm.editCamera = camera
                            mvm.editOrientation = orientation
                            mvm.editHostName = eventName
                            path.append(3)
                        } label: {
                            CustomButtonView(filled: true, name: "Next")
                                .padding()
                        }
                        

//                
//                        
//                        NavigationLink(isActive: $editEventView) {
//                            FrameScreen(rootView: $rootView, frameView: $frameView, checkInfoView: $checkInfoView, event: event, name: eventName, eventHostName: eventHostName, date: eventDate, location: eventLocation, orientation: orientation, camera: camera)
//                        } label: {
//                            CustomButtonView(filled: true, name: "Next")
//                                .padding()
//                            
//                        }
                    }
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .padding()
                }
                
            }
            .customBackground()
            
            BackButton(path: $path)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
        }
        .navigationBarHidden(true)
        .onAppear {
            if let event = event {
                eventName = event.getName
                eventDate = event.getDate
                eventLocation = event.getLocation
                orientation = event.getOrientation
                camera = event.getCamera
            }
        }
    }
}

struct EditEventScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditEventScreen(path: .constant([1]))
    }
}

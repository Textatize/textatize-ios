//
//  NewEventScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct NewEventScreen: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var eventName = ""
    @State private var eventDate = ""
    @State private var eventHostName = ""
    @State private var orientationSelected = "Portrait"
    @State private var cameraSelected = "Front"
    @State private var nextButtonPressed = false
    
    var orientationOptions = ["Portrait", "Landscape", "Square"]
    var cameraOptions = ["Front", "Rear"]
    
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
                
                Spacer()
                
                Text("New Event")
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                
                VStack(spacing: 10) {
                    
                    HStack {
                        Group {
                            VStack(spacing: 10) {
                                Text("Editing on event")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("Next Step: Template")
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
                            
                            TextField("Choose the location", text: $eventDate)
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
                                        orientationSelected = orientationOptions[item]
                                    }
                                } label: {
                                    Circle()
                                        .fill(AppColors.Onboarding.loginButton)
                                        .frame(width: 25)
                                        .overlay {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 20)
                                        }
                                        .overlay {
                                            if orientationSelected == orientationOptions[item] {
                                                Circle()
                                                    .fill(AppColors.Onboarding.loginButton)
                                                    .frame(width: 10)
                                            }
                                        }
                                        

                                }
                                Text(orientationOptions[item])
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
                                        cameraSelected = cameraOptions[item]
                                    }
                                } label: {
                                    Circle()
                                        .fill(AppColors.Onboarding.loginButton)
                                        .frame(width: 25)
                                        .overlay {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 20)
                                        }
                                        .overlay {
                                            if cameraSelected == cameraOptions[item] {
                                                Circle()
                                                    .fill(AppColors.Onboarding.loginButton)
                                                    .frame(width: 10)
                                            }
                                        }
                                        

                                }
                                Text(orientationOptions[item])
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
                       print("Create Event Pressed")
                        nextButtonPressed = true
                    } label: {
                        CustomButtonView(filled: true, name: "Next")
                    }

                    
                }
                .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                .padding()

            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal)
            .fullScreenCover(isPresented: $nextButtonPressed) {
                FrameScreen()
            }
        }
    }
}

struct NewEventScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewEventScreen()
    }
}

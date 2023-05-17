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
    @State private var orientationSelected = "Portrait"
    @State private var cameraSelected = "Front"
    
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
                
                VStack(spacing: 15) {
                    
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
                    .padding(.bottom, 10)
                    
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
                                        .frame(width: 30)
                                        .overlay {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 25)
                                        }
                                        .overlay {
                                            if orientationSelected == orientationOptions[item] {
                                                Circle()
                                                    .fill(AppColors.Onboarding.loginButton)
                                                    .frame(width: 15)
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
                                        .frame(width: 30)
                                        .overlay {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 25)
                                        }
                                        .overlay {
                                            if cameraSelected == cameraOptions[item] {
                                                Circle()
                                                    .fill(AppColors.Onboarding.loginButton)
                                                    .frame(width: 15)
                                            }
                                        }
                                        

                                }
                                Text(orientationOptions[item])
                                    .font(.caption2)
                            }
                            
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Button {
                       print("Create Event Pressed")
                    } label: {
                        CustomButtonView(filled: true, name: "Create")
                    }

                    Spacer()
                    
                }
                .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                .padding()

                
               
                
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal)
        }
    }
}

struct NewEventScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewEventScreen()
    }
}

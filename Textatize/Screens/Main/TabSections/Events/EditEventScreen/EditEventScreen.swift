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
    @State private var eventLocation: String = ""
    @State private var orientation: Orientation = .portrait
    @State private var camera: Camera = .back
    
    @State private var date: Date = Date.now
    
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
                                
                                DatePicker("Choose Date", selection: $date, in: Date.now..., displayedComponents: .date)
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
                            
                            if getDateString(date: date) != getDateString(date: yesterdayDate()) {
                                mvm.date = getDateString(date: date)
                            } else {
                                mvm.date = ""
                                print("No Date Selected")
                            }
                            mvm.name = eventName
                            mvm.location = eventLocation
                            mvm.camera = camera
                            mvm.orientation = orientation
                            mvm.hostName = eventName
                            path.append(3)
                        } label: {
                            CustomButtonView(filled: true, name: "Next")
                                .padding()
                        }
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
            date = yesterdayDate()
            if let event = event {
                eventName = event.getName
                eventLocation = event.getLocation
                orientation = event.getOrientation
                camera = event.getCamera
            }
        }
    }

    func getDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    func yesterdayDate() -> Date {
        var components = DateComponents()
        components.day = -1
        return Calendar.current.date(byAdding: components, to: Date.now)!
    }
    
    
}

struct EditEventScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditEventScreen(path: .constant([1]))
    }
}

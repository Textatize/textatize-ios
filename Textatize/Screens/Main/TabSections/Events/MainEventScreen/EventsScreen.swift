//
//  EventsScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct EventsScreen: View {
    @StateObject private var vm = EventViewModel.shared
    
    let isiPad = UIDevice.current.userInterfaceIdiom == .pad
    
    let iPadLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let iPhoneLayout = [
        GridItem(.flexible())
    ]
        
    @State private var path = [Int]()
    @State private var selectedEvent: Event? = nil    
        
    @State private var currentSelected: Bool = true
    @State private var search = ""
    
    var segmentTitles = ["Current", "Completed"]
    
    var body: some View {
        NavigationStack(path: $path) {
            
            ZStack {
                AppColors.Onboarding.redLinearGradientBackground
                    .ignoresSafeArea(edges: .top)
                
                VStack {
                    
                    AppImages.TabView.logo1
                        .resizable()
                        .frame(width: 125, height: 40)
                        .padding()
                    
                    VStack {
                        Text(vm.firstName)
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .font(.title)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        
                        
                        Group {
                            HStack {
                                
                                VStack {
                                    HStack {
                                        
                                        Spacer()
                                        
                                        Button {
                                            
                                            withAnimation {
                                                currentSelected = true
                                            }
                                            
                                        } label :{
                                            Text("Current")
                                                .font(.headline)
                                                .foregroundColor(AppColors.Onboarding.loginButton)
                                        }
                                        
                                        Spacer()
                                        
                                        Button {
                                            
                                            withAnimation {
                                                currentSelected = false
                                            }
                                            
                                        } label :{
                                            Text("Complete")
                                                .font(.headline)
                                                .foregroundColor(AppColors.Onboarding.loginButton)
                                        }
                                        
                                        Spacer()
                                        
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(AppColors.Onboarding.topColor)
                                            .frame(height: 10)
                                            .padding(.horizontal)
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(AppColors.Onboarding.bottomColor)
                                            .frame(width: UIScreen.main.bounds.width * 0.4, height: 10)
                                            .frame(maxWidth: .infinity, alignment: currentSelected ? .leading : .trailing)
                                            .padding(.horizontal)
                                    }
                                }
                                
                            }
                            
                            HStack {
                                TextField("\(Image(systemName: "magnifyingglass")) Search", text: $search)
                                    .padding()
                                    .frame(width: UIScreen.main.bounds.width * 0.4, height: 40)
                                    .onboardingBorder()
                                
                                Spacer()
                                
                                Text("All Events")
                                    .font(.headline)
                                    .foregroundColor(AppColors.Onboarding.loginButton)
                                    .padding()
                                
                            }
                            .padding()
                        }
                        
                        ScrollView {
                            
                            VStack {
                                
                                Button {
                                    selectedEvent = nil
                                    path.append(1)
                                } label: {
                                    EventCard(new: true)
                                        .padding()
                                }
                                
                                ForEach(currentSelected ? vm.events : vm.completedEvents) { event in
                                    Button {
                                        selectedEvent = event
                                        path.append(2)
                                    } label: {
                                        EventCard(new: false, title: event.getName, date: event.getDate)
                                            .padding()
                                    }
                                }
                            }
                        }
                    }
                }
                .customBackground()
            }
            .navigationBarHidden(true)
            .navigationDestination(for: Int.self) { item in
                if item == 1 {
                    EditEventScreen(path: $path, event: selectedEvent)
                }
                if item == 2 {
                    EventDetailScreen(path: $path, event: selectedEvent)
                }
                if item == 3 {
                    FrameScreen(path: $path, event: selectedEvent, name: vm.editName, eventHostName: vm.editHostName, date: vm.editDate, location: vm.editLocation, orientation: vm.editOrientation, camera: vm.editCamera)
                }
                
                if item == 4 {
                    CheckAllInfoScreen(path: $path, event: selectedEvent, name: vm.frameName, date: vm.frameDate, location: vm.frameLocation, orientation: vm.frameOrientation, camera: vm.FrameCamera, hostName: vm.frameName, watermarkTransparency: vm.frameWatermarkTransparency, watermarkPosition: vm.frameWatermarkPosition, frame: vm.selectedFrame)
                }
                if item == 5 {
                    if let event = selectedEvent, let frame = event.frame {
                        CameraView(event: event, frame: frame)
                    }
                }
            }
            .onAppear {
                selectedEvent = nil
                path.removeAll()
                vm.refreshEvents()
            }
        }
    }
}

struct EventsScreen_Previews: PreviewProvider {
    static var previews: some View {
        EventsScreen()
    }
}

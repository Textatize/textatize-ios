//
//  EventsScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct EventsScreen: View {
    @StateObject private var vm = EventViewModel.shared
    @StateObject private var dm = DataManager.shared
    
    var frames = [Frame]()
    
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
    
    let isiPad = UIDevice.current.userInterfaceIdiom == .pad

    var eventItems = [1, 2, 3, 4, 5, 6, 7]
    
    @State private var createNewEventPressed: Bool = false
    @State private var eventPressed: Bool = false
    
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
                        
                        
                        Group {
                            ScrollView {
                                if currentSelected {
                                    LazyVGrid(columns: isiPad ? iPadLayout : iPhoneLayout, spacing: 20) {
                                        ForEach(0..<vm.events.count + 1, id: \.self) { item in
                                            if item == 0 {
                                                Button {
                                                    path.removeAll()
                                                    selectedEvent = nil
                                                    path.append(1)
                                                } label: {
                                                    EventCard(new: true, eventSelected: $createNewEventPressed)
                                                }
                                                
                                                
                                            } else {
                                                
                                                let event = vm.events[item - 1]
                                                
                                                Button {
                                                    path.removeAll()
                                                    dm.event = event

                                                    path.append(2)
                                                } label: {
                                                    EventCard(new: false, eventSelected: $eventPressed, title: event.getName, date: event.getDate)
                                                }
                                                
//                                                NavigationLink {
//                                                    EventDetailScreen(path: $path, event: event, name: event.getName, date: event.getDate, location: event.getLocation, orientation: event.getOrientation.rawValue, camera: event.getCamera.rawValue, hostName: event.getName)
//                                                } label: {
//                                                    EventCard(new: false, eventSelected: $eventPressed, title: event.getName, date: event.getDate)
//
//                                                }
                                            }
                        
                                            
                                        }
                                        
                                    }
                                    .padding()
                                } else {
                                    
                                    LazyVGrid(columns: isiPad ? iPadLayout : iPhoneLayout, spacing: 20) {
                                        ForEach(0..<vm.completedEvents.count + 1, id: \.self) { item in
                                            if item == 0 {
                                                Button {
                                                    path.removeAll()
                                                    selectedEvent = nil
                                                    path.append(1)
                                                } label: {
                                                    EventCard(new: true, eventSelected: $createNewEventPressed)
                                                }
                                                
                                                
                                            } else {
                                                
                                                let event = vm.events[item - 1]
                                                
                                                Button {
                                                    path.removeAll()
                                                    dm.event = event

                                                    path.append(2)
                                                } label: {
                                                    EventCard(new: false, eventSelected: $eventPressed, title: event.getName, date: event.getDate)
                                                }
                                                
//                                                NavigationLink {
//                                                    EventDetailScreen(path: $path, event: event, name: event.getName, date: event.getDate, location: event.getLocation, orientation: event.getOrientation.rawValue, camera: event.getCamera.rawValue, hostName: event.getName)
//                                                } label: {
//                                                    EventCard(new: false, eventSelected: $eventPressed, title: event.getName, date: event.getDate)
//
//                                                }
                                            }
                                            
                                        }
                                        
                                    }
                                    .padding()
                                    
                                }

                                
                            }
                        }
                    }
                }
                .customBackground()
            }
            .navigationDestination(for: Int.self) { int in
                
                if path == [1] {
                    EditEventScreen(path: $path)
                } else {
                    EventDetailScreen(path: $path, event: dm.event!, name: dm.event!.getName, date: dm.event!.getDate, location: dm.event!.getLocation, orientation: dm.event!.getOrientation.rawValue, camera: dm.event!.getCamera.rawValue, hostName: dm.event!.getName)

                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            selectedEvent = nil
            vm.refreshEvents()
        }
    }
}

struct EventsScreen_Previews: PreviewProvider {
    static var previews: some View {
        EventsScreen()
    }
}

//
//  EventsScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct EventsScreen: View {
    @StateObject private var vm = EventViewModel.shared
    
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
    @State var count = 1
    
    let isiPad = UIDevice.current.userInterfaceIdiom == .pad
    
    var eventItems = [1, 2, 3, 4, 5, 6, 7]
    
    @State private var createNewEventPressed: Bool = false
    @State private var eventPressed: Bool = false
    
    @State private var currentSelected: Bool = true
    @State private var search = ""
    
    @State private var rootView = false
    @State private var eventDetailView = false
    @State private var editEventView = false
    @State private var frameView = false
    @State private var checkInfoView = false

    @State private var EditScreen = false

    var segmentTitles = ["Current", "Completed"]
    
    var body: some View {
        NavigationView {
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
                                ForEach(0..<vm.events.count + 1, id: \.self) { item in
                                    NavigationLink(isActive: $rootView) {
                                        if item == 0 {
                                            EditEventScreen(rootView: $rootView, editEventView: $editEventView, frameView: $frameView, checkInfoView: $checkInfoView)
                                        } else {
                                            let event = vm.events[item - 1]
                                            EventDetailScreen(rootView: $rootView, eventDetailView: $eventDetailView, editEventView: $editEventView, frameView: $frameView, checkInfoView: $checkInfoView, event: event, name: event.getName, date: event.getDate, location: event.getLocation, orientation: event.getOrientation.rawValue, camera: event.getCamera.rawValue, hostName: event.getName)
                                        }
                                    } label: {
                                        if item == 0 {
                                            EventCard(new: true)
                                        } else {
                                            let event = vm.events[item - 1]
                                            EventCard(new: false, title: event.getName, date: event.getDate)

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
            .onAppear {
                rootView = false
                eventDetailView = false
                editEventView = false
                frameView = false
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

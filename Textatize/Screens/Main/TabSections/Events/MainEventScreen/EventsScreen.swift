//
//  EventsScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

enum AlertType {
    case delete, complete
}

struct EventsScreen: View {
    @StateObject private var vm = EventViewModel.shared
    
    @State var timer = Timer.publish(every: 60 * 60, on: .main, in: .common).autoconnect()

    let isiPad = UIDevice.current.userInterfaceIdiom == .pad
    
    let iPadLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let iPhoneLayout = [
        GridItem(.flexible())
    ]
    
    @State private var currentEvents = [Event]()
    @State private var completedEvents = [Event]()

    @State private var path = [Int]()
    @State private var selectedEvent: Event? = nil    
        
    @State private var currentSelected: Bool = true
    @State private var search = ""
    
    @State private var eventToDelete: Event? = nil
    @State private var eventToComplete: Event? = nil
    
    var segmentTitles = ["Current", "Completed"]
    
    @State private var presentAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertType: AlertType = .delete
        
    let sessionQue = DispatchQueue(label: "EventSelectionQueue")
    
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
                        Text(vm.loginManager.loggedInUser?.firstName ?? "No Name Found")
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
                                    vm.selectedEvent = nil
                                    path.append(1)
                                } label: {
                                    AddEventCard()
                                        .padding()
                                }
                                
                                ForEach(currentSelected ? 0..<vm.activeEvents.count : 0..<vm.completedEvents.count, id: \.self) {  eventIndex in
                                    Button {
                                        sessionQue.sync {
                                            vm.selectedEvent = currentSelected ? vm.activeEvents[eventIndex] : vm.completedEvents[eventIndex]
                                            path.append(2)
                                        }
                                    } label: {
                                        EventCard(event: currentSelected ? $vm.activeEvents[eventIndex] : $vm.completedEvents[eventIndex], eventToDelete: $eventToDelete, eventToComplete: $eventToComplete)
                                            .padding()
                                    }
                                }
                            }
                        }
                        .refreshable {
                            self.timer = Timer.publish(every: 60 * 60, on: .main, in: .common).autoconnect()
                            vm.refreshEvents()
                        }
                    }
                }
                .customBackground()
            }
            .onReceive(timer) { value in
                vm.refreshEvents()
            }
            .alert(alertTitle, isPresented: $presentAlert, actions: {
                if alertType == .delete {
                    Button(role: .destructive) {
                        if let event = eventToDelete {
                            deleteEvent(event: event)
                        }
                    } label: {
                        Text("Delete")
                    }
                }
                
                if alertType == .complete {
                    Button(role: .destructive) {
                        if let event = eventToComplete {
                            completeEvent(event: event)
                        }
                    } label: {
                        Text("Complete")
                    }
                }
                
                Button(role: .cancel) {
                    eventToDelete = nil
                    eventToComplete = nil
                } label: {
                    Text("Cancel")
                }


            }, message: {
                Text(alertMessage)
            })
            .navigationBarHidden(true)
            .navigationDestination(for: Int.self) { item in
                if item == 1 {
                    EditEventScreen(path: $path, event: vm.selectedEvent)
                }
                if item == 2 {
                    EventDetailScreen(path: $path, event: vm.selectedEvent!)
                }
                if item == 3 {
                    FrameScreen(path: $path, event: vm.selectedEvent, orientation: vm.orientation)
                }
                
                if item == 4 {
                    CheckAllInfoScreen(path: $path, event: vm.selectedEvent, name: vm.name, date: vm.date, location: vm.location, orientation: vm.orientation, camera: vm.camera, hostName: vm.hostName, watermarkImage: vm.selectedWatermark, watermarkTransparency: vm.watermarkTransparency, watermarkPosition: vm.watermarkPosition, frame: vm.selectedFrame, addon: vm.addon)
                }
                if item == 5 {
                    CameraView(path: $path, event: vm.selectedEvent!)
                }
                if item == 6 {
                    ImagePreviewScreen(path: $path, event: vm.selectedEvent!)
                }
            }
            .onAppear {
                path.removeAll()
            }
            .onChange(of: eventToDelete) { newValue in
                if let event = eventToDelete {
                    alertTitle = "Event Delete"
                    alertMessage = "Are you sure you want to Delete event: \(event.getName)"
                    alertType = .delete
                    presentAlert = true
                }
            }
            .onChange(of: eventToComplete) { newValue in
                if let event = eventToComplete {
                    alertTitle = "Event Complete"
                    alertMessage = "Are you sure you want to Complete event: \(event.getName)"
                    alertType = .complete
                    presentAlert = true
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    private func deleteEvent(event: Event) {
        vm.deleteEvent(event: event)
        eventToDelete = nil
    }
    private func completeEvent(event: Event) {
        vm.completeEvent(event: event)
        eventToComplete = nil

    }
}

struct EventsScreen_Previews: PreviewProvider {
    static var previews: some View {
        EventsScreen()
    }
}

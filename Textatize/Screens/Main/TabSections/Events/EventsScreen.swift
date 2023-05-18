//
//  EventsScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct EventsScreen: View {
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var eventItems = [1, 2, 3, 4, 5, 6, 7]
    
    @State private var createNewEventPressed: Bool = false
    @State private var eventPressed: Bool = false
    
    @State private var currentSelected: Bool = true
    @State private var search = ""
    
    var segmentTitles = ["Current", "Completed"]
    
    
    var body: some View {
        
        ZStack {
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea(edges: .top)
            
            VStack {
                
                AppImages.TabView.logo1
                    .resizable()
                    .frame(width: 125, height: 40)
                    .padding()
                
                VStack {
                    Text("Hello John!")
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
                            LazyVGrid(columns: layout, spacing: 20) {
                                ForEach(0..<10) { item in
                                    if item == 0 {
                                        EventCard(new: true, eventSelected: $createNewEventPressed)
                                            .frame(width: UIScreen.main.bounds.width * 0.40, height: UIScreen.main.bounds.width * 0.25)
                                    } else {
                                        EventCard(new: false, eventSelected: $eventPressed)
                                            .frame(width: UIScreen.main.bounds.width * 0.40, height: UIScreen.main.bounds.width * 0.25)

                                    }

                                }

                            }
                            .padding()

                        }

                    }
                }
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal)
            .fullScreenCover(isPresented: $createNewEventPressed, content: {
                NewEventScreen()
            })
            .fullScreenCover(isPresented: $eventPressed) {
                EventDetailScreen(name: "TestEvent", date: "TestDate", location: "TestLocation", orientation: "Portrait", camera: "TestCamera", hostName: "TestHost")
            }
        }
        
    }
}

struct EventsScreen_Previews: PreviewProvider {
    static var previews: some View {
        EventsScreen()
    }
}

//
//  EventsScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct EventsScreen: View {
    
    let layout = [
        GridItem(),
        GridItem()
    ]
    
    @State private var createNewEventPressed: Bool = false
    @State private var eventPressed: Bool = false

    @State private var currentSelected: Bool = true
    @State private var search = ""
    
    var segmentTitles = ["Current", "Completed"]

    
    var body: some View {
        GeometryReader { geo in 
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
                                        .frame(width: 280, height: 10)
                                        .padding(.horizontal, 20)
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(AppColors.Onboarding.bottomColor)
                                        .frame(width: 140, height: 10)
                                        .frame(maxWidth: .infinity, alignment: currentSelected ? .leading : .trailing)
                                        .padding(.horizontal, 20)
                                }
                                .padding(.horizontal, 20)
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        
                        HStack {
                            TextField("\(Image(systemName: "magnifyingglass")) Search", text: $search)
                                .padding()
                                .frame(width: 160, height: 40)
                                .onboardingBorder()
                            
                            Spacer()
                            
                            Text("All Events")
                                .font(.headline)
                                .foregroundColor(AppColors.Onboarding.loginButton)
                            
                        }
                        .padding()
                    
                        ScrollView {
                            LazyVGrid(columns: layout) {
                                ForEach(0..<8) { item in
                                    if item == 0 {
                                        NewEventCard(newEventPressed: $createNewEventPressed)
                                            .frame(width: geo.size.width * 0.4, height: geo.size.width * 0.3)
                                    } else {
                                       EventCard()
                                            .frame(width: geo.size.width * 0.4, height: geo.size.width * 0.3)
                                    }
                                    
                                   
                                }
                            }
                        }
                        
                    }
                    
                    
                }
                .fullScreenCover(isPresented: $createNewEventPressed, content: {
                    NewEventScreen()
                })
                .customBackground()
                .padding(.vertical, 45)
                .padding(.horizontal)
            }
        }
    }
}

struct EventsScreen_Previews: PreviewProvider {
    static var previews: some View {
        EventsScreen()
    }
}

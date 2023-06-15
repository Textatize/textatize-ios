//
//  EventCard.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

enum EventType {
    case completed, current
}

struct EventCard: View {
    
    var type: EventType
    var image: Image? = nil
    var title: String = "Holidays"
    var date: String = "10/11/22"
    var numberOfPhotos: String = "20"
    var event: Event
    @Binding var eventToDelete: Event?
    @Binding var eventToComplete: Event?

    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.20, height: UIScreen.main.bounds.width * 0.20)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    VStack {
                        if date != "" {
                            Text(date)
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        HStack(spacing: 5) {
                            Text(numberOfPhotos)
                                .foregroundColor(AppColors.Onboarding.loginButton)
                                .font(.subheadline)
                            
                            Text("photos")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                }
                .padding(.leading)
                .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                
            }
            .frame(maxWidth: .infinity)
            
            HStack(spacing: 5) {
                
                if type == .current {
                    Spacer()
                    Button {
                        print("Complete Pressed")
                        eventToComplete = event
                    } label: {
                        Text("Complete")
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Button {
                        print("Delete Pressed")
                        eventToDelete = event
                    } label: {
                        Text("Delete")
                            .font(.subheadline)
                    }
                    Spacer()
                }
                
                if type == .completed {
                    
                    Spacer()
                    
                    Button {
                        print("Delete Pressed")
                        eventToDelete = event
                    } label: {
                        Text("Delete")
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                }
            }
            .padding(.bottom)
            .frame(maxWidth: .infinity)
            .foregroundColor(AppColors.Onboarding.bottomColor)
        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
        }
    }
}



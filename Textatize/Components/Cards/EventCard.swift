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
    
    @Binding var event: Event
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
                    Text(event.getName)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    VStack {
                        if let date = event.getDate {
                            Text(date)
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        HStack(spacing: 5) {
                            Text("\(event.getNumPhotos)")
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
                
                if event.status == "active" {
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
                
                if event.status == "completed" {
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
        .onReceive(NotificationCenter.default.publisher(for: .updateEvent)) { notification in
            guard let userInfo = notification.userInfo,
                  let object = userInfo["object"] as? Event else {
                return
            }
            
            if object.unique_id! == event.unique_id! {
                guard let cachedEvent = CacheManager.shared.objectForKey(aKey: event.unique_id!) as? Event else { return }
                print("cachedEvent Orientation: \(cachedEvent.getOrientation)")
                self.event = cachedEvent
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
        }
    }
}



//
//  EventCard.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct EventCard: View {
    
    var new: Bool = false

    @Binding var eventSelected: Bool
    
    var image: Image? = nil
    var title: String = "Holidays"
    var date: String = "10/11/22"
    
    var numberOfPhotos: String = "20"
        
    var body: some View {
        
        if new {
            Button {
                print("New Event Pressed")
                
                withAnimation {
                    eventSelected = true
                }
            } label: {
                VStack(spacing: 5) {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 40)
                        AppImages.EventCard.plus
                    }
                    Text("New Event")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(AppColors.Onboarding.bottomColor)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
                }
                
            }
        } else {
            Button {
                print("Event Card Pressed")
                withAnimation {
                    eventSelected = true
                }
            } label: {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 7) {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.10, height: UIScreen.main.bounds.width * 0.10)
                        
                        VStack(alignment: .center, spacing: 7) {
                            Text(title)
                                .fontWeight(.semibold)
                            
                            VStack(alignment: .center) {
                                Text(date)
                                
                                HStack(spacing: 5) {
                                    Text(numberOfPhotos)
                                        .foregroundColor(AppColors.Onboarding.loginButton)
                                    
                                    Text("photos")
                                    
                                }
                                .frame(maxWidth: .infinity)
                                
                            }
                            .frame(maxWidth: .infinity)
                            .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack(spacing: 5) {
                        Button("Complete") {
                            print("Complete Pressed")
                        }
                        
                        Button("Restart") {
                            print("Restart Pressed")
                        }
                        
                        Button("Delete") {
                            print("Delete Pressed")
                        }
                        
                    }
                    .font(.caption2)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(AppColors.Onboarding.bottomColor)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
                }
            }
        }
    }
}

struct NewEventCard: View {
    
    //@Binding var newEventPressed: Bool
    
    var body: some View {
        
        Button {
            print("New Event Pressed")
            
            //            withAnimation {
            //                newEventPressed = true
            //            }
        } label: {
            VStack(spacing: 5) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 40)
                    AppImages.EventCard.plus
                }
                Text("New Event")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppColors.Onboarding.bottomColor)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
            }
            
        }
    }
}

struct EventCard_Previews: PreviewProvider {
    static var previews: some View {
        EventCard(new: false, eventSelected: .constant(true))
    }
}

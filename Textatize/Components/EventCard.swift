//
//  EventCard.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct EventCard: View {
    
    var image: Image? = nil
    var title: String = "Holidays"
    var date: String = "10/11/22"
    
    var numberOfPhotos: String = "20"
    var body: some View {
        
        Button {
            print("Event Card Pressed")
        } label: {
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 7) {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 40, height: 50)
                    
                    VStack(alignment: .leading, spacing: 7) {
                        Text(title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading) {
                            Text(date)
                            
                            HStack(spacing: 5) {
                                Text(numberOfPhotos)
                                    .foregroundColor(AppColors.Onboarding.loginButton)
                                
                                Text("photos")
                                
                            }
                        }
                        .font(.caption)
                    }
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    
                }
                
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
                .font(.system(size: 10))
                .foregroundColor(AppColors.Onboarding.bottomColor)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
            }
        }
    }
}

struct NewEventCard: View {
    
    @Binding var newEventPressed: Bool
    
    var body: some View {
        
        Button {
            print("New Event Pressed")
            newEventPressed = true
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
        EventCard()
    }
}

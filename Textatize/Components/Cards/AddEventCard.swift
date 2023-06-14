//
//  AddEventCard.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/14/23.
//

import SwiftUI

struct AddEventCard: View {
    var body: some View {
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

struct AddEventCard_Previews: PreviewProvider {
    static var previews: some View {
        AddEventCard()
    }
}

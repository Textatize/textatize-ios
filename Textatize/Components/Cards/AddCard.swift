//
//  AddCard.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI

struct AddCard: View {
    var title: String = ""
    @Binding var addFrame: Bool
    var body: some View {
        Button {
            print("Add Frame Pressed")
            addFrame.toggle()
        } label: {
            VStack(spacing: 5) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 40)
                    AppImages.EventCard.plus
                }
                Text(title)
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

struct AddCard_Previews: PreviewProvider {
    static var previews: some View {
        AddCard(addFrame: .constant(true))
    }
}

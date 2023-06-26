//
//  FrameEditButton.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/25/23.
//

import SwiftUI

struct FrameEditButton: View {
    
    var title: String
    var image: Image
    var action: () -> Void
    
    var body: some View {
        
        Button {
            action()
        } label: {
            VStack {
                image
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.075)
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(AppColors.Onboarding.loginButton)
            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.2)
        }
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(AppColors.Onboarding.loginButton, lineWidth: 3)
        )
        
    }
}

//#Preview {
//    FrameEditButton()
//}

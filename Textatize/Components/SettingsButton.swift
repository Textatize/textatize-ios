//
//  SettingsButton.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/26/23.
//

import SwiftUI

struct SettingsButton: View {
    var name: String = ""
    var body: some View {
        HStack {
            Text(name)
                .padding()
            Spacer()
            AppImages.EventCard.arrowSmall
                .padding()
            
        }
        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(AppColors.Onboarding.loginButton, lineWidth: 2)
        )
        .padding()
    }
}

//#Preview {
//    SettingsButton()
//}

//
//  CustomButton.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/16/23.
//

import SwiftUI

struct CustomButtonView: View {
    
    var filled: Bool
    var name: String
    
    var body: some View {
        if filled {
            Text(name)
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(AppColors.Onboarding.loginButton)
            )
        } else {
            Text(name)
                .font(.headline)
                .foregroundColor(AppColors.Onboarding.loginButton)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(AppColors.Onboarding.loginButton, lineWidth: 2)
                )
        }
    }
}

//struct CustomButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomButton(action: )
//    }
//}

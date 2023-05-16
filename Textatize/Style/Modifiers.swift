//
//  Modifiers.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/16/23.
//

import Foundation
import SwiftUI

// MARK: - Onboarding Title
struct OnboardingTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
            .font(.title.bold())
            .multilineTextAlignment(.center)
    }
}

// MARK: - Onboarding Textfield Border
struct OnboardingTextfieldBorder: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(AppColors.Onboarding.topColor)
            }
    }
}

// MARK: - Custom Background
struct CustomBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .mask {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
            }
    }
}


// MARK: - View Extension
extension View {
    
    func onboardingTitle() -> some View {
        self.modifier(OnboardingTitle())
    }
    
    func onboardingBorder() -> some View {
        self.modifier(OnboardingTextfieldBorder())
    }
    
    func customBackground() -> some View {
        self.modifier(CustomBackground())
    }
}

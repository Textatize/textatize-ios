//
//  CustomBackButtom.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/25/23.
//

import SwiftUI

struct CustomBackButtom: View {
    var dismissAction: DismissAction
    var body: some View {
        Button {
            dismissAction
        } label: {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back")
            }
            .accentColor(AppColors.Onboarding.loginScreenForegroundColor)
        }
    }
}
struct CustomOnboardingBackButtom: View {
    @Binding var path: [OnboardingNav]
    var body: some View {
        Button {
            path.removeLast()
        } label: {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back")
            }
            .accentColor(AppColors.Onboarding.loginScreenForegroundColor)
        }
    }
}

struct BackButton: View {
    @Binding var path: [Int]
    var body: some View {
        Button {
            path.removeLast()
        } label: {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back")
            }
            .accentColor(AppColors.Onboarding.loginScreenForegroundColor)
        }
    }
}

struct CameraBackButton: View {
    @Binding var path: [Int]
    var body: some View {
        Button {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            path.removeLast()
        } label: {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back")
            }
            .accentColor(AppColors.Onboarding.loginScreenForegroundColor)
        }
    }
}

//struct CustomBackButtom_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomBackButtom(action: )
//    }
//}

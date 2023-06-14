//
//  CustomBackButtom.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/25/23.
//

import SwiftUI

struct CustomBackButtom: View {
    var action: DismissAction
    var body: some View {
        Button {
            action()
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

//struct CustomBackButtom_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomBackButtom(action: )
//    }
//}

//
//  FrameCard.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI
import Kingfisher

struct FrameCard: View {
    var frameImage: Image
    var body: some View {
        ZStack {
            frameImage
                .resizable()

        }
    }
}

struct FrameSelectionCard: View {
    
    @Binding var frameSelected: Frame?
    var frame: Frame
    var body: some View {
        
        Button {
            print("Frame Selected")
            withAnimation {
                frameSelected = frame
            }
        } label: {
            if let frameURL = URL(string: frame.unwrappedURL) {
                KFImage.url(frameURL)
                    .resizable()
            }
        }
    }
}

struct FrameEditingCard: View {
    @StateObject private var vm = FrameViewModel.shared

    @Binding var selectedFrame: Frame?
    var frame: Frame
    @Binding var editType: FrameEditAction
    @Binding var editFrame: Bool
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 15) {
            
            if let frameURL = URL(string: frame.unwrappedURL) {
                KFImage.url(frameURL)
                    .resizable()

            }
            
            if let name = frame.name {
                Text(name)
            }
            
            VStack(alignment: .leading) {
                Button {
                    print("Duplicate Frame Selected")
                    withAnimation {
                        editType = .duplicate
                        selectedFrame = frame
                        editFrame = true
                    }
                } label: {
                    HStack {
                        AppImages.duplicateIcon
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Duplicate")
                    }
                    .foregroundColor(AppColors.Onboarding.loginButton)
                }
                
            }
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

//struct FrameCard_Previews: PreviewProvider {
//    static var previews: some View {
//        FrameCard(duplicateSelected: .constant(false), selectedFrame: )
//    }
//}

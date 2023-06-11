//
//  FrameCard.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI
import Kingfisher

struct FrameCard: View {
    var frame: Frame
    var body: some View {
        KFImage.url(URL(string: frame.unwrappedURL))
            .resizable()
            .placeholder({
                ProgressView()
            })
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .onProgress { receivedSize, totalSize in  }
            .onSuccess { result in  }
            .onFailure { error in }
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
            KFImage.url(URL(string: frame.unwrappedURL))
                .resizable()
                .placeholder({
                    ProgressView()
                })
                .loadDiskFileSynchronously()
                .cacheMemoryOnly()
                .fade(duration: 0.25)
                .onProgress { receivedSize, totalSize in  }
                .onSuccess { result in  }
                .onFailure { error in }
        }
    }
}

struct FrameEditingCard: View {
    
    @Binding var duplicateSelected: Bool
    var frameImage: Image?
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 15) {
            
            if let frameImage = frameImage {
                frameImage
                    .resizable()
            }
            
//            Button {
//                print("Frame Selected")
////                withAnimation {
////                    isSelected = true
////                }
//            } label: {
//                KFImage.url(URL(string: frame.unwrappedURL))
//                    .resizable()
//                    .placeholder({
//                        ProgressView()
//                    })
//                    .loadDiskFileSynchronously()
//                    .cacheMemoryOnly()
//                    .fade(duration: 0.25)
//                    .onProgress { receivedSize, totalSize in  }
//                    .onSuccess { result in  }
//                    .onFailure { error in }
//            }
            
            VStack(alignment: .leading) {
                Button {
                    print("Duplicate Frame Selected")
                    withAnimation {
                        duplicateSelected = true
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
//        .overlay {
//            AppImages.checkSmall
//                .resizable()
//                .frame(width: 20, height: 20)
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
//                .padding()
//                .opacity(isSelected ? 1 : 0)
//        }
    }
}

//struct FrameCard_Previews: PreviewProvider {
//    static var previews: some View {
//        FrameCard(duplicateSelected: .constant(false), selectedFrame: )
//    }
//}

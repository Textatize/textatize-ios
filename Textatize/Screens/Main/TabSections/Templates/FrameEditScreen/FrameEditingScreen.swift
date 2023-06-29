//
//  FrameEditingScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI
import Kingfisher

enum FrameEditAction: String {
    case upload, edit, duplicate
}

struct FrameEditingScreen: View {
    
    @Environment(\.dismiss) var dismiss
    var frame: Frame?
    @State var frameImage: UIImage?
    @State private var finalImage: UIImage? = nil
    @State private var showImagePicker = false
    
    @State private var frameOrientation: Orientation? = nil
    
    var editType: FrameEditAction
    
    var body: some View {
        ZStack {
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea(edges: .top)
            
            VStack {
                Text("Frame Editing")
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            
                        
            if let frameImage = frameImage {
                HostedFrameEditViewController(frameImage: frameImage)
                    .padding()
                    .padding(.top, 40)
                    .ignoresSafeArea(edges: .top)
            } else {
                ProgressView {
                    Text("Loading Image")
                }
            }
            
            if frame == nil {
                Button {
                    showImagePicker = true
                } label: {
                    CustomButtonView(filled: true, name: "Add Photo")
                }
                .opacity(frameImage == nil ? 1 : 0)
                .padding()
            }
        }
        .onAppear {
            
            loadImage()
            
            switch editType {
            case .upload:
                break
            case .edit:
                if let frameImage = frameImage {
                    if frameImage.size.width > frameImage.size.height {
                        frameOrientation = .landscape
                    }
                    if frameImage.size.width < frameImage.size.height {
                        frameOrientation = .portrait
                    }
                    if frameImage.size.width == frameImage.size.height {
                        frameOrientation = .square
                    }
                }
            case .duplicate:
                if let frameImage = frameImage {
                    if frameImage.size.width > frameImage.size.height {
                        frameOrientation = .landscape
                    }
                    if frameImage.size.width < frameImage.size.height {
                        frameOrientation = .portrait
                    }
                    if frameImage.size.width == frameImage.size.height {
                        frameOrientation = .square
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .editedFrame)) { notification in
            guard let userInfo = notification.userInfo,
                  let object = userInfo["object"] as? UIImage else {
                return
            }
            
            if object.size.width > object.size.height {
                frameOrientation = .landscape
            }
            if object.size.width < object.size.height {
                frameOrientation = .portrait
            }
            if object.size.width == object.size.height {
                frameOrientation = .square
            }
            
            self.finalImage = object
        }
        .onChange(of: finalImage) { value in
            if finalImage != nil {
                switch editType {
                case .upload:
                    addFrame()
                case .edit:
                    editFrame()
                case .duplicate:
                    addFrame()
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $frameImage)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    .accentColor(AppColors.Onboarding.loginScreenForegroundColor)
                }            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func addFrame() {
        if let frameOrientation = frameOrientation, let finalImage = finalImage {
            TextatizeAPI.shared.createFrame(newFrame: finalImage, orientation: frameOrientation.rawValue) { _, _ in
                NotificationCenter.default.post(name: .refreshFrame, object: nil)
                dismiss()
            }
        }
    }
    
    private func editFrame() {
        if let frame = frame, let frameID = frame.unique_id, let finalImage = finalImage {
            TextatizeAPI.shared.updateFrame(frameID: frameID, newFrame: finalImage) { _, _ in
                NotificationCenter.default.post(name: .refreshFrame, object: nil)
                dismiss()
            }
        }
    }
    
    private func loadImage() {
        if let frame = frame, let frameURL = URL(string: frame.unwrappedURL) {
            DispatchQueue.global(qos: .background).async {
                if let data = try? Data(contentsOf: frameURL) {
                    DispatchQueue.main.async {
                        withAnimation {
                            self.frameImage = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
}

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

//struct FrameEditingScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        FrameEditingScreen()
//    }
//}

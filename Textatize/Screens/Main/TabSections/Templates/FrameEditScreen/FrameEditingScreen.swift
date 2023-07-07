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
    @State private var frameName = ""
    
    @State private var frameOrientation: Orientation? = nil
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var editType: FrameEditAction
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AppColors.Onboarding.redLinearGradientBackground
                    .ignoresSafeArea()
                            
                if let frameImage = frameImage {
                    HostedFrameEditViewController(frameImage: frameImage)
                        .padding()
                        .padding(.top, 40)
                        .frame(width: UIScreen.main.bounds.size.width-50, height: UIScreen.main.bounds.size.height - 100)
                        //.ignoresSafeArea(edges: .top)
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
                
                VStack {
                    Text("Frame Editing")
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    TextField("Enter Frame Name", text: $frameName)
                        .frame(height: 50)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .padding()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea(.keyboard, edges: .all)
                
            }
            .alert(alertTitle, isPresented: $showAlert, actions: {
                Button(role: .cancel) {
                } label: {
                    Text("Dismiss")
                }
            }, message: {
                Text(alertMessage)
            })
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
                
                if frameName.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                    alertTitle = "Frame Error"
                    alertMessage = "Please provide a frame name"
                    showAlert = true
                } else {
                    self.finalImage = object
                    print("@@@EDIT self.finalImage hasAlpha=\(self.finalImage!.hasAlpha2)")
                }
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
        .toolbar(.hidden, for: .tabBar)
        }
    }
    
    private func addFrame() {
        if let frameOrientation = frameOrientation, let finalImage = finalImage {
            let name = frameName.trimmingCharacters(in: .whitespacesAndNewlines)
            TextatizeAPI.shared.createFrame(name: name, newFrame: finalImage, orientation: frameOrientation.rawValue) { _, _ in
                NotificationCenter.default.post(name: .refreshFrame, object: nil)
                dismiss()
            }
        }
    }
    
    private func editFrame() {
        if let frame = frame, let frameID = frame.unique_id, let finalImage = finalImage {
            let name = frameName.trimmingCharacters(in: .whitespacesAndNewlines)
            TextatizeAPI.shared.updateFrame(frameID: frameID, name: name, newFrame: finalImage) { _, _ in
                NotificationCenter.default.post(name: .refreshFrame, object: nil)
                dismiss()
            }
        }
    }
    
    private func loadImage() {
        if let frame = frame, let frameURL = URL(string: frame.unwrappedURL) {
            if let name = frame.name {
                frameName = name
            }
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
extension UIImage {
    var hasAlpha2: Bool {
        guard let alphaInfo = self.cgImage?.alphaInfo else {return false}
        return alphaInfo != CGImageAlphaInfo.none &&
            alphaInfo != CGImageAlphaInfo.noneSkipFirst &&
            alphaInfo != CGImageAlphaInfo.noneSkipLast
    }
}

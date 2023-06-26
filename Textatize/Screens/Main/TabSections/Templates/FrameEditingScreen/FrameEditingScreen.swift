//
//  FrameEditingScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI

struct FrameEditingScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = FrameEditingViewModel.shared
    
    @State var frameImage: UIImage
    var frameOrientation: Orientation
    
    @State private var addText = false
    @State private var editText = false
    @State private var textWidthPercentage: CGFloat = .zero
    @State private var textHeightPercentage: CGFloat = .zero
    
    @State private var text: String = "Hello World"
    @State private var textColor: Color = .black
    
    @State private var saveFrameEdit = false
                
    var body: some View {
        ZStack {
            
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea(edges: .top)

            ZStack {
                VStack {
                    
                    Spacer()
                    
                    Text("Frame Editing")
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    
                    switch frameOrientation {
                    case .portrait:
                        FrameView(
                            addText: $addText,
                            frameImage: frameImage,
                            text: text,
                            fontSize: 20,
                            textColor: textColor,
                            textWidthPercentage: $textWidthPercentage,
                            textHeightPercentage: $textHeightPercentage
                        )
                        .frame(width: 200, height: 300)
                    case .landscape:
                        FrameView(
                            addText: $addText,
                            frameImage: frameImage,
                            text: text,
                            fontSize: 30,
                            textColor: textColor,
                            textWidthPercentage: $textWidthPercentage,
                            textHeightPercentage: $textHeightPercentage
                        )
                        .frame(width: 300, height: 200)
                    case .square:
                        FrameView(
                            addText: $addText,
                            frameImage: frameImage,
                            text: text,
                            fontSize: 20,
                            textColor: textColor,
                            textWidthPercentage: $textWidthPercentage,
                            textHeightPercentage: $textHeightPercentage
                        )
                        .frame(width: 200, height: 200)
                    }
                    
                    Spacer()
                    
                    HStack {
                        FrameEditButton(
                            title: "Background",
                            image: AppImages.imageIcon,
                            action: addBackgroundPressed
                        )
                        FrameEditButton(
                            title: "Image",
                            image: AppImages.imageIcon,
                            action: addImagePressed
                        )
                        FrameEditButton(
                            title: addText ? "Remove Text" : "Add Text",
                            image: AppImages.textIcon,
                            action: addTextPressed
                        )
                    }
                    
                    Button {
                        if addText {
                            self.frameImage = viewModel.textToImage(
                                drawText: text,
                                inImage: frameImage,
                                widthPercentage: textWidthPercentage,
                                heightPercentage: textHeightPercentage,
                                fontSizePercentage: 0.1,
                                fontColor: UIColor(textColor)
                            )
                        }
                    } label: {
                        CustomButtonView(filled: false, name: "Place")
                            .padding(.horizontal)
                            .opacity(addText ? 1 : 0)
                            .scaleEffect(addText ? 1 : 0.5)
                    }
                    
                    Button {
                        saveFrameEdit = true
                    } label: {
                        CustomButtonView(filled: true, name: "Save")
                            .padding()
                    }
                    
                }
                
                ZStack {
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Enter Text")
                                .font(.caption)
                            
                            TextField("Enter your Text", text: $text)
                                .padding()
                                .frame(height: 50)
                                .onboardingBorder()
                        }
                        .padding()
                        .offset(y: editText ? 0 : -100)
                        
                        VStack(alignment: .leading) {
                            Text("Text Color")
                                .font(.caption)
                            
                            ColorPicker("Choose Color", selection: $textColor)
                        }
                        .padding()
                        .offset(y: editText ? 0 : 100)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.thickMaterial)
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .opacity(editText ? 1 : 0)
                
                Button {
                    withAnimation {
                        editText.toggle()
                    }
                } label: {
                    Text(editText ? "Save Text" : "Edit Text")
                        .foregroundColor(AppColors.Onboarding.loginButton)
                        .padding()
                }
                .opacity(addText ? 1 : 0)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
            .customBackground()

        }
        .alert("Save", isPresented: $saveFrameEdit, actions: {
            Button(role: .cancel) {
                dismiss()
            } label: {
                Text("Dismiss")
            }
        }, message: {
            Text("Image Saved!")
        })
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
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func addBackgroundPressed() {
        print("Add Background Pressed")
    }
    
    private func addImagePressed() {
        print("Add Image Presssed")
    }
    
    private func addTextPressed() {
        withAnimation {
            addText.toggle()
        }
    }
}


struct FrameView: View {
    
    @Binding var addText: Bool
    
    var frameImage: UIImage
    var text: String
    var fontSize: Double
    var textColor: Color
    
    @Binding var textWidthPercentage: CGFloat
    @Binding var textHeightPercentage: CGFloat
    
    @State private var imageFrame = CGRect()
    @State private var evPointLocation: CGPoint = CGPoint(x: 0, y: 0)
    
    var body: some View {
        
        ZStack {
            Image(uiImage: frameImage)
                .resizable()
                .background {
                    GeometryReader { geo in
                        Color.clear.onAppear {
                
                            let stringWidth = text.widthOfString(usingFont: UIFont.systemFont(ofSize: fontSize))
                            let stringHeight = text.heightOfString(usingFont: UIFont.systemFont(ofSize: fontSize))
                            
                            imageFrame = geo.frame(in: .named("frameCoord"))
                            let topLeading = CGPoint(x: imageFrame.origin.x + stringWidth / 2, y: imageFrame.origin.y + stringHeight / 2)

                            evPointLocation = topLeading
                        }
                    }
                }
            
            Text(text)
                .font(.system(size: fontSize))
                .foregroundColor(textColor)
                .opacity(addText ? 1 : 0)
                .position(evPointLocation)
                .gesture(DragGesture()
                    .onChanged { value in
                        
                        let stringWidth = text.widthOfString(usingFont: UIFont.systemFont(ofSize: fontSize))
                        let stringHeight = text.heightOfString(usingFont: UIFont.systemFont(ofSize: fontSize))


                        let rect = CGRect(origin: imageFrame.origin, size: CGSize(width: imageFrame.width - stringWidth, height: imageFrame.height - stringHeight))
                        if rect.contains(value.location) {
                            self.evPointLocation.y = value.location.y + stringHeight / 2
                            self.evPointLocation.x = value.location.x + stringWidth / 2
                            
                            self.textWidthPercentage = value.location.x / rect.width
                            self.textHeightPercentage = value.location.y / rect.height
                            
                            //print("Away Vertical percentage: \(value.location.y / rect.height)")
                            //print("Away Horizontal percentage: \(value.location.x / rect.width)")

                        }
                    })
        }
        .coordinateSpace(name: "frameCoord")
    }
}

struct FrameEditingScreen_Previews: PreviewProvider {
    static var previews: some View {
        FrameEditingScreen(frameImage: UIImage(systemName: "photo")!, frameOrientation: .landscape)
    }
}

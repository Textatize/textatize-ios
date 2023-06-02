//
//  ImageDetailView.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/30/23.
//

import SwiftUI

struct ImageDetailView: View {
    @Binding var showView: Bool
    var image: Image?
    var body: some View {
        VStack {
            ZStack {
                Button {
                    withAnimation {
                        showView = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .accentColor(.black)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(20)
                
                VStack {
                    
                    if let image = image {
                        image
                            .resizable()
                            .frame(width: 200, height: 200)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.black)
                    }
                    
                    VStack(spacing: 10) {
                        
                        if let image = image {
                            
                            VStack {
                                Text("Submit A Photo")
                                Text("Would you like to share a photo?")
                            }
                            .font(.headline)
                            
                            ShareLink(item: image, preview: SharePreview("Image", image: image)) {
                                CustomButtonView(filled: true, name: "Share photo")
                                    .padding()
                            }
                        } else {
                            
                            VStack {
                                Text("Mon, 2 Feb, 19:11")
                                Text("JPEG _ 001")
                            }
                            .font(.headline)
                            Text("318 MB, 1500x1700")
                                .font(.subheadline)
                            
                            
                            CustomButtonView(filled: true, name: "Share photo")
                                .padding()
                        }
                        

                        
                    }
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    
                }
                
            }
            


        }
        .customBackground()
        .padding(.vertical, 25)
        .padding(.horizontal)
        .frame(height: UIScreen.main.bounds.height * 0.8)
    }
}
struct SharePhotoView: View {
    
    @State private var number = ""
    @Binding var showView: Bool
    var image: Image
    
    var body: some View {
        
        ZStack {
            XMarkButton(showView: $showView)
            VStack {
                Text("Your Photo")
                    .font(.largeTitle.bold())
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                
                image
                    .resizable()
                    .frame(width: 200, height: 200)
                
                Text("Submit a photo")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .padding()
                
                Text("To share a photo via SMS, \nwrite a phone number")
                    .font(.headline)
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .multilineTextAlignment(.center)
                
                TextField("+1234", text: $number)
                    .padding()
                    .frame(width: 250, height: 50)
                    .onboardingBorder()
                    .padding()
                    .keyboardType(.numberPad)
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                
                CustomButtonView(filled: true, name: "Share Photo")
                    .onTapGesture {
                        print("Share Photo Pressed")
                    }
                    .padding()
            }
        }
        .customBackground()
 
    }
}

struct XMarkButton: View {
    @Binding var showView: Bool
    var body: some View {
        
        Button {
            withAnimation {
                showView = false
            }
        } label: {
            Image(systemName: "xmark")
                .accentColor(.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(20)
        
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SharePhotoView(showView: .constant(true), image: Image(systemName: "photo"))
    }
}

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

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(showView: .constant(true))
    }
}

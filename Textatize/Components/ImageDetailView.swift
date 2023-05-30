//
//  ImageDetailView.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/30/23.
//

import SwiftUI

struct ImageDetailView: View {
    @Binding var showView: Bool
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
                    
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.black)
                    
                    VStack(spacing: 10) {
                        
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

//
//  EventDetailScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct EventDetailScreen: View {
    @Environment(\.dismiss) var dismiss
    
    let layout = [
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem()
    ]
    
    var name: String
    var date: String
    var location: String
    var orientation: String
    var camera: String
    var hostName: String
    
    @State private var showTemplate = false
    @State private var showWatermark = false
    @State private var showGallaryImage = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AppColors.Onboarding.redLinearGradientBackground
                    .ignoresSafeArea()
                
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    .accentColor(AppColors.Onboarding.loginScreenForegroundColor)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading)
                
                VStack {
                    
                    Button {
                        print("Capture Pressed")
                    } label: {
                        HStack {
                            AppImages.EventCard.camera
                                .resizable()
                                .frame(width: 20, height: 20)
                
                            Text("Capture")
                                .font(.headline)
                                .accentColor(.white)
                        }
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.black)
                        }
                        .padding()
                        
                    }
                    .padding(.top, 20)
                    
                    VStack {
                        Text("Event Detail")
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding()
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                
                                Text("Description")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack(spacing: 0) {
                                    
                                    VStack(spacing: 15) {
                                        Group {
                                            HStack {
                                                Text("Name: ")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                Text(name)
                                                    .font(.caption)
                                            }
                                            
                                            HStack {
                                                Text("Date: ")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                Text(date)
                                                    .font(.caption)
                                            }
                                            
                                            HStack {
                                                Text("Location: ")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                Text(location)
                                                    .font(.caption)
                                            }
                                           
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    
                                    VStack(spacing: 15) {
                                        
                                        Group {
                                            HStack {
                                                Text("Orientation: ")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                Text(orientation)
                                                    .font(.caption)
                                            }
                                            
                                            HStack {
                                                Text("Camera: ")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                Text(camera)
                                                    .font(.caption)
                                            }
                                            
                                            HStack {
                                                Text("Host Name: ")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                Text(hostName)
                                                    .font(.caption)
                                            }
                                           
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    }
                                }
                                .frame(maxWidth: .infinity)
                                
                                Group {
                                    Rectangle()
                                        .fill(.gray)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 2)
                                    
                                    Button {
                                        print("Show Template Pressed")
                                        showTemplate.toggle()
                                    } label: {
                                        HStack {
                                            Text("Template")
                                                .font(.headline)
                                            Spacer()
                                            if showTemplate {
                                                Image(systemName: "chevron.up")
                                                    .resizable()
                                                    .frame(width: 20, height: 10)

                                            } else {
                                                Image(systemName: "chevron.down")
                                                    .resizable()
                                                    .frame(width: 20, height: 10)
                                            }

                                        }
                                    }
                                    
                                    if showTemplate {
                                        HStack {
                                            ForEach(0..<3) { _ in
                                                Image(systemName: "person")
                                            }
                                        }
                                    }
                                    
                                    Rectangle()
                                        .fill(.gray)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 2)
                                    
                                    Button {
                                        print("Show Watermark Pressed")
                                        showWatermark.toggle()
                                    } label: {
                                        HStack {
                                            Text("Watermark")
                                                .font(.headline)
                                            Spacer()
                                            if showTemplate {
                                                Image(systemName: "chevron.up")
                                                    .resizable()
                                                    .frame(width: 20, height: 10)

                                            } else {
                                                Image(systemName: "chevron.down")
                                                    .resizable()
                                                    .frame(width: 20, height: 10)
                                            }

                                        }
                                    }
                                    
                                    if showWatermark {
                                        HStack {
                                            ForEach(0..<3) { _ in
                                                Image(systemName: "person.circle")
                                            }
                                        }
                                    }
                                    
                                    Rectangle()
                                        .fill(.gray)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 2)
                                }
                                
                               
                                
                                CustomButtonView(filled: true, name: "Edit")
                                
                                Text("Gallary")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                    LazyVGrid(columns: layout) {
                                        ForEach(0..<20) { item in
                                            
                                            Button {
                                                print("GallaryItem: \(item + 1) pressed")
                                                withAnimation {
                                                    showGallaryImage = true
                                                }
                                            } label: {
                                                VStack {
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .frame(width: 40, height: 40)
                                                        .foregroundColor(.black)
                                                    Text("JPEG")
                                                }
                                            }
                                    
                                        }
                                    }
                                

                                
                            }
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .padding()
                        }
                        
                        

                    }
                    .customBackground()
                    .padding(.horizontal)
                }
                
                if showGallaryImage {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                        
                        VStack {
                            ZStack {
                                Button {
                                    withAnimation {
                                        showGallaryImage = false
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
                        .frame(height: geo.size.height * 0.7)
                        .padding(.horizontal)
                        
                        
                    }
                
                }
                
            }
        }
    }
}

struct EventDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailScreen(name: "Holidays", date: "10/11/12", location: "Rome", orientation: "Portrait", camera: "Front", hostName: "Anna")
    }
}

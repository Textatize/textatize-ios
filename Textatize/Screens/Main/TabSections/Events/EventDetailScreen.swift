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
    
    var event: Event?
    
    var name: String
    var date: String
    var location: String
    var orientation: String
    var camera: String
    var hostName: String
    
    @State private var showTemplate = false
    @State private var showWatermark = false
    @State private var showGallaryImage = false
    @State private var showSheet = false
    @State private var showCameraView = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AppColors.Onboarding.redLinearGradientBackground
                    .ignoresSafeArea(edges: .top)

                VStack {
                    
                    NavigationLink {
                        CameraView(event: event)
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

                    
//                    Button {
//                        print("Capture Pressed")
//                        showCameraView = true
//                    } label: {
//                        HStack {
//                            AppImages.EventCard.camera
//                                .resizable()
//                                .frame(width: 20, height: 20)
//
//                            Text("Capture")
//                                .font(.headline)
//                                .accentColor(.white)
//                        }
//                        .frame(height: 50)
//                        .frame(maxWidth: .infinity)
//                        .background {
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(.black)
//                        }
//                        .padding()
//
//                    }
//                    .padding(.top, 20)
                    
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
                                
                                Text("Gallery")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                    LazyVGrid(columns: layout) {
                                        ForEach(0..<20) { item in
                                            
                                            Button {
                                                print("GalleryItem: \(item + 1) pressed")
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
                    .padding()

                }
                
                if showGallaryImage {
                    ZStack {
                        Color.black.opacity(0.75)
                            .ignoresSafeArea()
                
                    ImageDetailView(showView: $showGallaryImage)
                    }
                
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomBackButtom(action: dismiss)
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar(.visible, for: .tabBar)
            .onAppear {
                TextatizeAPI.shared.retrieveMedia(page: nil, eventID: "E3qLPPPhCk") { error, response in
                    print("Response Fetched")
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

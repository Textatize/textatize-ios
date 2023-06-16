//
//  EventDetailScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct EventDetailScreen: View {
    @StateObject private var vm = EventDetailScreenViewModel.shared
    
    @Binding var path: [Int]
    @State private var showFrames = false
    
    let layout = [
        GridItem(),
        GridItem(),
    ]
    
    var event: Event? = nil

    @State var name: String = ""
    @State var date: String?
    @State var location: String = ""
    @State var orientation: String = ""
    @State var camera: String = ""
    @State var hostName: String = ""
    
    @State private var shareMedia = false
    
    var body: some View {        
        ZStack {
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea(edges: .top)
            
            VStack {
                
                
                NavigationLink(value: 5) {
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
                }
                .padding(.top, 20)
                .padding()
                
                VStack {
                    Text("Event Detail")
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding()
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            Text("Description")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                
                                VStack(spacing: 10) {
                                    VStack {
                                        Text("Event Name")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.subheadline.bold())
                                        Text(name)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.caption)
                                    }
                                    
                                    VStack {
                                        Text("Event Date")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.subheadline.bold())
                                        if let date = date {
                                            Text(date)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .font(.caption)
                                        }
                                    }
                                    
                                    VStack {
                                        Text("Event Location")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.subheadline.bold())
                                        Text(location)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.caption)
                                    }
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 10) {
                                    VStack {
                                        Text("Event Orientation")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.subheadline.bold())
                                        Text(orientation)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.caption)
                                    }
                                    
                                    VStack {
                                        Text("Event Camera")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.subheadline.bold())
                                        Text(camera)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.caption)
                                    }
                                    
                                    VStack {
                                        Text("Event Host")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.subheadline.bold())
                                        Text(name)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.caption)
                                    }
                                    
                                    
                                }
                            }
                            
                            Group {
                                Rectangle()
                                    .fill(.gray)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 2)
                                
                                Button {
                                    print("Show Frames Pressed")
                                    withAnimation {
                                        showFrames.toggle()
                                    }
                                } label: {
                                    HStack {
                                        Text("Frames")
                                            .font(.headline)
                                        Spacer()
                                        
                                        Image(systemName: showFrames ? "chevron.up" : "chevron.down")
                                            .resizable()
                                            .frame(width: 20, height: 10)
                                        
                                    }
                                }
                                
                                if showFrames {
                                    if let frameImage = vm.getFrameImage(frame: event?.frame) {
                                        frameImage
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                                Rectangle()
                                    .fill(.gray)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 2)
                            }
                            
                            NavigationLink(value: 1) {
                                CustomButtonView(filled: true, name: "Edit")
                                    .padding()
                            }
                            
                            Text("Gallery")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            LazyVGrid(columns: layout) {
                                ForEach(0..<vm.medias.count, id: \.self) { item in
                                    MediaView(media: vm.medias[item])
                                        .onTapGesture(perform: {
                                            vm.getImageData(media: vm.medias[item])
                                        })
                                        .frame(width: 100, height: 100)
                                        .padding()
                                    
                                }
                            }
                        }
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .padding()
                    }
                }
                .customBackground()
            }
            
            if vm.showGallaryImage {
                ZStack {
                    Color.black.opacity(0.80)
                        .ignoresSafeArea()
                    
                    ShareGalleryImage(eventID: event?.unique_id ?? "No ID", showView: $vm.showGallaryImage, imageData: vm.selectedMediaImageData, image: vm.selectedMediaImage, shareMedia: $shareMedia)
                        .padding()
                }
                
            }
            BackButton(path: $path)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading)
            
        }
        .navigationBarHidden(true)
        .toolbar(vm.showGallaryImage ? .hidden : .visible, for: .tabBar)
        .onAppear {
            if let event = event {
                vm.getMedia(event: event)
                vm.getFrames(orientation: event.getOrientation, page: nil)
                name = event.getName
                date = event.getDate
                location = event.getLocation
                orientation = event.getOrientation.rawValue
                camera = event.getCamera.rawValue
                hostName = event.getName
            }
        }
    }
}

struct EventDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailScreen(path: .constant([2]), name: "Holidays", date: "10/11/12", location: "Rome", orientation: "Portrait", camera: "Front", hostName: "Anna")
    }
}

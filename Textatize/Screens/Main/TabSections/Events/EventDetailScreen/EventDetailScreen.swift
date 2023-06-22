//
//  EventDetailScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI
import Kingfisher

struct EventDetailScreen: View {
    @StateObject private var vm = EventDetailScreenViewModel.shared
    
    @Binding var path: [Int]
    @State private var showFrames = false
    @State private var showWatermark = false
    
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
    
    @State private var number = ""
    
    @State var watermarkURL: URL? = nil
    
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
                                    withAnimation {
                                        if let event = event, event.getUseFrame {
                                            showFrames.toggle()
                                        }
                                        if let event = event, !event.getUseFrame {
                                            showWatermark.toggle()
                                            
                                        }
                                    }
                                } label: {
                                    if let event = event, event.getUseFrame {
                                        HStack {
                                            Text("Frames")
                                                .font(.headline)
                                            Spacer()
                                            
                                            Image(systemName: showFrames ? "chevron.up" : "chevron.down")
                                                .resizable()
                                                .frame(width: 20, height: 10)
                                            
                                        }
                                    }
                                    
                                    if let event = event, !event.getUseFrame {
                                        HStack {
                                            Text("Watermarks")
                                                .font(.headline)
                                            Spacer()
                                            
                                            Image(systemName: showWatermark ? "chevron.up" : "chevron.down")
                                                .resizable()
                                                .frame(width: 20, height: 10)
                                            
                                        }
                                    }
                                }
                                
                                if showFrames {
                                    
                                    if let eventFrame = vm.eventFrame {
                                        Image(uiImage: eventFrame)
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                                
                                if showWatermark {
                                    if let eventWatermark = vm.eventWatermark {
                                        Image(uiImage: eventWatermark)
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
                                ForEach(vm.eventMediaImages) { mediaImage in
                                    MediaView(mediaImage: mediaImage)
                                        .onTapGesture {
                                            vm.getImageData(mediaImage: mediaImage)
                                        }
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
            
            if vm.showGalleryImage {
                ZStack {
                    Color.black.opacity(0.80)
                        .ignoresSafeArea()
                    
                    ShareGalleryImage(number: $number, eventID: event?.unique_id ?? "No ID", showView: $vm.showGalleryImage, imageData: vm.selectedMediaImageData, image: vm.selectedMediaImage, shareMedia: $shareMedia)
                        .padding()
                }
                
            }
            Button {
                path.removeAll()
            } label: {
                HStack {
                    Image(systemName: "arrow.left")
                    Text("Back")
                }
                .accentColor(AppColors.Onboarding.loginScreenForegroundColor)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.leading)
            
        }
        .navigationBarHidden(true)
        .toolbar(vm.showGalleryImage ? .hidden : .visible, for: .tabBar)
        .onAppear {
            if let event = event {
                downloadAssets(event: event)
                name = event.getName
                date = event.getDate
                location = event.getLocation
                orientation = event.getOrientation.rawValue
                camera = event.getCamera.rawValue
                hostName = event.getName
            }
        }
        .onChange(of: shareMedia) { value in
            if shareMedia {
                shareMedia = false
                if let media = vm.selectedMedia {
                    vm.shareMedia(number: number, mediaID: media.unique_id!)
                }
            }
        }
        .alert(vm.alertTitle, isPresented: $vm.showAlert, actions: {
            Button(role: .cancel) {
                number = ""
                withAnimation {
                    vm.showGalleryImage = false
                }
            } label: {
                Text("Dismiss")
            }
        }, message: {
            Text(vm.alertMessage)
        })
        .onDisappear {
            vm.reset()
        }
    }
    
    private func downloadAssets(event: Event) {
        vm.getMedia(event: event)
        switch event.getUseFrame {
        case true:
            vm.downloadFrame(event: event)
        case false:
            vm.downloadWatermark(event: event)
        }
    }
    
}

struct EventDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailScreen(path: .constant([2]), name: "Holidays", date: "10/11/12", location: "Rome", orientation: "Portrait", camera: "Front", hostName: "Anna")
    }
}

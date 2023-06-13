//
//  EventDetailScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct EventDetailScreen: View {
    @StateObject private var vm = EventDetailScreenViewModel.shared
    
    let layout = [
        GridItem(),
        GridItem(),
    ]
    
    @Binding  var rootView: Bool
    @Binding  var eventDetailView: Bool
    @Binding  var editEventView: Bool
    @Binding  var frameView: Bool
    @Binding  var checkInfoView: Bool
    
    var event: Event?
    
    var name: String
    var date: String
    var location: String
    var orientation: String
    var camera: String
    var hostName: String
    
    @State private var showEditScreen = false
    
    @State private var showFrames = false
    @State private var showWatermark = false
    @State private var showSheet = false
    @State private var showCameraView = false
    
    var body: some View {
        ZStack {
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea(edges: .top)
            
            VStack {
                
                NavigationLink {
                    CameraView(event: event, frame: vm.frames.first)
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
                                        Text(date)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.caption)
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
                            
                            
                            NavigationLink(isActive: $eventDetailView) {
                                EditEventScreen(rootView: $rootView, editEventView: $editEventView, frameView: $frameView, checkInfoView: $checkInfoView, event: event)
                            } label: {
                                CustomButtonView(filled: true, name: "Edit")
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
                    
                    
                    SharePhotoView(eventID: event?.unique_id ?? "NO ID", showView: $vm.showGallaryImage, imageData: vm.selectedMediaImageData, image: vm.selectedMediaImage)
                        .padding()
                }
                
            }
        }
        //.toolbar(vm.showGallaryImage ? .hidden : .visible, for: .tabBar)
        .onAppear {
            eventDetailView = false
            if let event = event {
                vm.getMedia(event: event)
                vm.getFrames(orientation: event.getOrientation, page: nil)
            }
        }
    }
}

//struct EventDetailScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDetailScreen(name: "Holidays", date: "10/11/12", location: "Rome", orientation: "Portrait", camera: "Front", hostName: "Anna")
//    }
//}

//
//  EventDetailScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct EventDetailScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var vm = EventDetailScreenViewModel.shared
    
    let layout = [
        GridItem(),
        GridItem(),
    ]
    
    @Binding var path: [Int]
    var count: Int
    
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
        GeometryReader { geo in
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

                                

//                                HStack {
//                                    VStack {
//                                        Text("Event Name")
//                                            .font(.subheadline.bold())
//                                        Text(name)
//                                            .font(.caption)
//                                    }
//                                    
//                                    Spacer()
//                                    
//                                    VStack {
//                                        Text("Orientation")
//                                            .font(.subheadline.bold())
//                                        Text(orientation)
//                                            .font(.caption)
//                                    }
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                                    
//                                    Spacer()
//
//                                }
                                
                                
//                                HStack {
//                                    VStack {
//                                        Text("Event Date")
//                                            .font(.subheadline.bold())
//
//                                        Text(date)
//                                            .font(.caption)
//                                    }
//                                    Spacer()
//
//                                    VStack {
//                                        Text("Camera")
//                                            .font(.subheadline.bold())
//
//                                        Text(camera)
//                                            .font(.caption)
//                                    }
//                                    
//                                    Spacer()
//
//                                }
                                //.frame(maxWidth: .infinity, alignment: .leading)

                                
                                
                                
                                
//                                Group {
//                                    
//                                    VStack {
//                                        Text("Name ")
//                                            .font(.subheadline.bold())
//                                        Text(name)
//                                            .font(.caption)
//                                    }
//                                    
//                                }
                                
//                                VStack {
//                                    VStack {
//                                        Text("Name ")
//                                            .font(.subheadline.bold())
//                                        Text(name)
//                                            .font(.caption)
//                                    }
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    
//                                    Spacer()
//                                    
//                                    VStack {
//                                        Text("Datee ")
//                                            .font(.subheadline.bold())
//
//                                        Text(date)
//                                            .font(.caption)
//                                    }
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    Spacer()
//                                }
                                
//                                HStack {
//                                    VStack {
//                                        Text("Date ")
//                                            .font(.subheadline.bold())
//                                        Text(date)
//                                            .font(.caption)
//                                    }
//                                    
//                                    Spacer()
//                                    
//                                    VStack {
//                                        Text("Camera ")
//                                            .font(.subheadline.bold())
//
//                                        Text(camera)
//                                            .font(.caption)
//                                    }
//                                    Spacer()
//                                }
                                
                                
                                HStack(spacing: 0) {
                                    
//                                    HStack {
//                                        VStack {
//                                            Text("Name ")
//                                                .font(.subheadline.bold())
//                                            Text(name)
//                                                .font(.caption)
//                                        }
//                                        
//                                        Spacer()
//                                        
//                                        VStack {
//                                            Text("Orientation ")
//                                                .font(.subheadline.bold())
//
//                                            Text(orientation)
//                                                .font(.caption)
//                                        }
//                                        Spacer()
//                                    }
//                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
//                                    HStack {
//                                        VStack {
//                                            Text("Date ")
//                                                .font(.subheadline.bold())
//                                            Text(date)
//                                                .font(.caption)
//                                        }
//                                        
//                                        Spacer()
//                                        
//                                        VStack {
//                                            Text("Camera ")
//                                                .font(.subheadline.bold())
//                                            
//                                            Text(camera)
//                                                .font(.caption)
//                                        }
//                                        Spacer()
//                                    }
//                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
//                                    VStack(spacing: 15) {
//                                        Group {
//                                            VStack {
//                                                Text("Name ")
//                                                    .font(.subheadline.bold())
//                                                Text(name)
//                                                    .font(.caption)
//                                            }
//                                            
//                                            VStack {
//                                                Text("Date ")
//                                                    .font(.subheadline.bold())
//                                                Text(date)
//                                                    .font(.caption)
//                                            }
//                                            
//                                            VStack {
//                                                Text("Location ")
//                                                    .font(.subheadline.bold())
//                                                Text(location)
//                                                    .font(.caption)
//                                            }
//                                           
//                                        }
//                                    }
                                    //.frame(maxWidth: .infinity, alignment: .leading)
                                    
//                                    Spacer()
//                                    Spacer()
                                    
//                                    VStack(spacing: 15) {
//                                        
//                                        Group {
//                                            VStack {
//                                                Text("Orientation ")
//                                                    .font(.subheadline.bold())
//
//                                                Text(orientation)
//                                                    .font(.caption)
//                                            }
//                                            
//                                            VStack {
//                                                Text("Camera ")
//                                                    .font(.subheadline.bold())
//
//                                                Text(camera)
//                                                    .font(.caption)
//                                            }
//                                            
//                                            VStack {
//                                                Text("Host Name ")
//                                                    .font(.subheadline.bold())
//
//                                                Text(hostName)
//                                                    .font(.caption)
//                                            }
//                                           
//                                        }
//                                        
//                                    }
                                    
                                    //Spacer()
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
                                    
//                                    Rectangle()
//                                        .fill(.gray)
//                                        .frame(maxWidth: .infinity)
//                                        .frame(height: 2)
//                                    
//                                    Button {
//                                        print("Show Watermark Pressed")
//                                        showWatermark.toggle()
//                                    } label: {
//                                        HStack {
//                                            Text("Watermark")
//                                                .font(.headline)
//                                            Spacer()
//                                            if showFrames {
//                                                Image(systemName: "chevron.up")
//                                                    .resizable()
//                                                    .frame(width: 20, height: 10)
//
//                                            } else {
//                                                Image(systemName: "chevron.down")
//                                                    .resizable()
//                                                    .frame(width: 20, height: 10)
//                                            }
//
//                                        }
//                                    }
                                    
//                                    if showWatermark {
//                                        HStack {
//                                            ForEach(0..<3) { _ in
//                                                Image(systemName: "person.circle")
//                                            }
//                                        }
//                                    }
                                    
                                    Rectangle()
                                        .fill(.gray)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 2)
                                }
                                
                               
                                NavigationLink {
                                    EditEventScreen(path: $path, event: event)
                                } label: {
                                    CustomButtonView(filled: true, name: "Edit")
                                }
//                                CustomButtonView(filled: true, name: "Edit")
//                                    .onTapGesture {
//                                        showEditScreen = true
//                                    }

                                
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

                        
                        SharePhotoView(action: dismiss, eventID: event?.unique_id ?? "NO ID", showView: $vm.showGallaryImage, imageData: vm.selectedMediaImageData, image: vm.selectedMediaImage)
                            .padding()
                    }
                
                }
                
                Button {
                    path.removeAll()
                } label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 15)
                        .accentColor(AppColors.Onboarding.loginScreenForegroundColor)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
                .padding(.leading)
                
            }
//            .background {
//                NavigationLink(isActive: $showEditScreen) {
//                    EditEventScreen(path: $path, event: event)
//                } label: {
//                    EmptyView()
//                }
//
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        path.removeAll()
//                    } label: {
//                        HStack {
//                            Image(systemName: "arrow.left")
//                            Text("Back")
//                        }
//                        .accentColor(AppColors.Onboarding.loginScreenForegroundColor)
//                    }
//                }
//            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden()
            .toolbar(vm.showGallaryImage ? .hidden : .visible, for: .tabBar)
        }
        .onAppear {
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

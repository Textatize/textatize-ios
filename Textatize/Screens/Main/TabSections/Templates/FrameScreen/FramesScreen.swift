//
//  FramesScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct FramesScreen: View {
    
    @StateObject private var vm = FrameViewModel.shared
    
    let isiPad = UIDevice.current.userInterfaceIdiom == .pad
    
    @State private var addFrameSelected = false
    @State private var eventSelected = false
    @State private var selectEvent = false
    @State private var duplicateSelected = false
    @State private var selectedFrame: Frame? = nil
    @State private var editFrame = false
    
    let iPadLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let iPhoneLayout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.Onboarding.redLinearGradientBackground
                    .ignoresSafeArea(edges: selectEvent ? .all : .top)
                
                VStack {
                    
                    Text("Frames")
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    
                    VStack {
                                            
                        ScrollView {
                            LazyVGrid(columns: isiPad ? iPadLayout : iPhoneLayout) {
                                ForEach(0..<vm.frames.count + 1, id: \.self) { item in
                                    if item == 0 {
                                        AddCard(title: "Upload")
                                            .onTapGesture(perform: {
                                                withAnimation {
                                                    selectedFrame = nil
                                                    editFrame = true
                                                }
                                            })
                                           .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40, height: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40)
                                           .padding()

                                    } else {
                                        if vm.frames.count > 0 {
                                            let frame = vm.frames[item - 1]
                                            
                                            NavigationLink {
                                                FrameEditingScreen(frameImage: vm.getFrameImage(frame: frame), frameOrientation: frame.orientation!)
                                            } label: {
                                                FrameEditingCard(duplicateSelected: $duplicateSelected, frame: frame)
                                                    .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40, height: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40)
                                                    .padding()
                                            }
                                        
                                                
//                                            FrameEditingCard(duplicateSelected: $duplicateSelected, frame: frame)
//                                                .onTapGesture(perform: {
//                                                    withAnimation {
//                                                        selectedFrame = frame
//                                                        editFrame = true
//                                                    }
//                                                })
//                                                .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40, height: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40)
//                                                .padding()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .customBackground()
            }
//            .background {
//                NavigationLink(destination: FrameEditingScreen(frameImage: vm.getFrameImage(frame: selectedFrame), frameOrientation: <#T##Orientation#>), isActive: $editFrame) { EmptyView() }
//                
//            }
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            vm.refreshFrames()
        }
    }
}

struct FramesScreen_Previews: PreviewProvider {
    static var previews: some View {
        FramesScreen()
    }
}

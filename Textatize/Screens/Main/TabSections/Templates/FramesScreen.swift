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
                        
                        Text("Choose the Frame")
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .fontWeight(.semibold)
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        
                        
                        ScrollView {
                            LazyVGrid(columns: isiPad ? iPadLayout : iPhoneLayout) {
                                ForEach(0..<10) { item in
                                    if item == 0 {
                                        
                                        NavigationLink(
                                            destination: FrameEditingScreen(),
                                            isActive: $addFrameSelected,
                                            label: {
                                                 AddCard(title: "Upload", addFrame: $addFrameSelected)
                                                    .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40, height: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40)
                                                    .padding()
                                            })

                                    } else {
                                        
                                        if vm.frames.count > 0 {
                                            let frame = vm.frames[item - 1]
                                            
                                            NavigationLink(destination: FrameEditingScreen(frame: frame), isActive: $duplicateSelected) {
                                                FrameEditingCard(duplicateSelected: $duplicateSelected, frame: frame)
                                                    .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40, height: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40)
                                                    .padding()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
//                        CustomButtonView(filled: true, name: "Select Event")
//                            .onTapGesture {
//                                withAnimation {
//                                    selectEvent = true
//                                }
//                            }
//                            .padding()
                        
                    }
                    
                }
                .customBackground()
                .padding()
                
                ZStack {
                    
                    Color.black.opacity(0.75)
                        .ignoresSafeArea()
                    
                    VStack {
                        
                        
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .frame(height: 5)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(width: UIScreen.main.bounds.width * 0.2)
                            .padding(.top, 20)
                        
                        Text("Events")
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .font(.title)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                        
                        VStack {
                            ScrollView {
                                LazyVGrid(columns: isiPad ? iPadLayout : iPhoneLayout) {
                                    ForEach(0..<8) { _ in
                                        EventCard(new: false, eventSelected: $eventSelected)
                                            .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.45, height: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.30)
                                            .padding()
                                    }
                                }
                            }
                            
                            CustomButtonView(filled: true, name: "Choose")
                                .padding()
                            
                        }
                    }
                    .customBackground()
                    .frame(height: UIScreen.main.bounds.height * 0.6)
                    .overlay {
                        Button {
                            withAnimation {
                                selectEvent = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .accentColor(.black)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(20)
                    }
                    
                }
                .opacity(selectEvent ? 1 : 0)
                .toolbar(selectEvent ? .hidden : .visible, for: .tabBar)
            }
            
        }
    }
}

struct FramesScreen_Previews: PreviewProvider {
    static var previews: some View {
        FramesScreen()
    }
}

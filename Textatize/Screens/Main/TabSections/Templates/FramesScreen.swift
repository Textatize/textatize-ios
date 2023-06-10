//
//  FramesScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct FramesScreen: View {
    
    @StateObject private var vm = FrameViewModel.shared
    @State var frames = [Frame]()
    
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
                    
                        ScrollView {
                            LazyVGrid(columns: isiPad ? iPadLayout : iPhoneLayout) {
                                ForEach(0..<frames.count, id: \.self) { item in
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
                                        
                                        if frames.count > 0 {
                                            let frame = frames[item - 1]
                                            
                                            NavigationLink(destination: FrameEditingScreen(frameImage: vm.getFrameImage(frame: frame)), isActive: $duplicateSelected) {
                                                FrameEditingCard(duplicateSelected: $duplicateSelected, frameImage: vm.getFrameImage(frame: frame))
                                                    .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40, height: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40)
                                                    .padding()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .customBackground()
            }
        }
    }
}

struct FramesScreen_Previews: PreviewProvider {
    static var previews: some View {
        FramesScreen()
    }
}

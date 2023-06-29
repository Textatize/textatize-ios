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
    @State private var framesSelected: Bool = true
    
    @State private var editFrame = false
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var editType: FrameEditAction = .edit
    
    var segmentTitles = ["Frames", "Custom"]
    
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
                   
                    Group {
                        HStack {
                            
                            VStack {
                                HStack {
                                    
                                    Spacer()
                                    
                                    Button {
                                        
                                        withAnimation {
                                            framesSelected = true
                                        }
                                        
                                    } label :{
                                        Text("Frames")
                                            .font(.headline)
                                            .foregroundColor(AppColors.Onboarding.loginButton)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        
                                        withAnimation {
                                            framesSelected = false
                                        }
                                        
                                    } label :{
                                        Text("Custom")
                                            .font(.headline)
                                            .foregroundColor(AppColors.Onboarding.loginButton)
                                    }
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(AppColors.Onboarding.topColor)
                                        .frame(height: 10)
                                        .padding(.horizontal)
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(AppColors.Onboarding.bottomColor)
                                        .frame(width: UIScreen.main.bounds.width * 0.4, height: 10)
                                        .frame(maxWidth: .infinity, alignment: framesSelected ? .leading : .trailing)
                                        .padding(.horizontal)
                                }
                            }
                            
                        }
                    }
                    
                    VStack {
                                            
                        ScrollView {
                            LazyVGrid(columns: isiPad ? iPadLayout : iPhoneLayout) {
                                
                                ForEach(framesSelected ? 0..<vm.frames.count + 1 : 0..<vm.customFrames.count + 1, id: \.self) { item in
                                    if item == 0 {
                                        AddCard(title: "Upload")
                                            .onTapGesture(perform: {
                                                withAnimation {
                                                    editType = .upload
                                                    selectedFrame = nil
                                                    editFrame = true
                                                }
                                            })
                                           .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40, height: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40)
                                           .padding()

                                    } else {
                                        let frame = framesSelected ? vm.frames[item - 1] : vm.customFrames[item - 1]
                                                
                                        FrameEditingCard(selectedFrame: $selectedFrame, frame: frame, editType: $editType, editFrame: $editFrame)
                                                .onTapGesture(perform: {
                                                    withAnimation {
                                                        if let isEditable = frame.isEditable, isEditable {
                                                            editType = .edit
                                                            selectedFrame = nil
                                                            selectedFrame = frame
                                                            editFrame = true
                                                        } else {
                                                            alertTitle = "Error"
                                                            alertMessage = "Please duplicate frame to edit"
                                                            showAlert = true
                                                        }
                                                    }
                                                })
                                                .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40, height: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40)
                                                .padding()
                                    }
                                }
                            }
                        }
                        .refreshable {
                            vm.refreshFrames()
                        }
                    }
                }
                .customBackground()
            }
            .onReceive(NotificationCenter.default.publisher(for: .refreshFrame), perform: { _ in
                vm.refreshFrames()
            })
            .alert(alertTitle, isPresented: $showAlert, actions: {
                Button(role: .cancel) {
                    
                } label: {
                    Text("Dismiss")
                }

            }, message: {
                Text(alertMessage)
            })
            .background {
                NavigationLink(destination: FrameEditingScreen(frame: selectedFrame, editType: editType), isActive: $editFrame) { EmptyView() }
            }
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

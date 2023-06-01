//
//  TemplatesScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct TemplatesScreen: View {
    
    let isiPad = UIDevice.current.userInterfaceIdiom == .pad
    
    @State private var eventSelected = false
    @State private var selectEvent = false
    @State private var editSelected = false
    
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
                    
                    Text("Templates")
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    
                    VStack {
                        
                        Text("Choose the templates")
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .fontWeight(.semibold)
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        
                        
                        ScrollView {
                            LazyVGrid(columns: isiPad ? iPadLayout : iPhoneLayout) {
                                ForEach(0..<10) { item in
                                    if item == 0 {
                                        AddCard(title: "Upload")
                                            .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40, height: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40)
                                            .padding()
                                    } else {
                                        NavigationLink(destination: TemplateEditingScreen(), isActive: $editSelected) {
                                            TemplateCard(editSelected: $editSelected)
                                                .frame(width: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40, height: isiPad ?  UIScreen.main.bounds.width * 0.30 : UIScreen.main.bounds.width * 0.40)
                                                .padding()
                                        }
                                        
                                    }
                                }
                            }
                        }
                        
                        CustomButtonView(filled: true, name: "Select Event")
                            .onTapGesture {
                                withAnimation {
                                    selectEvent = true
                                }
                            }
                            .padding()
                        
                    }
                    
                }
                .customBackground()
                .padding(.vertical, 45)
                .padding(.horizontal)
                
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

struct TemplatesScreen_Previews: PreviewProvider {
    static var previews: some View {
        TemplatesScreen()
    }
}

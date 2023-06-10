//
//  MainTabView.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var vm = MainViewModel.shared
    var body: some View {
        TabView {
            EventsScreen(frames: vm.frames)
                .tabItem {
                    Label("Events", image: "events icon")
                }
            
            FramesScreen(frames: vm.frames)
                .tabItem {
                    Label("Frames", image: "Frames icon")
                }
            
            SettingsScreen()
                .tabItem {
                    Label("Settings", image: "settings icon")
                }
        }
        .accentColor(AppColors.Onboarding.loginButton)
        .navigationBarBackButtonHidden(true)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

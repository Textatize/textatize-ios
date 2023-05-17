//
//  MainTabView.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            EventsScreen()
                .tabItem {
                    Label("Events", image: "events icon")
                }
            
            TemplatesScreen()
                .tabItem {
                    Label("Templates", image: "templates icon")
                }
            
            SettingsScreen()
                .tabItem {
                    Label("Settings", image: "settings icon")
                }
            
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

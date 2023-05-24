//
//  TextatizeApp.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/15/23.
//

import SwiftUI

@main
struct TextatizeApp: App {
    @StateObject private var manager = DataManager.shared
    var body: some Scene {
        WindowGroup {
            if manager.user == nil {
                LoginScreen()
            } else {
                MainTabView()
            }
        }
    }
}

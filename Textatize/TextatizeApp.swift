//
//  TextatizeApp.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/15/23.
//

import SwiftUI

@main
struct TextatizeApp: App {    
    init() {
        TextatizeAPI.shared.test.networkSpeedTestStop()
        TextatizeAPI.shared.test.networkSpeedTestStart(UrlForTestSpeed: "https://devapi.textatizeapp.com/unauth/ping")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

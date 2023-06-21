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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.all //By default you want all your views to rotate freely

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}


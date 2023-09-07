//
//  ExpensaApp.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-02.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct ExpensaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

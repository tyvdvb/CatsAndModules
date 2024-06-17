//
//  CatsAndModules_IrynaNazarApp.swift
//  CatsAndModules_IrynaNazar
//
//  Created by Ira Nazar on 2024-05-28.
//

import SwiftUI
import FirebaseCore
import FirebaseCrashlyticsSwift
import FirebaseCrashlytics

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        return true
    }
}

@main
struct CatsAndModules_IrynaNazarApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


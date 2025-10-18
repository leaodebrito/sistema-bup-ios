//
//  sistema_bupApp.swift
//  sistema_bup
//
//  Created by Bruno Brito on 18/10/25.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject private var authController = AuthController()

  var body: some Scene {
    WindowGroup {
      if authController.isAuthenticated {
        ContentView()
          .environmentObject(authController)
      } else {
        LoginView()
          .environmentObject(authController)
      }
    }
  }
}

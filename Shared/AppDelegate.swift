//
//  AppDelegate.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/26.
//

import Foundation
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

//
//  AppDelegate.swift
//  ChristInSong
//
//  Created by Tinashe  on 2021/03/14.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        StoreManager.shared.startObserving()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        StoreManager.shared.stopObserving()
    }
}

//
//  ChristInSongAppDelegate.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-05-17.
//

import Foundation
import FirebaseCore
import UIKit

class ChristInSongAppDelegate : NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Init Firebase
        FirebaseApp.configure()
        
        return true
    }
    
}

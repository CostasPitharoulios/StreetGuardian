//
//  AppDelegate.swift
//  Street Guardian
//
//  Created by Konstantinos Pytharoulios on 10/11/20.
//

import UIKit
import Firebase
// 1: Import Framework
import WatchConnectivity


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //let userDefaults = UserDefaults.standard
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        if !SessionHandler.shared.isSuported() {
            print("WCSession not supported (f.e. on iPad).")
        }
        else{
            print("Session supported from iphone\n\n\n")
        }
        
        return true
    }
    
  


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    

    


}


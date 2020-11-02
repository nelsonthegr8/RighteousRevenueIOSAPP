//
//  AppDelegate.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/1/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
      
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        
        // Override point for customization after application launch.
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
        
        if(UserDefaults.standard.object(forKey: "FirstLaunch") == nil){
            UserDefaults.standard.set(true, forKey: "FirstLaunch")
            UserDefaults.standard.set(false, forKey: "UserPayed")
            UserDefaults.standard.set(1000.00,forKey: "UserMonthlyIncome")
            UserDefaults.standard.set(0,forKey: "SelectedReminderDay")
            UIApplication.shared.theme_setStatusBarStyle(GlobalPicker.StatusBarStyle, animated: true)
            if(CheckInternet.Connection()){
                UserDefaults.standard.set(false, forKey: "InternetDisconnected")
            }else{
                UserDefaults.standard.set(true, forKey: "InternetDisconnected")
            }
        }
        
        MyThemes.restoreLastTheme()
       
        let tabBar = UITabBar.appearance()
                
        tabBar.theme_barTintColor = GlobalPicker.barBackgroundColor
        tabBar.theme_tintColor = GlobalPicker.tabButtonTintColor
        tabBar.theme_unselectedItemTintColor = GlobalPicker.tabButtonTintColor
        
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


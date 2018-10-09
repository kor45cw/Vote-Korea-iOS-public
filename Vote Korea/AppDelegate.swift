//
//  AppDelegate.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 11..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import Firebase
import AlamofireNetworkActivityIndicator
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().tintColor = .white
        NetworkActivityIndicatorManager.shared.isEnabled = true
        FirebaseApp.configure()
        
        let sendIcon = UIApplicationShortcutIcon(templateImageName: "icVoteInfo")
        let sendItem = UIApplicationShortcutItem(type: "Send", localizedTitle: "선거 정보", localizedSubtitle: nil, icon: sendIcon, userInfo: nil)
        
        let receiveIcon = UIApplicationShortcutIcon(templateImageName: "icCandidate")
        let receiveItem = UIApplicationShortcutItem(type: "Receive", localizedTitle: "공지", localizedSubtitle: nil, icon: receiveIcon, userInfo: nil)
        
        let receiveIcon2 = UIApplicationShortcutIcon(templateImageName: "icVoteplace")
        let receiveItem2 = UIApplicationShortcutItem(type: "Receive2", localizedTitle: "투표소 찾기", localizedSubtitle: nil, icon: receiveIcon2, userInfo: nil)
        
        UIApplication.shared.shortcutItems = [sendItem, receiveItem, receiveItem2]
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerNotification() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func deregisterRemoteNotification() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem))
    }
    
    private func handleShortcut(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        
        guard let rootTabController = window?.rootViewController as? UITabBarController else { return false }
        guard let rootNavigationController = rootTabController.selectedViewController as? UINavigationController else { return false }
        rootNavigationController.popToRootViewController(animated: false)
        
        if shortcutType == "Send" {
            rootTabController.selectedIndex = 0
            let rootNavigationController = rootTabController.selectedViewController as! UINavigationController
            rootNavigationController.popToRootViewController(animated: false)
            return true
        } else if shortcutType == "Receive" {
            rootTabController.selectedIndex = 1
            let rootNavigationController = rootTabController.selectedViewController as! UINavigationController
            rootNavigationController.popToRootViewController(animated: false)
            return true
        } else if shortcutType == "Receive2" {
            rootTabController.selectedIndex = 2
            let rootNavigationController = rootTabController.selectedViewController as! UINavigationController
            rootNavigationController.popToRootViewController(animated: false)
            return true
        }
        return false
    }
}


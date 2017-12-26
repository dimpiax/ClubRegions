//
//  AppDelegate.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let model = MainModel()
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let opts = launchOptions {
            if let locationData = opts[.location] {
                print("locationData: \(locationData)")
            }
        }
        else {
            // default launch
            model.locationManager.requestPermission()
            
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                print("Auth for notification center is not granted, error: \(String(describing: error))")
            }
        }
        
        model.requestRegions {[weak self] _ in
            self?.model.updateTracking()
        }
        
        // add observers
        NotificationCenter.default.addObserver(observer: self, selector: #selector(didEnterLocationRegion(_:)), name: .didEnterLocationRegion)
        NotificationCenter.default.addObserver(observer: self, selector: #selector(didExitLocationRegion(_:)), name: .didExitLocationRegion)
        NotificationCenter.default.addObserver(observer: self, selector: #selector(willShowErrorAlertSheet(_:)), name: .willShowErrorAlertSheet)
        
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
    
    // PRIVATE
    // * SELECTOR
    @objc private func didEnterLocationRegion(_ notification: Notification) {
        guard let region = notification.userInfo?["region"] as? Regionable else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "You've just entered in \(region.title) area"
        content.body = "Please tap here and you will see useful information"

        let notification = getUNotificationFrom(region: region, content: content,
                                                trigger: UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false))
        
        UNUserNotificationCenter.current().add(notification) { error in
            guard let error = error else { return }
            
            print("notification adding error: \(error)")
        }
    }
    
    @objc private func didExitLocationRegion(_ notification: Notification) {
        guard let region = notification.userInfo?["region"] as? Regionable else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "You left \(region.title) area minute ago"
        content.body = "Please tap here and leave your opinion by rating"
        
        let notification = getUNotificationFrom(region: region, content: content,
                                                trigger: UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false))
        
        UNUserNotificationCenter.current().add(notification) { error in
            guard let error = error else { return }
            
            print("notification adding error: \(error)")
        }
    }
    
    @objc private func willShowErrorAlertSheet(_ notification: Notification) {
        if
            let title = notification.userInfo?["title"] as? String,
            let message = notification.userInfo?["message"] as? String {
            
            window?.rootViewController?.present(UIAlertController(simpleTitle: title, message: message))
        }
        else {
            window?.rootViewController?.present(UIAlertController(simpleTitle: "Unknown Error", message: "Try again later"))
        }
    }
    
    // * METHODS
    private func getUNotificationFrom(region: Regionable, content: UNMutableNotificationContent, trigger: UNNotificationTrigger) -> UNNotificationRequest {
        return UNNotificationRequest(identifier: region.id, content: content, trigger: trigger)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // show notification in foreground
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // good practice to distinct identifier by prefix,
        // but not in current demo case,
        // so imagine that we have only identifiers linked to Region
        let id = response.notification.request.identifier
        if let _ = model.getRegionBy(id: id) {
            // TODO: present related view controller
        }
    }
}

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
                if let error = error {
                    print("Auth for notification center is not granted, error: \(error)")
                }
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

    // PRIVATE
    // * SELECTOR
    @objc private func didEnterLocationRegion(_ notification: Notification) {
        guard
            let regionId = notification.userInfo?["regionId"] as? String,
            let region = model.getRegionBy(id: regionId)
        else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "You've just entered in \(region.title) area"
        content.body = "Please tap here and you will see useful information"

        let notification = getUNotificationFrom(identifier: "\(regionId):enter", content: content,
                                                trigger: UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false))
        
        UNUserNotificationCenter.current().add(notification) { error in
            guard let error = error else { return }
            
            print("notification adding error: \(error)")
        }
    }
    
    @objc private func didExitLocationRegion(_ notification: Notification) {
        guard
            let regionId = notification.userInfo?["regionId"] as? String,
            let region = model.getRegionBy(id: regionId)
        else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "You left \(region.title) area minute ago"
        content.body = "Please tap here and leave your opinion by rating"
        
        let notification = getUNotificationFrom(identifier: "\(regionId):exit", content: content,
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
    private func getUNotificationFrom(identifier: String, content: UNMutableNotificationContent, trigger: UNNotificationTrigger) -> UNNotificationRequest {
        return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
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
        // so imagine that we have only identifiers linked to Region Id and Action
        let identifier = response.notification.request.identifier
        let idComponents = identifier.components(separatedBy: ":")
        if idComponents.count == 2 {
            let id = idComponents.first!
            let action = idComponents.last!
            if let region = model.getRegionBy(id: id) {
                // TODO: present related view controller
                print("present some controller with region: \(region.id) and title: \(region.title) for action: \(action)")
            }
        }
        
        completionHandler()
    }
}

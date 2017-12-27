//
//  NotificationCenter+.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation

extension NotificationCenter {
    func addObserver(observer: Any, selector: Selector, name: NSNotification.Name) {
        addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    func removeObserver(observer: Any, name: NSNotification.Name) {
        removeObserver(observer, name: name, object: nil)
    }
    
    func post(name: NSNotification.Name) {
        post(name: name, object: nil)
    }
    
    func post(name: NSNotification.Name, userInfo: [AnyHashable: Any]) {
        post(name: name, object: nil, userInfo: userInfo)
    }
}

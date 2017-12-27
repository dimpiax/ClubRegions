//
//  NSNotification.Name+.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let didEnterLocationRegion = Notification.Name("didEnterLocationRegion")
    static let didExitLocationRegion = Notification.Name("didExitLocationRegion")
    
    static let willShowErrorAlertSheet = Notification.Name("willShowErrorAlertSheet")
}

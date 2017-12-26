//
//  CLCircularRegion+.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/27/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation
import CoreLocation

extension CLCircularRegion {
    convenience init(region: Geofence) {
        self.init(center: region.coordinate, radius: region.radius, identifier: region.id)
        
        notifyOnEntry = region.notifyOnEntry
        notifyOnExit = region.notifyOnExit
    }
}

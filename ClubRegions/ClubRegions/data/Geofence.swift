//
//  Region.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation
import CoreLocation

struct Geofence: Regionable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let radius: CLLocationDistance
    
    let title: String
    
    let notifyOnEntry = true
    let notifyOnExit = true
}

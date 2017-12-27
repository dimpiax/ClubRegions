//
//  RandomGeofenceStrategy.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/27/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation
import CoreLocation

class RandomGeofenceStrategy: RegionStrategyProtocol {
    private let maxCount = 3
    private let visibleRadius: CLLocationDistance = 10_000 // in meters
    
    private var _regions: Set<CLRegion>?
    
    func set(regions value: Set<CLRegion>?) {
        _regions = value
    }
    
    func getSuitableRegionsWith(manager: CLLocationManager) throws -> (stop: Set<CLRegion>, start: Set<CLRegion>) {
        guard let regions = _regions else {
            throw AppError.badAccess
        }
        
        let arr = Array(regions)
        var copy = type(of: regions.self).init()
        for _ in 0..<3 {
            copy.insert(arr[Int(arc4random_uniform(UInt32(regions.count)))])
        }
        
        return (stop: manager.monitoredRegions, start: copy)
    }
    
    func didEnter(region: CLRegion, manager: CLLocationManager) {
        print("Hello from random region: \(region.identifier)")
    }
    
    func didExit(region: CLRegion, manager: CLLocationManager) {
        // empty
    }
}

//
//  DefaultGeofenceStrategy.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation
import CoreLocation

class DefaultGeofenceStrategy: RegionStrategyProtocol {
    private let maxCount = 10
    private let visibleRadius: CLLocationDistance = 5000 // in meters
    
    private var _regions: Set<CLRegion>?
    
    func set(regions value: Set<CLRegion>?) {
        _regions = value
    }
    
    func getSuitableRegionsWith(manager: CLLocationManager) throws -> (stop: Set<CLRegion>, start: Set<CLRegion>) {
        guard let location = manager.location, let regions = _regions else {
            throw AppError.badAccess
        }
        
        // get near geofences
        let userCoordinate = location.coordinate
        
        let visibleRegions = Set(regions.flatMap { $0 as? CLCircularRegion })
            .filter { region in
                userCoordinate.intersectsWith(radius: visibleRadius, circularLocation: (region.center, region.radius))
            }
        
        let monitoredRegions = manager.monitoredRegions.flatMap { $0 as? CLCircularRegion }
        
        let result = monitoredRegions.reduce(Container<CLCircularRegion>()) { sum, region -> Container<CLCircularRegion> in
            let isUserSeeing = userCoordinate.intersectsWith(radius: visibleRadius, circularLocation: (region.center, region.radius))
            if isUserSeeing {
                // set to white bucket
                sum.white.insert(region)
            }
            else {
                // set to black bucket
                sum.black.insert(region)
            }
            return sum
        }
        
        let existRegions = result.white
        
        // distinct newer regions
        let allowedRegions = visibleRegions.subtracting(existRegions)
        
        // limit by max allowed count and free space for insert
        let freeCount = min(maxCount, max(0, maxCount - existRegions.count))
        let startRegions = Set(allowedRegions.prefix(freeCount))
        
        return (stop: result.black, start: startRegions)
    }
    
    func didEnter(region: CLRegion, manager: CLLocationManager) {
        // empty
    }
    
    func didExit(region: CLRegion, manager: CLLocationManager) {
        // empty
    }
}

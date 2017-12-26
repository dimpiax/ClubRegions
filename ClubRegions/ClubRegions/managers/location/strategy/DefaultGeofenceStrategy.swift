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
    private let maxCount = 20
    
    private var _regions: [Geofence]?
    private var _location: CLLocation?
    
    private var _intersectedRegions = Set<CLRegion>()
    
    func set(regions value: [Geofence]?) {
        _regions = value
    }
    
    func getSuitableRegionsWith(manager: CLLocationManager) -> (stop: [Geofence], start: [Geofence]) {
        
        
        return (stop: [], start: [])
    }
    
    func didEnter(region: CLRegion, manager: CLLocationManager) {
        _intersectedRegions.insert(region)
    }
    
    func didExit(region: CLRegion, manager: CLLocationManager) {
        _intersectedRegions.remove(region)
    }
}

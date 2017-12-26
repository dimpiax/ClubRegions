//
//  DefaultRegionStrategy.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation
import CoreLocation

class DefaultRegionStrategy: RegionStrategyProtocol {
    private var _regions: [Region]?
    private var _location: CLLocation?
    
    func set(regions value: [Region]?) {
        _regions = value
    }
    
    func getSuitableRegionsWith(manager: CLLocationManager) -> (stop: [CLRegion], start: [CLRegion]) {
        // TODO: implement logic
        
        return (stop: [], start: [])
    }
    
    func didEnter(region: CLRegion, manager: CLLocationManager) {
        print("did enter region")
    }
    
    func didExit(region: CLRegion, manager: CLLocationManager) {
        print("did exit region")
    }
}

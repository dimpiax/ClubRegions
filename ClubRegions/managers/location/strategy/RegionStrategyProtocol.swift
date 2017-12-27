//
//  RegionStrategyProtocol.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation
import CoreLocation

protocol RegionStrategyProtocol {
    func set(regions value: Set<CLRegion>?)
    
    func getSuitableRegionsWith(manager: CLLocationManager) throws -> (stop: Set<CLRegion>, start: Set<CLRegion>)
    
    func didEnter(region: CLRegion, manager: CLLocationManager)
    func didExit(region: CLRegion, manager: CLLocationManager)
}

//
//  LocationManager.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    enum Mode {
        case none, `default`, full
    }
    
    private var _regionStrategy: RegionStrategyProtocol = DefaultRegionStrategy()
    
    private lazy var _manager: CLLocationManager = {
        let value = CLLocationManager()
        value.delegate = self
        return value
    }()
    
    override init() {
        super.init()
        
        set(regionStrategy: _regionStrategy)
    }
    
    func requestPermission() {
        switch CLLocationManager.authorizationStatus() {
            // request default capability
            case .notDetermined: _manager.requestWhenInUseAuthorization()
            
            case .restricted, .denied: updateMode(.none)
            case .authorizedWhenInUse: updateMode(.default)
            case .authorizedAlways: updateMode(.full)
        }
    }
    
    func set(regionStrategy value: RegionStrategyProtocol) {
        _regionStrategy = value
    }
    
    func set(regions value: [Region]?) {
        _regionStrategy.set(regions: value)
    }
    
    private func updateMode(_ value: Mode) {
        switch value {
            case .default:
                print("default mode")
                _manager.startUpdatingLocation()
                fallthrough
            
            case .full: print("full mode")
            
            case .none: print("Location manager functions are not able")
        }
    }
    
    private func updateRegions() {
        let regions = _regionStrategy.getSuitableRegionsWith(manager: _manager)
        
        // stop monitoring certain regions
        regions.stop.forEach { value in
            _manager.stopMonitoring(for: value)
        }
        
        // start monitoring certain regions
        regions.start.forEach { value in
            _manager.startMonitoring(for: value)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways: print("all has been setup")
            case .authorizedWhenInUse: _manager.requestAlwaysAuthorization()
            
            default: print("didChangeAuthorization not good, status: \(status.rawValue)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateRegions()
    }
}

extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        _regionStrategy.didEnter(region: region, manager: manager)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        _regionStrategy.didExit(region: region, manager: manager)
    }
}

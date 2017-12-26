//
//  LocationManager.swift
//  ClubRegions
//
//  DefaultRegionStrategy.swift
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
    
    var isWorking: Bool {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse, .authorizedAlways: return true
            default: return false
        }
    }
    
    private var _regionStrategy: RegionStrategyProtocol = DefaultGeofenceStrategy()
    
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
        guard CLLocationManager.locationServicesEnabled() else {
            NotificationCenter.default.post(name: .willShowErrorAlertSheet,
                                            userInfo: ["title": "Unable Service", "message": "Location services is not enabled, please turn on in General"])
            return
        }
        
        guard CLLocationManager.isMonitoringAvailable(for: CLRegion.self) else {
            NotificationCenter.default.post(name: .willShowErrorAlertSheet,
                                            userInfo: ["title": "Unable Service", "message": "Location monitoring services currently is not available"])
            return
        }
        
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
    
    func set(regions value: [Geofence]?) {
        _regionStrategy.set(regions: value)
    }
    
    func update() {
        guard isWorking else { return }
        
        _manager.stopUpdatingLocation()
        _manager.startUpdatingLocation()
    }
    
    private func updateMode(_ value: Mode) {
        switch value {
            case .default:
                _manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                _manager.distanceFilter = 50 // in meters
                _manager.startUpdatingLocation()
            
            case .full:
                _manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                _manager.distanceFilter = 100 // in meters
                _manager.startUpdatingLocation()
            
            case .none: print("Location manager functions are not able")
        }
    }
    
    private func updateRegions() {
        let regions = _regionStrategy.getSuitableRegionsWith(manager: _manager)
        
        // stop monitoring certain regions
        regions.stop
            .map { CLCircularRegion(region: $0) }
            .forEach { _manager.stopMonitoring(for: $0) }
        
        // start monitoring certain regions
        regions.start
            .map { CLCircularRegion(region: $0) }
            .forEach { _manager.startMonitoring(for: $0) }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways: print("all has been setup")
            case .authorizedWhenInUse: _manager.requestAlwaysAuthorization()
            
            default: print("didChangeAuthorization not available, with status: \(status.rawValue)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateRegions()
    }
}

extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        _regionStrategy.didEnter(region: region, manager: manager)
        NotificationCenter.default.post(name: .didEnterLocationRegion, userInfo: ["region": region])
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        _regionStrategy.didExit(region: region, manager: manager)
        NotificationCenter.default.post(name: .didExitLocationRegion, userInfo: ["region": region])
    }
}

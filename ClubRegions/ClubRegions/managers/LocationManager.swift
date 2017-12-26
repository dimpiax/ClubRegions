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
    
    private lazy var _manager: CLLocationManager = {
        let value = CLLocationManager()
        value.delegate = self
        return value
    }()
    
    func requestPermission() {
        switch CLLocationManager.authorizationStatus() {
            // request default capability
            case .notDetermined: _manager.requestWhenInUseAuthorization()
            
            case .restricted, .denied: updateMode(.none)
            case .authorizedWhenInUse: updateMode(.default)
            case .authorizedAlways: updateMode(.full)
        }
    }
    
    private func updateMode(_ value: Mode) {
        switch value {
            case .full: print("full mode")
            case .default: print("default mode")
            
            case .none: print("Location manager functions are not able")
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
}

//
//  CLLocationCoordinate2D+.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/27/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension CLLocationCoordinate2D {
    func intersectsWith(radius: CLLocationDistance, circularLocation: (CLLocationCoordinate2D, CLLocationDistance)) -> Bool {
        let p1 = MKMapPointForCoordinate(self)
        let p2 = MKMapPointForCoordinate(circularLocation.0)
        
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        let distance = sqrt(dx ** 2 + dy ** 2)
        
        return distance - radius - circularLocation.1 < 0
    }
}

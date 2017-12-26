//
//  ServerRequestor.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation
import CoreLocation // until implementation through JSONDecoder

struct ServerRequestor: APIRequestConnectorProtocol {
    func requestRegions(completion: @escaping (Result<[Region], AppError>) -> Void) {
        let data = [
            Region(id: "1", coordinate: CLLocationCoordinate2D(latitude: 41.010000, longitude: 2.010000), radius: 100, title: "A"),
            Region(id: "2", coordinate: CLLocationCoordinate2D(latitude: 41.020000, longitude: 2.020000), radius: 100, title: "B"),
            Region(id: "3", coordinate: CLLocationCoordinate2D(latitude: 41.030000, longitude: 2.030000), radius: 100, title: "C"),
            Region(id: "4", coordinate: CLLocationCoordinate2D(latitude: 41.040000, longitude: 2.040000), radius: 100, title: "D"),
            Region(id: "5", coordinate: CLLocationCoordinate2D(latitude: 41.050000, longitude: 2.050000), radius: 100, title: "E"),
            Region(id: "6", coordinate: CLLocationCoordinate2D(latitude: 41.060000, longitude: 2.060000), radius: 100, title: "F"),
            Region(id: "7", coordinate: CLLocationCoordinate2D(latitude: 41.070000, longitude: 2.070000), radius: 100, title: "G")
        ]
        
        completion(Result(value: data))
    }
}

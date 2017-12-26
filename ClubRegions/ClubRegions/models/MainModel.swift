//
//  MainModel.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation

class MainModel {
    var regions: [Geofence]?
    
    let apiRequestConnector: APIRequestConnector = {
        let value = APIRequestConnector()
        
        // set server requestor as default
        value.set(requestor: ServerRequestor())
        return value
    }()
    
    let locationManager = LocationManager()
    
    func requestRegions(completion: @escaping (Result<[Geofence], AppError>) -> Void) {
        apiRequestConnector.requestRegions {[weak self] result in
            switch result {
                case .success(let value): self?.regions = value
                case .failure: self?.regions = nil
            }
            
            completion(result)
        }
    }
    
    func updateTracking() {
        locationManager.set(regions: regions)
        locationManager.update()
    }
    
    func getRegionBy(id: String) -> Geofence? {
        if let region = regions?.first(where: { $0.id == id }) {
            return region
        }
        else {
            // TODO:
            // 1. lookup on persistent storage
            // 2. lookup on server through `apiRequestConnector`
        }
        
        return nil
    }
}

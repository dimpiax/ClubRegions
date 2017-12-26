//
//  MainModel.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation

class MainModel {
    var regions: [Region]?
    
    let apiRequestConnector: APIRequestConnector = {
        let value = APIRequestConnector()
        
        // set server requestor as default
        value.set(requestor: ServerRequestor())
        return value
    }()
    
    let locationManager = LocationManager()
    
    func requestRegions(completion: @escaping (Result<[Region], AppError>) -> Void) {
        apiRequestConnector.requestRegions {[weak self] result in
            switch result {
                case .success(let value): self?.regions = value
                case .failure: self?.regions = nil
            }
            
            completion(result)
        }
    }
    
    func updateTracking() {
        
    }
}

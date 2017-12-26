//
//  APIRequestConnector.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation

class APIRequestConnector: APIRequestConnectorProtocol {
    private var requestor: APIRequestConnectorProtocol = DummyRequestor()
    
    func set(requestor value: APIRequestConnectorProtocol) {
        requestor = value
    }
    
    func requestRegions(completion: @escaping (Result<[Geofence], AppError>) -> Void) {
        requestor.requestRegions(completion: completion)
    }
}

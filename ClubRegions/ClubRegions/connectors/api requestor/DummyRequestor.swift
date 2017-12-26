//
//  DummyRequestor.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation

struct DummyRequestor: APIRequestConnectorProtocol {
    func requestRegions(completion: @escaping (Result<[Geofence], AppError>) -> Void) {
        completion(Result.failure(.notImplemented))
    }
}

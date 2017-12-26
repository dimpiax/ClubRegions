//
//  APIRequestConnectorProtocol.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation

protocol APIRequestConnectorProtocol {
    func requestRegions(completion: @escaping (Result<[Region], AppError>) -> Void)
}

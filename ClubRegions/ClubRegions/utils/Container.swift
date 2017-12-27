//
//  Container.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/27/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation

class Container<T: Hashable> {
    var white = Set<T>()
    var black = Set<T>()
}

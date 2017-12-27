//
//  Double+.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/27/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation

precedencegroup HighPrecedence {
    higherThan: BitwiseShiftPrecedence
}

infix operator **: HighPrecedence

extension Double {
    static func **(base: Double, exp: Double) -> Double {
        return pow(base, exp)
    }
}

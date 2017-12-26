//
//  UIAlertController+.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/26/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    convenience init(simpleTitle title: String, message: String, preferredStyle: UIAlertControllerStyle = .alert, confirmTitle: String = "OK") {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        
        addAction(UIAlertAction(title: confirmTitle))
    }
}

extension UIAlertAction {
    convenience init(title: String) {
        self.init(title: title, style: .default, handler: nil)
    }
}

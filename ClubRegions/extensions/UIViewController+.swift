//
//  UIViewController+.swift
//  ClubRegions
//
//  Created by Dima Pilipenko on 12/27/17.
//  Copyright © 2017 dimpiax. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool = true) {
        present(viewControllerToPresent, animated: flag, completion: nil)
    }
}

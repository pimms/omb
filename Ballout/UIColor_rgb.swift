//
//  UIColor_rgb.swift
//  Ballout
//
//  Created by Joakim Stien on 07/07/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
}

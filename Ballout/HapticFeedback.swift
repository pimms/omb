//
//  HapticFeedback.swift
//  Ballout
//
//  Created by Joakim Stien on 31/07/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import UIKit

class HapticFeedback : NSObject {
    static public var sharedInstance: HapticFeedback?
    
    private var generator: UIImpactFeedbackGenerator?
    
    override init() {
        self.generator = UIImpactFeedbackGenerator(style: .heavy)
    }
    
    func fire() {
        
        self.generator?.impactOccurred()
    }
}

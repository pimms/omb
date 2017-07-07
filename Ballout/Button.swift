//
//  Button.swift
//  Ballout
//
//  Created by Joakim Stien on 26/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import SpriteKit

class Button: SKSpriteNode {
    public var gameScene: SKScene?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func onTouchBegan() -> Void {
        // No default action
    }
    
    // Touch ended is called whenver a touch has ended - regardless of whether
    // or not the touch is still active. onTouchEnded might be called multiple
    // times from the same touch if the user is swiping across the screen.
    func onTouchEnded() -> Void {
        // No default action
    }

    func onClick() -> Void {
        // No default action
    }
}

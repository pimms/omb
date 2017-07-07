//
//  SpeedButton.swift
//  Ballout
//
//  Created by Joakim Stien on 26/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import SpriteKit

class SpeedButton: Button {
    private var fastForward: Bool = true
    private var scale: CGFloat = CGFloat(0.14)
    
    override func onClick() {
        fastForward = !fastForward
        
        if !fastForward {
            print("Normal speed please")
            self.texture = SKTexture(imageNamed: "normalSpeed")
            self.gameScene?.physicsWorld.speed = CGFloat(1.0)
        } else {
            print("Double speed please")
            self.texture = SKTexture(imageNamed: "fastSpeed")
            self.gameScene?.physicsWorld.speed = CGFloat(2.0)
        }
    }
}

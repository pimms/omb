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
    private var fastForward: Bool = false
    private var scale: CGFloat = CGFloat(0.14)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.showHoverTint = false
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.showHoverTint = false
    }
    
    override func onClick() {
        fastForward = !fastForward
        
        let node = self.childNode(withName: "image") as! SKSpriteNode
        
        if !fastForward {
            print("Normal speed please")
            node.texture = SKTexture(imageNamed: "normalSpeed")
            self.gameScene?.physicsWorld.speed = CGFloat(1.0)
        } else {
            print("Double speed please")
            node.texture = SKTexture(imageNamed: "fastSpeed")
            self.gameScene?.physicsWorld.speed = CGFloat(2.0)
        }
    }
}

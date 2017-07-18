//
//  Ball.swift
//  Ballout
//
//  Created by Joakim Stien on 17/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Ball: SKShapeNode {
    var radius : Int
    
    private static var defaultRadius: Int = 14
    private static var defaultTexture: String = "Spaceship"
    
    init(createPhysics physics: Bool) {
        self.radius = Ball.defaultRadius;
        super.init()

        self.path = CGPath(ellipseIn: CGRect(origin: CGPoint.init(x:-radius,y:-radius),
                                             size: CGSize(width: (CGFloat)(radius*2),
                                                          height: (CGFloat)(radius*2))),
                           transform: nil)
        self.strokeColor = UIColor.clear
        self.name = "ball"
        self.zPosition = 1

        //self.fillTexture = textureBall
        self.fillColor = UIColor.white
        
        if (physics) {
            self.createPhysics()
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.radius))
        self.physicsBody!.affectedByGravity = true
        self.physicsBody!.isDynamic = true
        self.physicsBody!.restitution = 1.0
        self.physicsBody!.linearDamping = 0.0
        self.physicsBody!.mass = 1.0
        self.physicsBody!.friction = 0.0
        self.physicsBody!.categoryBitMask = PhysicsFlags.ballBit
        self.physicsBody!.collisionBitMask = PhysicsFlags.blockBit
    }
}

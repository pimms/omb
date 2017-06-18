//
//  Spawnable.swift
//  Ballout
//
//  Created by Joakim Stien on 18/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class Spawnable: SKShapeNode {
    private var size: CGSize
    
    init(gridSize: CGSize, collideWithBall: Bool) {
        self.size = gridSize
        super.init()
        
        let collisionBitmask = (collideWithBall ? PhysicsFlags.ballBit : 0)
        let categoryBitMask = (collideWithBall ? PhysicsFlags.blockBit : 0)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody!.isDynamic = false
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.friction = 0.0
        self.physicsBody!.collisionBitMask = collisionBitmask
        self.physicsBody!.categoryBitMask = categoryBitMask
        self.physicsBody!.contactTestBitMask = PhysicsFlags.ballBit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func shouldBeRemoved() -> Bool {
        fatalError("Spawnable must override 'shouldBeRemoved'")
    }
    
    public func onBallCollided() -> Void {
        fatalError("Spawnable must override 'onBallCollided'")
    }
    
    public func onFulfillment(gameScore: GameScore!) {
        fatalError("Spawnable must override 'onFulfillment'")
    }
}

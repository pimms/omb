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

class Spawnable: SKShapeNode, Serializable {
    enum PhysicsShape {
        case Circle
        case Square
    }
    
    var spawnType: SpawnType { fatalError("spawnType attribute must be overriden") }
    
    private var size: CGSize
    
    init(gridSize: CGSize, collideWithBall: Bool, shape: PhysicsShape) {
        self.size = gridSize
        super.init()
        
        let collisionBitmask = (collideWithBall ? PhysicsFlags.ballBit : 0)
        let categoryBitMask = (collideWithBall ? PhysicsFlags.blockBit : 0)
        
        if shape == .Circle {
            self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(size.width/2))
        } else if shape == .Square {
            self.physicsBody = SKPhysicsBody(rectangleOf: size)
        }
        
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
    
    // Spawnables must declare whether or not they should be removed from the
    // playing field. If they should, they are considered fulfilled, and
    // 'onFulfillment' is called.
    public func shouldBeRemoved() -> Bool {
        fatalError("Spawnable must override 'shouldBeRemoved'")
    }
    
    // Called whenever a Spawnable has been hit by a ball.
    public func onBallCollided() -> Void {
        fatalError("Spawnable must override 'onBallCollided'")
    }
    
    // This method is called on Spawnables when they have been fulfilled (i.e.,
    // destroyed by the ball). Changes to the GameScore must be done accordingly.
    public func onFulfillment(gameScore: GameScore!) {
        fatalError("Spawnable must override 'onFulfillment'")
    }
    
    // Deadly Spawnables cause a game over when they cross the death-line
    public func isDeadly() -> Bool {
        fatalError("Spawnable must override 'isDeadly'")
    }
    
    public func showWarning(level: WarningLevel) {
        // No default behaviour
    }
    
    func serialize(coder: NSCoder) {
        fatalError("Spawnables must override serialize(coder:)")
    }
    
    func deserialize(coder: NSCoder) {
        fatalError("Spawnables must override deserialize(coder:)")
    }
}

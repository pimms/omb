//
//  ExtraBall.swift
//  Ballout
//
//  Created by Joakim Stien on 18/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class ExtraBall: Spawnable {
    private var hit: Bool = false
    
    override var spawnType: SpawnType { return .extraBall }
    
    init(size: CGSize) {
        super.init(gridSize: CGSize(width: size.width/3, height: size.height/3),
                   collideWithBall: false, shape: .Circle)
        
        let ball = Ball(createPhysics: false)
        ball.run(SKAction.repeatForever(SKAction(named: "ExtraBallOscillation")!))
        self.addChild(ball)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func onFulfillment(gameScore: GameScore!) {
        gameScore.numBalls += 1
        
        _ = SKEmitterNode.fireAndForget(name: "ExtraPickedUp.sks", position: self.position, parent: self.parent)
    }
    
    override func shouldBeRemoved() -> Bool {
        return self.hit
    }
    
    override func onBallCollided() {
        self.hit = true
        SFXController.shared?.play(sfx: .extraBallHit)
    }
    
    override func isDeadly() -> Bool {
        return false
    }
    
    override func serialize(coder: NSCoder) {
        // Nothing to do
    }
    
    override func deserialize(coder: NSCoder) {
        // Nothing to do
    }
}

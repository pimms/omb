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
    
    init(size: CGSize) {
        super.init(gridSize: size, collideWithBall: false)
        
        let ball = Ball(createPhysics: false)
        ball.run(SKAction.repeatForever(SKAction(named: "ExtraBallOscillation")!))
        self.addChild(ball)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func onFulfillment(gameScore: GameScore!) {
        gameScore.numBalls += 1
    }
    
    override func shouldBeRemoved() -> Bool {
        return self.hit
    }
    
    override func onBallCollided() {
        self.hit = true
    }
    
    override func isDeadly() -> Bool {
        return false
    }
}

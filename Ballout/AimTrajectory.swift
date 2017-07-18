//
//  AimTrajectory.swift
//  Ballout
//
//  Created by Joakim Stien on 17/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class AimTrajectory: SKNode, Updatable {
    private var angle: CGFloat = 0.0
    private var ballDist: CGFloat = 0.0
    private var balls: [Ball]! = [Ball]()
    private var elapsed: TimeInterval = 0.0
    
    override init() {
        super.init()
        createBalls()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        createBalls()
    }
    
    public func setAimAngle(aimAngle angle: CGFloat, distance: CGFloat) {
        self.angle = angle
        self.ballDist = distance
    }
    
    private func createBalls() {
        for _ in 0...9 {
            let b = Ball(createPhysics: false)
            balls.append(b)
            addChild(b)
        }
    }
    
    func update(deltaTime dt: TimeInterval) {
        self.elapsed += dt * 5.0
        while self.elapsed > 1.0 {
            self.elapsed -= 1.0
        }
        
        let unit = CGVector(dx: cos(self.angle), dy: sin(self.angle))
        
        for i in 0...self.balls.count-1 {
            let ball = self.balls[i]
            ball.position.x = unit.dx * self.ballDist * (CGFloat(i) + CGFloat(self.elapsed))
            ball.position.y = unit.dy * self.ballDist * (CGFloat(i) + CGFloat(self.elapsed))
            
            if i == 0 {
                ball.alpha = CGFloat(self.elapsed) * 0.8
            } else if i == self.balls.count-1 {
                ball.alpha = 1.0 - CGFloat(self.elapsed) * 0.8
            } else {
                ball.alpha = 0.8
            }
        }
    }
    
}

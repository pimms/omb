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

class AimTrajectory: SKNode {
    var angle: CGFloat = 0.0
    var balls: [Ball]! = [Ball]()
    
    override init() {
        super.init()
        createBalls()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        createBalls()
    }
    
    public func setAimAngle(aimAngle angle: CGFloat) {
        self.angle = angle
        
        let deltaDist: CGFloat = 50
        let unit = CGVector(dx: cos(angle), dy: sin(angle))

        var index: Int = 0
        for b in balls {
            b.position.x = unit.dx * deltaDist * CGFloat(index)
            b.position.y = unit.dy * deltaDist * CGFloat(index)
            index += 1
        }
        
    }
    
    
    private func createBalls() {
        for _ in 0...9 {
            let b = Ball(createPhysics: false)
            b.physicsBody?.affectedByGravity = false
            //b.isHidden = true
            balls.append(b)
            addChild(b)
        }
    }
    
}

//
//  OMBLabel.swift
//  Ballout
//
//  Created by Joakim Stien on 06/08/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import SpriteKit

class OMBLabel : SKNode {
    private var scaleDirection: Int = 1
    private var rotateDirection: Float = -1.0
    
    override init() {
        super.init()
        scheduleRotation()
        scheduleScaling()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scheduleRotation()
        scheduleScaling()
    }
    
    private func scheduleRotation() {
        let dur = 2.5
        let angle = 0.261799 * 2 * self.rotateDirection
        self.rotateDirection *= -1.0
        
        let rot = SKAction.rotate(byAngle: CGFloat(angle), duration: dur)
        rot.timingMode = .easeInEaseOut
        let call = SKAction.run({() in self.scheduleRotation()})
        let seq = SKAction.sequence([rot, call])
        self.run(seq)
    }
    
    private func scheduleScaling() {
        let dur = 1.0
        let toScale: CGFloat = (scaleDirection == 1 ? 1.4 : 1.0)
        scaleDirection = (scaleDirection == 1 ? 0 : 1)
        
        let scale = SKAction.scale(to: toScale, duration: dur)
        scale.timingMode = .easeInEaseOut
        let call = SKAction.run({() in self.scheduleScaling()})
        let seq = SKAction.sequence([scale, call])
        self.run(seq)
    }
    
}

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
    private var numRotations: Int = 0
    
    private var label: SKLabelNode?
    private var scaleDirection: Int = 1
    private var rotateDirection: Float = -1.0
    private var isBusy: Bool = false
    
    override init() {
        super.init()
        bindChildren()
        scheduleRotation()
        scheduleScaling()
        registerEventHandlers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bindChildren()
        scheduleRotation()
        scheduleScaling()
        registerEventHandlers()
    }
    
    private func bindChildren() {
        self.label = self.childNode(withName: "label") as? SKLabelNode
    }

    private func registerEventHandlers() {
        EventDispatch.addHandler(.noBlocksRemaining, self.onNoBlocksRemaining)
    }
    
    
    private func scheduleRotation() {
        var dur = 2.5
        var angle = 0.261799 * 2 * self.rotateDirection
        
        if self.numRotations == 0 || arc4random() % 26 == 0 {
            dur = 1.0
            angle += Float.pi * 2 * self.rotateDirection
        }
        
        self.rotateDirection *= -1.0
        
        let rot = SKAction.rotate(byAngle: CGFloat(angle), duration: dur)
        rot.timingMode = .easeInEaseOut
        let call = SKAction.run({() in self.scheduleRotation()})
        let seq = SKAction.sequence([rot, call])
        self.run(seq)
        
        self.numRotations += 1
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
    
    private func onNoBlocksRemaining() {
        if self.isBusy {
            return;
        }
        
        self.isBusy = true
        let text = self.label?.text
        let fadeOut1 = SKAction.fadeOut(withDuration: 0.3)
        let change1 = SKAction.run { self.label?.text = ":D" }
        let fadeIn1 = SKAction.fadeIn(withDuration: 0.3)
        let wait = SKAction.wait(forDuration: 1.0)
        let fadeOut2 = SKAction.fadeOut(withDuration: 0.3)
        let change2 = SKAction.run { self.label?.text = text }
        let fadeIn2 = SKAction.fadeIn(withDuration: 0.3)
        let flag = SKAction.run { self.isBusy = false }
        
        let seq = [fadeOut1, change1, fadeIn1, wait, fadeOut2, change2, fadeIn2, flag]
        for a in seq { a.timingMode = .easeInEaseOut }
        self.run(SKAction.sequence(seq))
    }
    
}

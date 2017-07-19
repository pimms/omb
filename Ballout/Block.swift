//
//  Block.swift
//  Ballout
//
//  Created by Joakim Stien on 17/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class Block: Spawnable {
    private var hitCount: Int = 0
    private var initialHitCount: Int = 0
    private var label: SKLabelNode?
    private var warningLevel: WarningLevel
    
    override var spawnType: SpawnType { return .block }
    
    init(hitCount count: Int, size: CGSize) {
        self.hitCount = count
        self.initialHitCount = self.hitCount
        self.warningLevel = .None
        
        let displaySize = CGSize(width: size.width*0.85, height: size.height * 0.85)
        let rect = CGRect(x: -displaySize.width/2,
                          y: -displaySize.height/2,
                          width: displaySize.width,
                          height: displaySize.height)
        super.init(gridSize: displaySize, collideWithBall: true, shape: .Square)
        
        self.path = CGPath(rect: rect, transform: nil)
        self.strokeColor = UIColor.clear
        
        self.label = SKLabelNode(text: String(self.hitCount))
        self.label?.verticalAlignmentMode = .center
        self.label?.horizontalAlignmentMode = .center
        self.label?.fontName = "Helvetica Neue Thin"
        self.addChild(self.label!)
        
        self.updateColorTint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func onFulfillment(gameScore: GameScore!) {
        gameScore.destroyedBlocks += 1
        SFXController.shared?.play(sfx: .blockDestroyed)
        
        // Pop up a particle effect where we died
        let emitter = SKEmitterNode(fileNamed: "BlockBoom.sks")
        if emitter != nil {
            emitter!.position = self.position
            emitter!.particleColor = self.fillColor
            emitter!.particleColorRedRange = 0.2
            emitter!.particleColorBlueRange = 0.2
            emitter!.particleColorGreenRange = 0.2
            emitter!.particleColorSequence = nil
            self.parent?.addChild(emitter!)
        }
    }
    
    override func shouldBeRemoved() -> Bool {
        return self.hitCount <= 0
    }
    
    override func onBallCollided() {
        self.hitCount -= 1
        self.label?.text = String(self.hitCount)
        self.updateColorTint()
        
        if self.hitCount != 0 {
            SFXController.shared?.play(sfx: .blockHit)
        }
    }
    
    override func isDeadly() -> Bool {
        return true
    }
    
    override func showWarning(level: WarningLevel) {
        self.warningLevel = level
        let name = "warningLight"
        let maxScale = 1.0
        let maxAlpha = 0.8
        let minAlpha = 0.05
        
        var duration = 0.0
        var color = UIColor.clear
        
        // If we already have a warning running, remove it
        self.childNode(withName: name)?.removeFromParent()
        
        switch level {
        case .None:
            return
        case .Warning:
            color = UIColor.yellow
            duration = 1.0
            
        case .Error:
            color = UIColor.red
            duration = 0.5
        }
        
        // Create the node and launch the action
        let warningLight = SKShapeNode(rectOf: self.frame.size)
        warningLight.lineWidth = 5
        warningLight.strokeColor = color
        warningLight.fillColor = UIColor.clear
        warningLight.name = "warningLight"
        warningLight.position = CGPoint(x: 0, y: 0)
        warningLight.alpha = 0.5
        
        let scaleUp = SKAction.scale(to: CGFloat(maxScale), duration: duration)
        let fadeOut = SKAction.fadeAlpha(to: CGFloat(minAlpha), duration: duration)
        let group1 = SKAction.group([scaleUp, fadeOut])
            
        let scaleDown = SKAction.scale(to: 1.0, duration: duration)
        let fadeIn = SKAction.fadeAlpha(to: CGFloat(maxAlpha), duration: duration)
        let group2 = SKAction.group([scaleDown, fadeIn])
            
        let rep = SKAction.repeatForever(SKAction.sequence([group1, group2]))
        warningLight.run(rep)
        self.addChild(warningLight)
    }
    
    private func updateColorTint() {
        // The hue is projected from 170 degrees to 110 degrees with
        // a logarithmic falloff.
        
        let maxHue = 0.472
        let minHue = 0.305
        let range = (1.0 - maxHue) + minHue
        
        var hue = log(pow(Double(self.hitCount) + 1, 2.0))
        hue /= 10
        hue = 1.0 - hue
        
        // Limit within the acceptable boundaries
        if hue < 0.0 {
            hue = 0.0
        } else if hue > 1.0 {
            hue = 1.0
        }
        
        // Handle the wraparound (remember that we're *really* in the range [maxHue..1][0..minHue]
        hue *= range
        hue -= (1.0 - maxHue)
        while hue < 0.0 {
            hue += 1.0
        }
        
        self.fillColor = UIColor(hue: CGFloat(hue),
                                 saturation: 0.43,
                                 brightness: 0.66, alpha: 1.0)
    }

    override func serialize(coder: NSCoder) {
        coder.encode(self.hitCount, forKey: "hitCount")
        coder.encode(self.initialHitCount, forKey: "initialHitCount")
        coder.encode(self.warningLevel.rawValue, forKey: "warningLevel")
    }
    
    override func deserialize(coder: NSCoder) {
        self.hitCount = coder.decodeInteger(forKey: "hitCount")
        self.initialHitCount = coder.decodeInteger(forKey: "initialHitCount")
        self.warningLevel = WarningLevel(rawValue: coder.decodeInteger(forKey: "warningLevel"))!
        updateColorTint()
        showWarning(level: self.warningLevel)
        self.label?.text = String(self.hitCount)
    }
}


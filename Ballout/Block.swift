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
    
    init(hitCount count: Int, size: CGSize) {
        self.hitCount = count
        self.initialHitCount = self.hitCount
        
        let displaySize = CGSize(width: size.width*0.85, height: size.height * 0.85)
        let rect = CGRect(x: -displaySize.width/2,
                          y: -displaySize.height/2,
                          width: displaySize.width,
                          height: displaySize.height)
        super.init(gridSize: size, collideWithBall: true)
        
        self.path = CGPath(rect: rect, transform: nil)
        self.strokeColor = UIColor.clear
        
        self.label = SKLabelNode(text: String(self.hitCount))
        self.label?.verticalAlignmentMode = .center
        self.label?.horizontalAlignmentMode = .center
        self.label?.fontName = "Arial"
        self.addChild(self.label!)
        
        self.updateColorTint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func onFulfillment(gameScore: GameScore!) {
        gameScore.destroyedBlocks += 1
    }
    
    override func shouldBeRemoved() -> Bool {
        return self.hitCount <= 0
    }
    
    override func onBallCollided() {
        self.hitCount -= 1
        self.label?.text = String(self.hitCount)
        self.updateColorTint()
    }
    
    override func isDeadly() -> Bool {
        return true
    }
    
    private func updateColorTint() {
        let factor = CGFloat(self.hitCount) / CGFloat(self.initialHitCount)
        
        self.fillColor = UIColor(hue: (1 - factor) * 0.3,
                                 saturation: 0.43,
                                 brightness: 0.66, alpha: 1.0)
    }
}


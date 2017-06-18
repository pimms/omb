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
    private var label: SKLabelNode?
    
    init(hitCount count: Int, size: CGSize) {
        self.hitCount = count
        
        let rect = CGRect(x: -size.width/2,
                          y: -size.height/2,
                          width: size.width,
                          height: size.height)
        super.init(gridSize: size, collideWithBall: true)
        
        self.path = CGPath(rect: rect, transform: nil)
        self.strokeColor = UIColor.black
        self.fillColor   = UIColor.red
        self.lineWidth   = 3.0
        
        self.label = SKLabelNode(text: String(self.hitCount))
        self.label?.verticalAlignmentMode = .center
        self.label?.horizontalAlignmentMode = .center
        self.label?.fontName = "Arial"
        self.addChild(self.label!)
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
    }
}

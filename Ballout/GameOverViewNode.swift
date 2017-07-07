//
//  GameOverViewNode.swift
//  Ballout
//
//  Created by Joakim Stien on 07/07/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverViewNode: SKNode {
    public var retryButton: Button?
    private var scoreLabel: SKLabelNode?
    
    private var score: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    init(scene: SKScene) {
        super.init()
        
        let templ = scene.childNode(withName: "GameOverViewNode")!
        for child in templ.children {
            let copy = child.copy() as! SKNode
            self.addChild(copy)
        }
        
        findChildren()
    }
    
    public func setContinue(action: @escaping ()->Void) {
        self.retryButton?.clickCallback = action
    }
    
    public func setScore(score: Int) {
        self.score = score
    }
    
    private func findChildren() {
        let background = self.childNode(withName: "background")
        self.retryButton = (background!.childNode(withName: "retryButton") as! Button)
        self.scoreLabel = (background!.childNode(withName: "scoreLabel") as! SKLabelNode)
    }
}

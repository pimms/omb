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
        
        self.alpha = 0.0
        
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
    
    public func runPresentationAnimation() {
        let fadeDuration = 0.2
        self.run(SKAction.fadeIn(withDuration: fadeDuration))
        
        self.scoreLabel?.text = "0"
        
        var actions = [SKAction]()
        //actions.append(SKAction.wait(forDuration: fadeDuration))
        
        var scoreIncr = 1
        for i in stride(from: self.score, to: 0, by: -1) {
            let prev = log10(Double(i+1))
            let cur = log10(Double(i))
            let dt = (prev - cur) / 2
            
            let textAction = SKAction.run {
                self.scoreLabel?.text = String(scoreIncr)
                scoreIncr += 1
            }
            
            let waitAction = SKAction.wait(forDuration: dt)
            actions.append(textAction)
            actions.append(waitAction)
        }
        
        self.scoreLabel?.run(SKAction.sequence(actions))
    }
    
    private func findChildren() {
        let background = self.childNode(withName: "background")
        self.retryButton = (background!.childNode(withName: "retryButton") as! Button)
        self.scoreLabel = (background!.childNode(withName: "scoreLabel") as! SKLabelNode)
    }
}

//
//  GameOverState.swift
//  Ballout
//
//  Created by Joakim Stien on 18/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import GameplayKit

class GameOverState: GameState {
    private var gameOverView: SKNode?
    
    required init(scene s: BalloutScene) {
        super.init(scene: s)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == SpawnState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        print("GameOverState entered")
        
        self.gameOverView = self.gameScene.childNode(withName: "gameOverRootView")?.copy() as? SKNode
        self.gameOverView?.position = CGPoint(x: 0, y: 0)
        self.gameScene.addChild(self.gameOverView!)
        
        let l = self.gameOverView?.childNode(withName: "background")?.childNode(withName: "scoreLabel")
        let label = l as! SKLabelNode
        label.text = String(self.gameScene.gameScore!.destroyedBlocks)
        
        let b = self.gameOverView?.childNode(withName: "background")?.childNode(withName: "retryButton")
        let button = b as! Button
        button.clickCallback = { () in
            self.stateMachine!.enter(SpawnState.self)
        }
    }
    
    override func willExit(to nextState: GKState) {
        print("GameOverState exiting")
        self.gameOverView?.removeFromParent()
        self.gameScene.reset()
    }
}

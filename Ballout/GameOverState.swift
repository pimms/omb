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
        return stateClass == ShootoutState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        print("GameOverState entered")
        
        self.gameOverView = self.gameScene.childNode(withName: "gameOverRootView")?.copy() as? SKNode
        self.gameOverView?.position = CGPoint(x: 0, y: 0)
        self.gameScene.addChild(self.gameOverView!)
    }
    
    override func willExit(to nextState: GKState) {
        print("GameOverState exiting")
    }
}

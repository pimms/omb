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
    private var gameOverView: GameOverViewNode?
    
    required init(scene s: BalloutScene) {
        super.init(scene: s)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == SpawnState.self || stateClass == AdState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        //print("GameOverState entered")
        
        self.gameOverView = GameOverViewNode(scene: self.gameScene)
        self.gameOverView!.position = CGPoint(x: 0, y: 0)
        self.gameScene.addChild(self.gameOverView!)
        self.gameOverView!.setScore(score: self.gameScore.score)
        self.gameOverView!.runPresentationAnimation()
        
        self.gameScene.gameCenterController?.submitScore(score: self.gameScore!)
        
        self.gameOverView!.setContinue(action: { () in
            // TODO: Don't go here if (a) the user has purchased ad-free play,
            // and (b) I have implemented IAP.
            self.stateMachine!.enter(AdState.self)
        })
    }
    
    override func willExit(to nextState: GKState) {
        //print("GameOverState exiting")
        self.gameOverView?.removeFromParent()
        self.gameOverView = nil
        self.gameScene.reset()
        
        // Move the launch node back home
        let launchNode = self.gameScene.childNode(withName: "launchNode")
        launchNode?.position.x = 0
    }
}

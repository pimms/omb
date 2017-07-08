//
//  SpawnState.swift
//  Ballout
//
//  Created by Joakim Stien on 18/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import GameplayKit

class SpawnState: GameState {
    private var lastInitiatedTouch: CGPoint?
    
    required init(scene s: BalloutScene) {
        super.init(scene: s)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ShootoutState.self || stateClass == GameOverState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        print("SpawnState entering")
        
        let grid = self.gameScene!.gridController!
        
        if grid.canShiftWithoutDropping() {
            grid.update(hitCountGuideline: self.gameScore.numBalls) { () in
                self.gameScore.spawnedRows += 1
                self.gameScene.updateScoreLabel()
                
                self.stateMachine?.enter(ShootoutState.self)
            }
        } else {
            grid.update(hitCountGuideline: self.gameScore.numBalls) { () in
                self.stateMachine?.enter(GameOverState.self)
            }
        }
        
        // Initiate the ball-count label
        let launchNode = self.gameScene.childNode(withName: "launchNode")
        let countLabel = launchNode?.childNode(withName: "countLabel") as? SKLabelNode
        countLabel?.text = String(self.gameScore.numBalls)
    }
    
    override func willExit(to nextState: GKState) {
        print("SpawnState exiting")
        
        if nextState is ShootoutState && self.lastInitiatedTouch != nil {
            print("Forwarding touch to ShootoutState")
            (nextState as! ShootoutState).onTouchDown(atPos: self.lastInitiatedTouch!)
        }
    }
    
    override func onTouchDown(atPos point: CGPoint) {
        self.lastInitiatedTouch = point
    }
    
    override func onTouchUp(atPos point: CGPoint) {
        self.lastInitiatedTouch = nil
    }
}

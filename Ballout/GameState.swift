//
//  BalloutState.swift
//  Ballout
//
//  Created by Joakim Stien on 17/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class GameState: GKState {
    var gameScene: BalloutScene!
    var gameScore: GameScore!
    
    required init(scene s: BalloutScene) {
        self.gameScene = s
        self.gameScore = self.gameScene!.gameScore!
        super.init()
    }
    
    func onTouchDown(atPos point: CGPoint) {
        // No default behaviour
    }
    
    func onTouchMoved(atPos point: CGPoint) {
        // No default behaviour
    }
    
    func onTouchUp(atPos point: CGPoint) {
        // No default behaviour
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        print("GameState subclass failed to override 'isValidNextState'")
        return false
    }
}

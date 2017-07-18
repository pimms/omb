//
//  BestScoreController.swift
//  Ballout
//
//  Created by Joakim Stien on 18/07/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation

class BestScoreController: NSObject {
    private let SCORE_KEY: String = "__highScoreKey"
    
    private var gameCenter: GameCenterController
    private var highScore: Int64
    
    init(gameCenterController: GameCenterController) {
        self.gameCenter = gameCenterController
        
        self.highScore = Int64(UserDefaults.standard.integer(forKey: SCORE_KEY))
        if self.highScore <= 0 {
            self.highScore = 0
        }
        
        print("Loaded highscore \(self.highScore) from user defaults")
        
        super.init()
        
        self.refreshGameCenterScore()
    }
    
    public func submitScore(_ score: Int64) {
        if score > self.highScore {
            print("Writing score \(score) to user defaults")
            UserDefaults.standard.set(Int(score), forKey: SCORE_KEY)
        }
    }
    
    public func getHighScore() -> Int64 {
        return self.highScore
    }
    
    public func refreshGameCenterScore() {
        // If the score is not higher than what we have, the submittal of it
        // will have no effect. So just submit it :)
        self.gameCenter.getHighScore { (lbScore) in
            print("BestScoreController.refreshGameCenterScore(): Received '\(lbScore)'")
            self.submitScore(lbScore)
        }
    }
}

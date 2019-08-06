//
//  GameCenterController.swift
//  Ballout
//
//  Created by Joakim Stien on 08/07/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import GameKit

class GameCenterController: NSObject, GKGameCenterControllerDelegate {
    private var gcEnabled: Bool = false
    private var gcDefaultLeaderboard: String?
    private let scoreBoardID: String = "com.jstien.Ballout.ldb"
    private let destroyedBoardID: String = "com.jstien.Ballout.ldb.destroyed"
    
    private var viewController: UIViewController?
    
    init(activeViewController: UIViewController?) {
        self.viewController = activeViewController
        super.init()
    }
    
    public func authenticatePlayer() {
        let localPlayer: GKLocalPlayer = .local
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.viewController?.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        self.gcDefaultLeaderboard = leaderboardIdentifer!
                    }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
    }
    
    public func presentLeaderboard() {
        let gkViewController = GKGameCenterViewController()
        gkViewController.gameCenterDelegate = self
        gkViewController.viewState = .leaderboards
        gkViewController.leaderboardIdentifier = self.scoreBoardID
        self.viewController?.present(gkViewController, animated: true, completion: nil)
    }
   
    public func submitScore(score: GameScore) {
        let gkScore = GKScore(leaderboardIdentifier: self.scoreBoardID)
        gkScore.value = Int64(score.score)
        
        let gkDestroyed = GKScore(leaderboardIdentifier: self.destroyedBoardID)
        gkDestroyed.value = Int64(score.destroyedBlocks)
        
        GKScore.report([gkScore, gkDestroyed], withCompletionHandler: {(error) in
            if error != nil {
                print("FAILED TO SUBMIT SCORE: \(error!)")
            } else {
                print("Score submitted :)))")
            }
        })
    }
    
    public func getHighScore(callback: @escaping (_: Int64) -> Void) {
        let leaderboard = GKLeaderboard()
        leaderboard.identifier = scoreBoardID
        leaderboard.loadScores { (scores, error) in
            if error == nil && scores != nil {
                if leaderboard.localPlayerScore != nil {
                    callback(leaderboard.localPlayerScore!.value)
                }
            }
        }
    }
    
    
    @available(iOS 6.0, *)
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

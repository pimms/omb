//
//  ShootoutState.swift
//  Ballout
//
//  Created by Joakim Stien on 17/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import GameplayKit

class ShootoutState: GameState {
    private var isAiming: Bool = false
    private var shootOnRelease: Bool = false
    private var shootAngle: CGFloat = 0.0
    private var aimTrajectory: AimTrajectory?
    private var launchNode: SKNode?
    
    
    required init(scene s: BalloutScene) {
        super.init(scene: s)
        
        self.aimTrajectory = AimTrajectory()
        self.aimTrajectory?.isHidden = true;
        self.launchNode = self.gameScene?.childNode(withName: "launchNode")
        self.launchNode?.addChild(self.aimTrajectory!)
    }
    
    override func didEnter(from previousState: GKState?) {
        print("ShootoutState entered")
        self.isAiming = false
        self.shootOnRelease = false
        
        // TODO: Use the actual score instead of the number of balls, although
        // these numbers should be pretty much identical for the most part.
        let grid = self.gameScene!.gridController!
        
        if grid.canShiftWithoutDropping() {
            grid.update(hitCountGuideline: self.gameScore.numBalls)
        } else {
            // Transition to the game-over screen, the user is being a moron
            self.stateMachine?.enter(GameOverState.self)
        }
    }
    
    override func willExit(to nextState: GKState) {
        print("ShootoutState exiting")
        
        
        if let destroyState: DestroyState = nextState as? DestroyState {
            destroyState.setAngle(angle: self.shootAngle)
        }
        
        self.isAiming = false
        self.shootOnRelease = false
    }
    
    override func onTouchDown(atPos point: CGPoint) {
        self.isAiming = true
        self.aimTrajectory?.isHidden = false;
        self.updateTrajectory(touchPoint: point)
    }
    
    override func onTouchMoved(atPos point: CGPoint) {
        self.updateTrajectory(touchPoint: point)
    }
    
    override func onTouchUp(atPos point: CGPoint) {
        self.isAiming = false
        self.aimTrajectory?.isHidden = true
        
        if self.shootOnRelease {
            self.stateMachine?.enter(DestroyState.self)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == DestroyState.self || stateClass == GameOverState.self
    }
    

    private func updateTrajectory(touchPoint pos: CGPoint!) {
        let launchPoint: CGPoint! = self.launchNode?.position
        let delta = CGVector(dx: launchPoint.x-pos.x, dy: launchPoint.y-pos.y)
        let angle: CGFloat = atan2(delta.dy, delta.dx)
        self.shootAngle = angle
        
        //self.aimTrajectory?.position = launchPoint
        self.aimTrajectory?.setAimAngle(aimAngle: angle)
        
        self.shootOnRelease = (delta.dy >= 0)
        self.aimTrajectory?.isHidden = !self.shootOnRelease
    }
}

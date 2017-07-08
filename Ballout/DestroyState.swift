//
//  DestroyState.swift
//  Ballout
//
//  Created by Joakim Stien on 17/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import GameplayKit

class DestroyState: GameState {
    private var launchNode: SKNode?

    private var angleDefined: Bool = false
    private var angle: CGFloat = 0.0
    private var launchPoint: CGPoint = CGPoint(x:0, y:0)
    private var homePoint: CGPoint?
    private var homeBall: Ball?
    private var countLabel: SKLabelNode?
    
    private var nextShot: TimeInterval = 0
    private var elapsedTime: TimeInterval = 0
    private var shotBalls: Int = 0
    private var ballsToShoot: Int = 0
    private var ballsAtHome: Int = 0
    private var balls: NSMutableArray?
    
    required init(scene s: BalloutScene) {
        super.init(scene: s)
        self.launchNode = self.gameScene.childNode(withName: "launchNode")
        self.countLabel = self.launchNode?.childNode(withName: "countLabel") as? SKLabelNode
    }
    
    override func didEnter(from previousState: GKState?) {
        //print("DestroyState entered")
        assert(self.angleDefined)
        
        self.launchPoint = self.launchNode!.position
        self.homePoint = nil
        self.balls = NSMutableArray()
        self.shotBalls = 0
        self.ballsAtHome = 0
        self.ballsToShoot = self.gameScore.numBalls
    }
    
    override func willExit(to nextState: GKState) {
        //print("DestroyState exiting")
        self.angleDefined = false
        self.balls = nil
        
        self.homeBall?.removeFromParent()
        self.homeBall = nil
        self.launchNode!.position = self.homePoint!
        self.addLaunchIndicator()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ShootoutState.self || stateClass == SpawnState.self
    }
    
    
    public func setAngle(angle: CGFloat) {
        self.angleDefined = true
        self.angle = angle
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        self.elapsedTime += seconds
        
        // If we've got balls to shoot, and enough time has elapsed for us to
        // do so, shoot a ball.
        if self.shotBalls < self.ballsToShoot && self.elapsedTime >= self.nextShot {
            shootBall()
            self.nextShot = self.elapsedTime + 0.08
            self.shotBalls += 1
            
            // Update the label indicating the number of balls remaining
            let left = self.ballsToShoot - self.shotBalls
            if left == 0 {
                self.countLabel?.text = ""
            } else {
                self.countLabel?.text = String(left)
            }
        }
        
        // If we've shot all the balls we should, remove the launch indicator
        if self.shotBalls == self.ballsToShoot {
            self.removeLaunchIndicator()
        }
        
        // Check if any of the balls have bounces below the threshold, and if so
        // move them back to the launch position. Once all balls are moved back,
        // transition to the next appropriate state.
        var toRemove: [Any] = [Any]()
        for o in self.balls! {
            let b: Ball! = (o as! Ball)
            if (b.position.y <= self.launchPoint.y - 5.0) {
                self.moveBallHome(ball: b)
                toRemove.append(o)
            }
        }
        
        for o in toRemove {
            self.balls?.remove(o)
        }
    }
    
    private func shootBall() {
        let ball = Ball(createPhysics: true)
        ball.position.x = self.launchPoint.x
        ball.position.y = self.launchPoint.y
        
        let impulse = CGVector(dx: cos(self.angle) * 1500, dy: sin(self.angle) * 1500)
        
        self.gameScene?.addChild(ball)
        self.balls!.add(ball)
        
        ball.physicsBody!.applyImpulse(impulse)
        ball.physicsBody!.affectedByGravity = true
    }
    
    private func moveBallHome(ball: Ball) {
        if self.homePoint == nil {
            // Find the intersection point between the balls trajectory and the
            // line at which the launchNode lies
            var newPos = ball.position
            newPos.y = self.launchNode!.position.y
            
            // As the ball will almost certainly "tunnel" through the line, we
            // need to project the actual point back to where it intersected.
            var vel = ball.physicsBody!.velocity
            let len = sqrt(vel.dx*vel.dx + vel.dy*vel.dy)
            vel.dx = -(vel.dx/len)
            vel.dy = -(vel.dy/len)
            
            if vel.dx != 0 && vel.dy != 0 {
                let ratio = vel.dx / vel.dy
                let ydiff = self.launchNode!.position.y - ball.position.y
                newPos = CGPoint(x: ball.position.x + ydiff * ratio,
                                 y: self.launchNode!.position.y)
            }
            
            // Ensure that the new position is within the screen boundaries
            let half = self.gameScene.frame.width / 2
            let rad = (ball.frame.width / 2) + 1
            
            let minPos = -half + rad
            let maxPos = half - rad
            
            if newPos.x < minPos {
                newPos.x = minPos
            } else if newPos.x > maxPos {
                newPos.x = maxPos
            }
            
            self.homePoint = newPos
            self.homeBall = Ball(createPhysics: false)
            self.homeBall?.position = self.homePoint!
            self.gameScene.addChild(self.homeBall!)
        }
        
        let duration: CGFloat = 0.1

        let dest = CGPoint(x: ball.position.x + (ball.physicsBody?.velocity.dx)! * duration,
                           y: ball.position.y + (ball.physicsBody?.velocity.dy)! * duration)
        ball.physicsBody = nil
        
        let moveAndFade = SKAction.group([SKAction.move(to: dest, duration: TimeInterval(duration)),
                                          SKAction.fadeOut(withDuration: TimeInterval(duration))])
 
        ball.run(SKAction.sequence([moveAndFade,
                                    SKAction.removeFromParent(),
                                    SKAction.perform(#selector(DestroyState.onBallMovedHome), onTarget: self)]))
    }
    
    @objc private func onBallMovedHome() {
        self.ballsAtHome += 1
        if (self.ballsAtHome == self.ballsToShoot) {
            self.stateMachine?.enter(SpawnState.self)
        }
    }


    private func removeLaunchIndicator() {
        self.launchNode?.childNode(withName: "launchIndicator")?.isHidden = true
    }
    
    private func addLaunchIndicator() {
        self.launchNode?.childNode(withName: "launchIndicator")?.isHidden = false
    }
}

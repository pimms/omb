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
    private var angleDefined: Bool = false
    private var angle: CGFloat = 0.0
    private var launchPoint: CGPoint = CGPoint(x:0, y:0)
    private var homePoint: CGPoint?
    
    private var nextShot: TimeInterval = 0
    private var elapsedTime: TimeInterval = 0
    private var shotBalls: Int = 0
    private var ballsToShoot: Int = 0
    private var ballsAtHome: Int = 0
    private var balls: NSMutableArray?
    
    required init(scene s: BalloutScene) {
        super.init(scene: s)
    }
    
    override func didEnter(from previousState: GKState?) {
        print("DestroyState entered")
        assert(self.angleDefined)
        
        self.launchPoint = (self.gameScene.childNode(withName: "launchNode")?.position)!
        self.homePoint = nil
        self.balls = NSMutableArray()
        self.shotBalls = 0
        self.ballsAtHome = 0
        self.ballsToShoot = self.gameScore.numBalls
    }
    
    override func willExit(to nextState: GKState) {
        print("DestroyState exiting")
        self.angleDefined = false
        self.balls = nil
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
            self.nextShot = self.elapsedTime + 0.2
            self.shotBalls += 1
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
        
        let impulse = CGVector(dx: cos(self.angle) * 2000, dy: sin(self.angle) * 2000)
        
        self.gameScene?.addChild(ball)
        self.balls!.add(ball)
        
        ball.physicsBody!.applyImpulse(impulse)
        ball.physicsBody!.affectedByGravity = true
    }
    
    private func moveBallHome(ball: Ball) {
        if self.homePoint == nil {
            self.homePoint = ball.position
            let launchNode: SKNode! = self.gameScene.childNode(withName: "launchNode")!
            self.homePoint!.y = launchNode.position.y
            launchNode.position = self.homePoint!
        }

        // TODO: Make something sexy with splines. I believe that we can create
        // a sexy curved movement if we create a spline originating from the ball's
        // current position along it's current velocity vector, and the next point
        // at the (launchPoint + velocityDelta).
        let duration: CGFloat = 0.3

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
}

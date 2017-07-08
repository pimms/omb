//
//  BalloutScene.swift
//  Ballout
//
//  Created by Joakim Stien on 17/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class BalloutScene: SKScene, SKPhysicsContactDelegate {
    private var isInitialized: Bool = false
    private var stateMachine: GKStateMachine?
    private var scoreLabel: SKLabelNode?
    private var speedButton: Button?
    private var touchHandler: TouchHandler?
    private var lastUpdateTime: TimeInterval = 0
    
    public var entities = [GKEntity]()
    public var graphs = [String : GKGraph]()

    public var gridController: GridController? = nil
    public var gameScore: GameScore?
    public var gameCenterController: GameCenterController?
    
    
    public func reset() {
        self.gameScore?.reset()
        self.gridController?.despawnAll()
    }
    
    private func initialize() {
        if (self.isInitialized) {
            return
        }
        
        let playfield = self.childNode(withName: "playfield")!
        let playRect = playfield.frame
        
        self.speedButton = self.childNode(withName: "speedButton") as? Button
        self.speedButton?.gameScene = self;
        
        // 1. Initialize myself
        let physBounds = CGRect(x: self.frame.minX,
                                y: self.frame.minY,
                                width: self.frame.width,
                                height: self.frame.height - (self.frame.maxY - playRect.maxY))
        self.gameScore = GameScore()
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: physBounds)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.friction = 0.0
        self.physicsWorld.contactDelegate = self
        self.scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        self.updateScoreLabel()
        
        // 2. Initialize the GridController
        self.gridController = GridController(withScene: self, bounds: playRect, width: 8, height: 11)
        
        // 3. Add a launch indiator node to the launchNode
        let launchIndicator = Ball(createPhysics: false)
        launchIndicator.name = "launchIndicator"
        self.childNode(withName: "launchNode")?.addChild(launchIndicator)
        
        // 4. Initialize the state machine and kick it off
        var states = [GKState]()
        states.append(ShootoutState(scene: self))
        states.append(DestroyState(scene: self))
        states.append(GameOverState(scene: self))
        states.append(SpawnState(scene: self))
        self.stateMachine = GKStateMachine(states: states)
        self.stateMachine!.enter(SpawnState.self)
        
        // 5. Initialize the Touch Handler
        self.touchHandler = TouchHandler(scene: self, stateMachine: self.stateMachine!)
        
        self.isInitialized = true
    }
    
    override func sceneDidLoad() {
        print("BalloutScene loaded")
        initialize()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchHandler?.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchHandler?.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchHandler?.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchHandler?.touchesCancelled(touches, with: event)
    }

    
    public func bindViewController(viewController: UIViewController) {
        self.gameCenterController = GameCenterController(activeViewController: viewController)
        self.gameCenterController?.authenticatePlayer()
        
        let b = childNode(withName: "leaderboardButton") as! Button
        b.clickCallback = { () in
            self.gameCenterController?.presentLeaderboard()
        }
    }

    
    func didBegin(_ contact: SKPhysicsContact) {
        let a = contact.bodyA
        let b = contact.bodyB
        
        var blockBody: SKPhysicsBody?
        if a.node as? Spawnable != nil && b.categoryBitMask == PhysicsFlags.ballBit {
            blockBody = a
        } else if b.node as? Spawnable != nil && a.categoryBitMask == PhysicsFlags.ballBit {
            blockBody = b
        } else {
            return
        }
        
        if blockBody?.node != nil {
            if let spawnable: Spawnable = (blockBody?.node as! Spawnable?)  {
                spawnable.onBallCollided()
                if spawnable.shouldBeRemoved() {
                    spawnable.onFulfillment(gameScore: self.gameScore)
                    self.gridController?.onSpawnableDestroyed(spawnable: spawnable)
                    spawnable.removeFromParent()
                    self.updateScoreLabel()
                }
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        // nop
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }

        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        self.stateMachine?.currentState?.update(deltaTime: dt)
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        updateNode(deltaTime: dt, node: self)
        
        self.lastUpdateTime = currentTime
    }
    
    private func updateNode(deltaTime: TimeInterval, node: SKNode!) {
        if let updatable = node as? Updatable {
            updatable.update(deltaTime: deltaTime)
        }

        for n in node.children {
            updateNode(deltaTime: deltaTime, node: n)
        }
    }

    
    private func updateScoreLabel() {
        self.scoreLabel?.text = String(describing: self.gameScore!.score)
    }
}

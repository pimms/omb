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
    
    public var entities = [GKEntity]()
    public var graphs = [String : GKGraph]()
    
    private var lastUpdateTime: TimeInterval = 0
    public var gridController: GridController? = nil
    
    public var gameScore: GameScore?
    
    
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
        self.gridController = GridController(withScene: self, bounds: playRect, width: 7, height: 8)
        
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
        
        self.isInitialized = true
    }
    
    override func sceneDidLoad() {
        print("BalloutScene loaded")
        initialize()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let loc = t.location(in: self)
            let nodes = self.nodes(at: loc)
            var handled = false
            
            for n in nodes {
                if let button = n as? Button {
                    handled = true
                    button.onClick()
                    break
                }
            }
            
            if !handled {
                (stateMachine?.currentState as! GameState).onTouchDown(atPos: t.location(in: self))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            (stateMachine?.currentState as! GameState).onTouchMoved(atPos: t.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            (stateMachine?.currentState as! GameState).onTouchUp(atPos: t.location(in: self))
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            (stateMachine?.currentState as! GameState).onTouchUp(atPos: t.location(in: self))
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
        self.scoreLabel?.text = String(describing: self.gameScore!.destroyedBlocks)
    }
}

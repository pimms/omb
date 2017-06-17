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

class BalloutScene: SKScene {
    private var stateMachine: GKStateMachine?
    
    public var entities = [GKEntity]()
    public var graphs = [String : GKGraph]()
    private var lastUpdateTime: TimeInterval = 0
    
    // TODO? Encapsulate the game "scores" into a separate object
    public var numBalls: Int = 0
    
    
    func initialize() {
        // 1. Initialize myself
        self.numBalls = 2
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.friction = 0.0
        
        // 2. Initialize the state machine and kick it off
        var states = [GKState]()
        states.append(ShootoutState(scene: self))
        states.append(DestroyState(scene: self))
        stateMachine = GKStateMachine(states: states)
        stateMachine!.enter(ShootoutState.self)
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        initialize()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            (stateMachine?.currentState as! GameState).onTouchDown(atPos: t.location(in: self))
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
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
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
        
        self.lastUpdateTime = currentTime
    }
}

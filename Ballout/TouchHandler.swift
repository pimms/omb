//
//  TouchHandler.swift
//  Ballout
//
//  Created by Joakim Stien on 07/07/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class TouchHandler: NSObject {
    private var scene: SKScene
    private var stateMachine: GKStateMachine
    
    private var stateTouch: Int
    private var buttonTouches: Dictionary<Int,Button>
    
    
    init(scene: SKScene, stateMachine: GKStateMachine) {
        self.scene = scene
        self.stateMachine = stateMachine
        self.stateTouch = 0
        self.buttonTouches = Dictionary<Int,Button>()
        
        super.init()
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let loc = t.location(in: self.scene)
            let state = self.stateMachine.currentState as! GameState
            
            var hitButton = false
            if self.stateTouch != t.hash {
                let nodes = self.scene.nodes(at: loc)
                for n in nodes {
                    if n is Button {
                        self.buttonTouches[t.hash] = (n as! Button)
                        self.buttonTouches[t.hash]?.onTouchBegan()
                        hitButton = true
                        break
                    }
                }
            }
            
            // The GameState only receives touches that hit no buttons
            if !hitButton && self.stateTouch == 0 {
                self.stateTouch = t.hash
                state.onTouchDown(atPos: loc)
            }
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let loc = t.location(in: self.scene)
            let state = self.stateMachine.currentState as! GameState
            
            if self.stateTouch == t.hash {
                state.onTouchMoved(atPos: loc)
            }
            
            // The touch may have ended, but that does not mean the button
            // won't be properly clicked. The touch may re-enter the button.
            let button = self.buttonTouches[t.hash]
            if button != nil && !button!.contains(loc) {
                button?.onTouchEnded()
            }
        }
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let loc = t.location(in: self.scene)
            let state = self.stateMachine.currentState as! GameState
            
            if self.stateTouch == t.hash {
                state.onTouchUp(atPos: loc)
                self.stateTouch = 0
            }
            
            let button = self.buttonTouches[t.hash]
            if button != nil {
                button?.onTouchEnded()
                if button!.contains(loc) {
                    button?.onClick()
                }
            }
            self.buttonTouches.removeValue(forKey: t.hash)
        }
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let loc = t.location(in: self.scene)
            let state = self.stateMachine.currentState as! GameState
            
            if self.stateTouch == t.hash {
                state.onTouchUp(atPos: loc)
                self.stateTouch = 0
            }
            
            let button = self.buttonTouches[t.hash]
            if button != nil {
                button?.onTouchEnded()
            }
            self.buttonTouches.removeValue(forKey: t.hash)
        }
    }
}

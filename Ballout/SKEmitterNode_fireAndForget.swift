//
//  SKEmitterNode_fireAndForget.swift
//  Ballout
//
//  Created by Joakim Stien on 19/07/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import SpriteKit

extension SKEmitterNode {
    static func fireAndForget(name: String, position: CGPoint, parent: SKNode?) -> SKEmitterNode? {
        let emitter = SKEmitterNode(fileNamed: name)
        if emitter != nil {
            let dur = TimeInterval(emitter!.particleLifetime + emitter!.particleLifetimeRange)
            emitter!.run(SKAction.sequence([SKAction.wait(forDuration: dur),
                                           SKAction.removeFromParent()]))
            emitter?.position = position
            parent?.addChild(emitter!)
        }
        return emitter
    }
}

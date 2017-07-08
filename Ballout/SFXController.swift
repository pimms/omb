//
//  SFXController.swift
//  Ballout
//
//  Created by Joakim Stien on 08/07/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import SpriteKit

enum SFXID {
    case blockHit
    case blockDestroyed
    case extraBallHit
}

class SFX {
    private var filename: String
    private var player: SKAction?
    private var lastPlayed: Int64 = 0
    
    init(filename: String) {
        self.filename = filename
        self.player = SKAction.playSoundFileNamed(self.filename, waitForCompletion: false)
    }
    
    public func play(onNode node: SKNode?) {
        let now = currentTimeMillis()
        if now - lastPlayed > Int64(60) {
            node?.run(self.player!)
            self.lastPlayed = now
        }
    }
    
    private func currentTimeMillis() -> Int64 {
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
}

class SFXController: NSObject {
    public static var shared: SFXController?

    private var sounds = Dictionary<SFXID,SFX>()
    private var node: SKNode?
    
    init(playNode: SKNode?) {
        super.init()
        
        self.node = playNode
        sounds[.blockHit] = SFX(filename: "pop1.wav")
        sounds[.blockDestroyed] = SFX(filename: "pop1.wav")
        sounds[.extraBallHit] = SFX(filename: "pop2.wav")
    }
    
    public func play(sfx: SFXID) {
        sounds[sfx]?.play(onNode: self.node)
    }
}

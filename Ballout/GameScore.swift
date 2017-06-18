//
//  GameScore.swift
//  Ballout
//
//  Created by Joakim Stien on 18/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation

class GameScore: NSObject {
    public var destroyedBlocks: Int = 0
    public var numBalls: Int = 0
    
    override init() {
        super.init()
        self.reset()
    }
    
    public func reset() {
        self.destroyedBlocks = 0
        self.numBalls = 1
    }
}

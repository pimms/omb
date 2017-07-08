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
    public var spawnedRows: Int = 0
    
    public var score: Int { return max(self.spawnedRows - 1, 0) }
    
    override init() {
        super.init()
        self.reset()
    }
    
    public func reset() {
        self.destroyedBlocks = 0
        self.numBalls = 1
        self.spawnedRows = 0
    }
}

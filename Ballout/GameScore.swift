//
//  GameScore.swift
//  Ballout
//
//  Created by Joakim Stien on 18/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation

class GameScore: NSObject, Serializable {
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
    
    func serialize(coder: NSCoder) {
        coder.encode(self.destroyedBlocks, forKey: "destroyedBlocks")
        coder.encode(self.numBalls, forKey: "numBalls")
        coder.encode(self.spawnedRows, forKey: "spawnedRows")
    }
    
    func deserialize(coder: NSCoder) {
        self.destroyedBlocks = coder.decodeInteger(forKey: "destroyedBlocks")
        self.numBalls = coder.decodeInteger(forKey: "numBalls")
        self.spawnedRows = coder.decodeInteger(forKey: "spawnedRows")
    }
}

 //
//  BlockGrid.swift
//  Ballout
//
//  Created by Joakim Stien on 17/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit

class GridController: NSObject {
    private var gridWidth: Int = 0
    private var gridHeight: Int = 0
    private var scene: SKScene!
    private var bounds: CGRect
    private var blockSize: CGSize
    
    private var blocks: [[Spawnable?]?]
    
    
    init(withScene scene: SKScene!, bounds: CGRect, width: Int, height: Int) {
        self.scene = scene
        self.gridWidth = width
        self.gridHeight = height
        self.bounds = bounds
        self.blocks = Array(repeating: Array(repeating: nil, count: height), count: width)
        
        self.blockSize = CGSize()
        self.blockSize.width = bounds.width / CGFloat(width)
        self.blockSize.height = self.blockSize.width
        while (self.blockSize.height * CGFloat(self.gridHeight) > bounds.height) {
            self.gridHeight -= 1
        }
        if (self.gridHeight != height) {
            print("Could not initialize with grid height \(height), limited to \(self.gridHeight)")
        }
        
        super.init()
    }
    
    public func update(hitCountGuideline count: Int) {
        shiftBlocksDown()

        var numToSpawn = Int(arc4random()) % self.gridWidth / 2 + 2
        if (numToSpawn > self.gridWidth) {
            numToSpawn = self.gridWidth
        }

        let indices = NSMutableArray()
        for i in 0...self.gridWidth-1 {
            indices.add(i)
        }

        var shuffled = indices.shuffled()
        
        for i in 0...numToSpawn-1 {
            // Give blocks a 25% chance to have twice the guidance-count
            var hitCount: Int = count
            if arc4random() % 4 == 0 {
                hitCount *= 2
            }
            
            let xCoord = shuffled.first as! Int
            shuffled.remove(at: 0)
            
            
            var spawnable: Spawnable
            if (i == 0) {
                spawnable = ExtraBall(size: self.blockSize)
            } else {
                spawnable = Block(hitCount: hitCount, size: self.blockSize)
            }
            
            spawn(spawnable: spawnable, x: xCoord, hitCount: hitCount)
        }
    }
    
    public func onSpawnableDestroyed(spawnable: Spawnable) {
        for x in 0...self.gridWidth-1 {
            for y in 0...self.gridHeight-1 {
                if self.blocks[x]![y] == spawnable {
                    self.blocks[x]![y] = nil
                }
            }
        }
    }
    
    private func shiftBlocksDown() {
        for y in stride(from: self.gridHeight-1, to: 0, by: -1) {
            for x in 0...self.gridWidth-1 {
                self.blocks[x]![y] = self.blocks[x]![y-1]
                self.blocks[x]![y-1] = nil
                self.blocks[x]![y]?.position = getCenterForCoord(x: x, y: y)
            }
        }
    }

    private func spawn(spawnable: Spawnable, x: Int, hitCount: Int) {
        if (x < 0 || x >= self.gridWidth) {
            fatalError("Index out of bounds")
        }

        let y = 0
        if (self.blocks[x]![y] != nil) {
            fatalError("Element already exists at coordinate")
        }

        spawnable.position = getCenterForCoord(x: x, y: y)
        self.blocks[x]![y] = spawnable
        self.scene.addChild(spawnable)
    }

    private func getCenterForCoord(x: Int, y: Int) -> CGPoint {
        if (x < 0 || x >= self.gridWidth || y < 0 || y >= self.gridHeight) {
            fatalError("Index out of bounds")
        }
        
        let ret = CGPoint(x: (CGFloat(x) + 0.5) * blockSize.width + self.bounds.minX,
                          y: self.bounds.maxY - (CGFloat(y) + 0.5) * blockSize.height)
        return ret
    }

}
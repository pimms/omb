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


class GridController: NSObject, Serializable {
    private var scene: SKScene!
    private static let animationDuration: TimeInterval = 0.4
    private var gridWidth: Int = 0
    private var gridHeight: Int = 0
    private var bounds: CGRect
    private var blockSize: CGSize
    private var animationsRunning: Bool = false
    
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
    
    
    func serialize(coder: NSCoder) {
        // Only the Spawnables themselves are being coded. We assume the properties
        // of the grid as a whole to remain unchanged. The only case in which this
        // assumption fails, is if the user has had an active session in the background,
        // and the app was updated to use a different grid-dimension. Soo... Let's not change
        // the grid-dimensions, ever :)
        var array = [Dictionary<String, Any>]()
        
        for y in 0...self.gridHeight-1 {
            for x in 0...self.gridWidth-1 {
                if self.blocks[x]![y] == nil {
                    continue
                }
                
                let subArch = NSKeyedArchiver()
                self.blocks[x]![y]!.serialize(coder: subArch)
                subArch.finishEncoding()
                let data = subArch.encodedData
                
                var dict = Dictionary<String, Any>()
                dict["data"] = data
                dict["x"] = x
                dict["y"] = y
                dict["type"] = self.blocks[x]![y]!.spawnType.rawValue
                array.append(dict)
            }
        }
        
        coder.encode(array, forKey: "spawnables")
    }
    
    func deserialize(coder: NSCoder) {
        let array = coder.decodeObject(forKey: "spawnables") as! Array<Dictionary<String, Any>>
        
        for dict in array {
            let x: Int = dict["x"] as! Int
            let y: Int = dict["y"] as! Int
            let data: Data = dict["data"] as! Data
            let type: SpawnType = SpawnType(rawValue: dict["type"] as! Int)!
            
            var spawnable: Spawnable?
            switch type {
            case .extraBall:
                spawnable = ExtraBall(size: self.blockSize)
                break
            case .block:
                // We must provide a mock hit-count, but this will be overriden in a bit
                spawnable = Block(hitCount: 1, size: self.blockSize)
                break
            default:
                fatalError("Spawnable type \(type) not handled")
            }
            
            let unarch = NSKeyedUnarchiver(forReadingWith: data)
            spawnable?.deserialize(coder: unarch)
            spawn(spawnable: spawnable!, x: x, y: y, animated: false)
        }
    }
    
    
    public func despawnAll() {
        for y in 0...self.gridHeight-1 {
            for x in 0...self.gridWidth-1 {
                self.blocks[x]![y]?.removeFromParent()
                self.blocks[x]![y] = nil
            }
        }
    }

    public func canShiftWithoutDropping() -> Bool {
        let y = self.gridHeight - 2
        for x in 0...self.gridWidth-1 {
            if self.blocks[x]![y] != nil && self.blocks[x]![y]!.isDeadly() {
                return false
            }
        }
        
        return true
    }
    
    public func update(hitCountGuideline count: Int, completion: @escaping ()->Void) {
        update(hitCountGuideline: count)
        
        let durMs = Int(GridController.animationDuration * 1000.0)
        let deadline = DispatchTime.now() + .milliseconds(durMs)
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: completion)
    }
    
    public func update(hitCountGuideline count: Int) {
        despawnNonFatals()
        shiftBlocksDown()

        let minSpawn = 3
        var numToSpawn = Int(arc4random()) % self.gridWidth
        if numToSpawn < minSpawn {
            numToSpawn = minSpawn
        }

        let indices = NSMutableArray()
        for i in 0...self.gridWidth-1 {
            indices.add(i)
        }

        var shuffled = indices.shuffled()
        
        for i in 0...numToSpawn-1 {
            // Give blocks a 25% chance to have twice the guidance-count. The guidance-count is
            // as named just guide, so if it holds a zero or negative value, force it to 1.
            var hitCount: Int = max(count, 1)
            if count > 4 {
                // Add some extra noise
                let range = count / 4
                let ran = arc4random() % UInt32(range)
                hitCount += Int(ran) - range / 2
            }
            
            // Blocks has a 25% chance to have twice the hit-count
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
            
            spawn(spawnable: spawnable, x: xCoord, y: 1, animated: true)
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
                self.blocks[x]![y]?.run(SKAction.move(to: getCenterForCoord(x: x, y: y),
                                                      duration: GridController.animationDuration))
                
                if y == self.gridHeight-2 {
                    self.blocks[x]![y]?.showWarning(level: .Error)
                } else if (y == self.gridHeight - 3) {
                    self.blocks[x]![y]?.showWarning(level: .Warning)
                }
            }
        }
    }
    
    private func despawnNonFatals() {
        let y = self.gridHeight - 2
        for x in 0...self.gridWidth-1 {
            if self.blocks[x]![y] != nil && !self.blocks[x]![y]!.isDeadly() {
                let npos = getCenterForCoord(x: x, y: y+1)
                
                let move = SKAction.move(to: npos, duration: GridController.animationDuration)
                let fade = SKAction.fadeOut(withDuration: GridController.animationDuration)
                let group =  SKAction.group([move, fade])
                let remove = SKAction.removeFromParent()
                let sequence = SKAction.sequence([group, remove])
                
                self.blocks[x]![y]!.run(sequence)
                self.blocks[x]![y] = nil
            }
        }
    }

    private func spawn(spawnable: Spawnable, x: Int, y: Int, animated: Bool) {
        if (x < 0 || x >= self.gridWidth) {
            fatalError("Index x=\(x) out of bounds")
        }
        
        if (y < 1 || y >= self.gridHeight) {
            fatalError("Index y=\(y) out of bounds")
        }

        if (self.blocks[x]![y] != nil) {
            fatalError("Element already exists at coordinate (\(x), \(y)")
        }

        let dest = getCenterForCoord(x: x, y: y)
        
        if animated {
            let from = CGPoint(x: dest.x, y: dest.y + self.blockSize.height)
            let fadeIn = SKAction.fadeIn(withDuration: GridController.animationDuration)
            let move = SKAction.move(to: dest, duration: GridController.animationDuration)
            
            spawnable.alpha = 0.0
            spawnable.position = from
            spawnable.run(SKAction.group([fadeIn, move]))
        } else {
            spawnable.position = dest
        }
        
        self.blocks[x]![y] = spawnable
        self.scene.addChild(spawnable)
    }

    private func getCenterForCoord(x: Int, y: Int) -> CGPoint {
        let ret = CGPoint(x: (CGFloat(x) + 0.5) * blockSize.width + self.bounds.minX,
                          y: self.bounds.maxY - (CGFloat(y) + 0.5) * blockSize.height)
        return ret
    }

}

//
//  Button.swift
//  Ballout
//
//  Created by Joakim Stien on 26/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import SpriteKit

class Button: SKSpriteNode {
    public var showHoverTint: Bool = true
    public var hoverTintFactor: Float = 0.9
    
    public var gameScene: SKScene?
    public var isTouched: Bool = false
    
    public var clickCallback: (()->Void)?
    
    private var defaultBackgroundColor: UIColor
    
    required init?(coder aDecoder: NSCoder) {
        self.defaultBackgroundColor = UIColor.white
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.defaultBackgroundColor = UIColor.white
        super.init(texture: texture, color: color, size: size)
    }
    
    public func onTouchBegan() -> Void {
        self.isTouched = true
        
        if self.showHoverTint {
            self.defaultBackgroundColor = self.color
            let c = self.defaultBackgroundColor
            let f = CGFloat(self.hoverTintFactor)
            self.color = UIColor(red: CGFloat(c.redValue * f),
                                 green: CGFloat(c.greenValue * f),
                                 blue: CGFloat(c.blueValue * f),
                                 alpha: CGFloat(c.alphaValue))
        }
    }
    
    public func onTouchEnded() -> Void {
        self.isTouched = false
        
        if self.showHoverTint {
            self.color = self.defaultBackgroundColor
        }
    }

    public func onClick() -> Void {
        self.clickCallback?()
    }
}

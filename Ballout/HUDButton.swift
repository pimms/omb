//
//  HUDButton.swift
//  Ballout
//
//  Created by Joakim Stien on 07/07/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import UIKit

class HUDButton: Button {
    private var defaultBackgroundColor: UIColor?
    private var touchedBackgroundColor: UIColor?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initColors()
    }
    
    private func initColors() {
        self.defaultBackgroundColor = self.color
        
        let c = self.color
        self.touchedBackgroundColor = UIColor(colorLiteralRed: Float(c.redValue * 0.9),
                                              green: Float(c.greenValue * 0.9),
                                              blue: Float(c.blueValue * 0.9),
                                              alpha: Float(c.alphaValue))
    }
    
    override func onTouchBegan() -> Void {
        self.color = self.touchedBackgroundColor!
    }

    override func onTouchEnded() -> Void {
        self.color = self.defaultBackgroundColor!
    }
}

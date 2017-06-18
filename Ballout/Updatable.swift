//
//  Updatable.swift
//  Ballout
//
//  Created by Joakim Stien on 18/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation

protocol Updatable {
    func update(deltaTime dt: TimeInterval) -> Void
}

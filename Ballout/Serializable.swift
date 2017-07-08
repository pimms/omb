//
//  Serializable.swift
//  Ballout
//
//  Created by Joakim Stien on 08/07/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation

// The Serializable protocol does not, like the NSCoding protocol, require that
// the object is created from scratch for deserialization.
protocol Serializable {
    func serialize(coder: NSCoder)
    func deserialize(coder: NSCoder)
}

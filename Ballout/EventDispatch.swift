//
//  EventDispatch.swift
//  Ballout
//
//  Created by Joakim Stien on 07/08/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation

enum Event {
    case noBlocksRemaining
}

class EventDispatch {
    private static var s_instance: EventDispatch?
    
    private var dispatchMap: Dictionary<Event,Array<()->Void>?>

    public static func createSingleton() {
        if s_instance == nil {
            s_instance = EventDispatch()
        }
    }
    
    public static func destroySingleton() {
        s_instance = nil
    }
    
    public static func sharedInstance() -> EventDispatch? {
        return s_instance
    }
    
    public static func addHandler(_ event: Event, _ handler: @escaping ()->Void) {
        createSingleton()

        if let d = s_instance {
            if d.dispatchMap[event] == nil {
                d.dispatchMap[event] = Array<()->Void>()
            }
            d.dispatchMap[event]!?.append(handler)
        }
    }
    
    public static func dispatch(event: Event) {
        if s_instance?.dispatchMap[event] != nil {
            for h in s_instance!.dispatchMap[event]!! {
                h()
            }
        }
    }
    
    init() {
        self.dispatchMap = Dictionary<Event, Array<()->Void>>()
    }
    
}

//
//  GameViewController.swift
//  Ballout
//
//  Created by Joakim Stien on 17/06/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController {
    public static var activeInstance: GameViewController?
    private var balloutScene: BalloutScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameViewController.activeInstance = self
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "BalloutScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! BalloutScene? {
                self.balloutScene = sceneNode
                
                sceneNode.bindViewController(viewController: self)
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                    //view.showsPhysics = true
                }
            }
        }
    }
    
    public func serializeState() {
        self.balloutScene?.serializeState()
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // if UIDevice.current.userInterfaceIdiom == .phone { }
        return UIInterfaceOrientationMask.portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

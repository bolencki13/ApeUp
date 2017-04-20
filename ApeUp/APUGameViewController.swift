//
//  GameViewController.swift
//  ApeUp
//
//  Created by Brian Olencki on 4/19/17.
//  Copyright © 2017 Brian Olencki. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class APUGameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = APUMenuScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

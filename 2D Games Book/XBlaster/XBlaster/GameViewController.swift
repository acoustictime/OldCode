//
//  GameViewController.swift
//  XBlaster
//
//  Created by James Small on 5/31/15.
//  Copyright (c) 2015 SmallJames. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: CGSize(width: 768, height: 1024))
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }

    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

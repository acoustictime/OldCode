//
//  GameViewController.swift
//  CircuitRacer
//
//  Created by James Small on 9/24/15.
//  Copyright (c) 2015 SmallJames. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    private var analogControl: AnalogControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            scene.levelType = LevelType.Easy
            scene.carType = CarType.Yellow
            skView.showsPhysics = true
            
            skView.presentScene(scene)
            
            let padSide: CGFloat = view.frame.size.height / 2.5
            let padPadding: CGFloat = view.frame.size.height / 32
            
            analogControl = AnalogControl(frame: CGRectMake(padPadding, skView.frame.size.height - padPadding - padSide, padSide, padSide))
            
            view.addSubview(analogControl)
            scene.gameOverBlock = {(didWin) in
                self.gameOverWithWin(didWin)}
            analogControl.delegate = scene
        }
    }
    
    func gameOverWithWin(didWin: Bool) {
        let alert = UIAlertController(title: didWin ? "You wont!": "You lost", message: "Game Over", preferredStyle: .Alert)
        presentViewController(alert, animated: true, completion: nil)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

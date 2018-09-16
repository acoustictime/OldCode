//
//  MainMenuScene.swift
//  ZombieConga
//
//  Created by James Small on 6/2/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        var background: SKSpriteNode
        background = SKSpriteNode(imageNamed: "MainMenu.png")
        
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(background)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneTapped()
    }
    
    private func sceneTapped() {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        let reveal = SKTransition.doorway(withDuration: 1.5)
        view?.presentScene(gameScene, transition: reveal)
    }
    
    
    
}


//
//  MessageNode.swift
//  CatNap
//
//  Created by James Small on 6/9/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import SpriteKit

class MessageNode: SKLabelNode {
    
    
    var bounceCount = 0
    
    convenience init(message: String) {
        self.init(fontNamed: "AvenirNext-Regular")
        bounceCount = 0
    
        text = message
        fontSize = 256.0
        fontColor = SKColor.gray
        zPosition = 100
        
        let front = SKLabelNode(fontNamed: "AvenirNext-Regular")
        front.text = message
        front.fontSize = 256.0
        front.fontColor = SKColor.white
        front.position = CGPoint(x: -2, y: -2)
        addChild(front)
        
        physicsBody = SKPhysicsBody(circleOfRadius: 10)
        physicsBody!.collisionBitMask = PhysicsCategory.Edge
        physicsBody!.categoryBitMask = PhysicsCategory.Label
        physicsBody!.contactTestBitMask = PhysicsCategory.Edge
        physicsBody!.restitution = 0.7
    }
    
    func didBounce() {
        bounceCount += 1
        
        if bounceCount >= 4 {
            self.removeFromParent()
        }
    }
}

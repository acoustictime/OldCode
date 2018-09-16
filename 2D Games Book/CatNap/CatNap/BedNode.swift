//
//  BedNode.swift
//  CatNap
//
//  Created by James Small on 6/8/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import SpriteKit

class BedNode : SKSpriteNode, EventListenerNode {
    func didMoveToScene() {
        print("bed added to scene")
        let bedBodySize = CGSize(width: 40.0, height: 30.0)
        physicsBody = SKPhysicsBody(rectangleOf: bedBodySize)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Bed
        physicsBody!.collisionBitMask = PhysicsCategory.none
    }
}

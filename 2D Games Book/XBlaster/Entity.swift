//
//  Entity.swift
//  XBlaster
//
//  Created by James Small on 6/13/15.
//  Copyright (c) 2015 SmallJames. All rights reserved.
//

import SpriteKit

class Entity: SKSpriteNode {
    
    var direction = CGPointZero
    var health = 100.0
    var maxHealth = 100.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(position: CGPoint, texture: SKTexture) {
        super.init(texture: texture, color: SKColor.whiteColor(), size: texture.size())
        self.position = position
    }
    
    class func generateTexture() -> SKTexture? {
        // overridden by subclass
        return nil
    }
    
    func update(delta: NSTimeInterval) {
        // overridden by subclass
    }
}

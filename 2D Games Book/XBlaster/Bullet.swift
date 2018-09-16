//
//  Bullet.swift
//  XBlaster
//
//  Created by James Small on 6/13/15.
//  Copyright (c) 2015 SmallJames. All rights reserved.
//

import SpriteKit

class Bullet: Entity {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(entityPosition: CGPoint) {
        let entityTexture = Bullet.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        name = "bullet"
    }
    
    override class func generateTexture() -> SKTexture? {
        // 1
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&SharedTexture.onceToken, {
            //2
            let bullet = SKLabelNode(fontNamed: "Arial")
            bullet.name = "bullet"
            bullet.fontSize = 15
            bullet.fontColor = SKColor.whiteColor()
            bullet.text = "❆"
  
            //5
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(bullet)
            SharedTexture.texture.filteringMode = .Nearest
            
        })
        
        return SharedTexture.texture
    }
}

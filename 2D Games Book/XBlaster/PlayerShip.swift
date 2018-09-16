//
//  PlayerShip.swift
//  XBlaster
//
//  Created by James Small on 6/13/15.
//  Copyright (c) 2015 SmallJames. All rights reserved.
//

import SpriteKit

class PlayerShip: Entity {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(entityPosition: CGPoint) {
        let entityTexture = PlayerShip.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        name = "playerShip"
    }

    override class func generateTexture() -> SKTexture? {
        // 1
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&SharedTexture.onceToken, {
            //2
            let mainShip = SKLabelNode(fontNamed: "Arial")
            mainShip.name = "mainShip"
            mainShip.fontSize = 40
            mainShip.fontColor = SKColor.whiteColor()
            mainShip.text = "▲"
            
            //3
            let wings = SKLabelNode(fontNamed: "Arial")
            wings.name = "wings"
            wings.fontSize = 40
            wings.text = "< >"
            wings.fontColor = SKColor.whiteColor()
            wings.position = CGPoint(x: 1, y: 10)
            
            //3.5
            let leftGun = SKLabelNode(fontNamed: "Arial")
            leftGun.name = "leftGun"
            leftGun.fontSize = 40
            leftGun.text = "⌞"
            leftGun.fontColor = SKColor.whiteColor()
            leftGun.position = CGPoint(x: -25, y: -5)
            
            let rightGun = SKLabelNode(fontNamed: "Arial")
            rightGun.name = "rightGun"
            rightGun.fontSize = 40
            rightGun.text = "⌟"
            rightGun.fontColor = SKColor.whiteColor()
            rightGun.position = CGPoint(x: 27, y: -5)
            
            let tip = SKLabelNode(fontNamed: "Arial")
            tip.name = "tip"
            tip.fontSize = 30
            tip.text = "|"
            tip.fontColor = SKColor.whiteColor()
            tip.position = CGPoint(x: 1, y: 10)
            
            //4
            wings.zRotation = CGFloat(180).degreesToRadians()
            mainShip.addChild(wings)
            mainShip.addChild(leftGun)
            mainShip.addChild(rightGun)
            mainShip.addChild(tip)
            
            //5
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(mainShip)
            SharedTexture.texture.filteringMode = .Nearest
            
        })
        
        return SharedTexture.texture
    }
}




//
//  PictureNode.swift
//  CatNap
//
//  Created by James Small on 6/13/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import SpriteKit

class PictureNode: SKSpriteNode, EventListenerNode, InteractiveNode {

    func didMoveToScene() {
        isUserInteractionEnabled = true
        
        let pictureNode = SKSpriteNode(imageNamed: "picture")
        let maskNode = SKSpriteNode(imageNamed: "picture-frame-mask")
        
        let cropNode = SKCropNode()
        cropNode.addChild(pictureNode)
        cropNode.maskNode = maskNode
        addChild(cropNode)
    }
    
    func interact() {
        isUserInteractionEnabled = false
        physicsBody!.isDynamic = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}

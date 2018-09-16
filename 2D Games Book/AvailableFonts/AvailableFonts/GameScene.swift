//
//  GameScene.swift
//  AvailableFonts
//
//  Created by James Small on 5/31/15.
//  Copyright (c) 2015 SmallJames. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    
    var familyIdx: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(size:CGSize) {
        super.init(size: size)
        showCurrentFamily()
    }
    
    func showCurrentFamily() {
        
        removeAllChildren()
        
        let familyName = UIFont.familyNames()[familyIdx] as! String
        println("Family: \(familyName)")
        
        let fontNames = UIFont.fontNamesForFamilyName(familyName) as! [String]
        
        for (idx, fontName) in enumerate(fontNames) {
            let label = SKLabelNode(fontNamed: fontName)
            label.text = fontName
            label.position = CGPoint(
                x: size.width / 2,
                y: (size.height * (CGFloat(idx + 1))) /
                    (CGFloat(fontNames.count)+1))
            label.fontSize = 25
            label.verticalAlignmentMode = .Center
            addChild(label)
            
            
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        familyIdx++
        if familyIdx >= UIFont.familyNames().count {
            familyIdx = 0
        }
        showCurrentFamily()
    }
}

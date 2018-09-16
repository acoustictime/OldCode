//
//  GameScene.swift
//  XBlaster
//
//  Created by James Small on 5/31/15.
//  Copyright (c) 2015 SmallJames. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let playerLayderNode = SKNode()
    let bulletLayerNode = SKNode()
    let hudLayerNode = SKNode()
    let playableRect: CGRect
    let hudHeight: CGFloat = 90
    let scoreLabel = SKLabelNode(fontNamed: "Edit Undo Line BRK")
    var scoreFlashAction: SKAction!
    let healthBarString: NSString = "===================="
    let playerHealthLabel = SKLabelNode(fontNamed: "Arial")
    var playerShip: PlayerShip!
    var deltaPoint = CGPointZero
    var bulletInterval: NSTimeInterval = 0
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    
    override func didMoveToView(view: SKView) {
        let myLabel = SKLabelNode(fontNamed: "Edit Undo Line BRK")
       
        
    }
    
    func setupSceneLayers() {
        playerLayderNode.zPosition = 50
        hudLayerNode.zPosition = 100
        bulletLayerNode.zPosition = 25
        
        addChild(playerLayderNode)
        addChild(hudLayerNode)
        addChild(bulletLayerNode)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        // Calculate playable margin
        let maxAspectRatio: CGFloat = 16.0/9.0 // iphone 5"
        let maxAspectRatioWidth = size.height / maxAspectRatio
        let playableMargin = (size.width-maxAspectRatioWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0, width: maxAspectRatioWidth, height: size.height - hudHeight)
        
        super.init(size: size)
        
        setupSceneLayers()
        
        setUpUI()
        
        setupEntities()
    }
    
    func setUpUI() {
        
        let backgroundSize = CGSize(width: size.width, height: hudHeight)
        let backgroundColor = SKColor.blackColor()
        let hudBarBackground = SKSpriteNode(color: backgroundColor, size: backgroundSize)
        hudBarBackground.position = CGPoint(x: 0, y: size.height - hudHeight)
        hudBarBackground.anchorPoint = CGPointZero
        hudLayerNode.addChild(hudBarBackground)
        
        scoreLabel.fontSize = 50
        scoreLabel.text = "Score: 0"
        scoreLabel.name = "scoreLabel"
        
        scoreLabel.verticalAlignmentMode = .Center
        
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - scoreLabel.frame.size.height + 3)
        
        hudLayerNode.addChild(scoreLabel)
        
        scoreFlashAction = SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.1),SKAction.scaleTo(1.0, duration: 0.1)])
        scoreLabel.runAction(SKAction.repeatAction(scoreFlashAction, count: 20))
        
        // 1
        let playerHealthBackgroundLabel = SKLabelNode(fontNamed: "Arial")
        playerHealthBackgroundLabel.name = "playerHealthBackground"
        playerHealthBackgroundLabel.fontColor = SKColor.darkGrayColor()
        playerHealthBackgroundLabel.fontSize = 50
        playerHealthBackgroundLabel.text = healthBarString as String
        
        //2
        playerHealthBackgroundLabel.horizontalAlignmentMode = .Left
        playerHealthBackgroundLabel.verticalAlignmentMode = .Top
        playerHealthBackgroundLabel.position = CGPoint(x: CGRectGetMinX(playableRect), y: size.height - CGFloat(hudHeight) + playerHealthBackgroundLabel.frame.size.height)
        hudLayerNode.addChild(playerHealthBackgroundLabel)
        
        //3
        playerHealthLabel.name = "playerHealthLabel"
        playerHealthLabel.fontColor = SKColor.greenColor()
        playerHealthLabel.fontSize = 50
        playerHealthLabel.text = healthBarString.substringToIndex(20*75/100)
        playerHealthLabel.horizontalAlignmentMode = .Left
        playerHealthLabel.verticalAlignmentMode = .Top
        playerHealthLabel.position = CGPoint(x: CGRectGetMinX(playableRect), y: size.height - CGFloat(hudHeight) + playerHealthLabel.frame.size.height)
        hudLayerNode.addChild(playerHealthLabel)
        
    }
    
    func setupEntities() {
        playerShip = PlayerShip(entityPosition: CGPoint(x: size.width / 2, y: 100))
        playerLayderNode.addChild(playerShip)

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as! UITouch
        let currentPoint = touch.locationInNode(self)
        let previousTouchLocation = touch.previousLocationInNode(self)
        deltaPoint = currentPoint - previousTouchLocation
    }
    
    override func update(currentTime: NSTimeInterval) {
        //1
        var newPoint:CGPoint = playerShip.position + deltaPoint
        
        //2
        newPoint.x.clamp(CGRectGetMinX(playableRect), CGRectGetMaxX(playableRect))
        newPoint.y.clamp(CGRectGetMinY(playableRect), CGRectGetMaxY(playableRect))
        
        //3
        playerShip.position = newPoint
        deltaPoint = CGPointZero
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        
        bulletInterval += dt
        if bulletInterval > 0.30 {
            bulletInterval = 0
            
            // 1: Create Bullet
            let bullet = Bullet(entityPosition: playerShip.position + CGPoint(x: 0, y: 20))
            let bulletLeft = Bullet(entityPosition: playerShip.position + CGPoint(x: -30, y: 0))
            let bulletRight = Bullet(entityPosition: playerShip.position + CGPoint(x: 30, y: 0))
            
            // 2: Add to scene
            bulletLayerNode.addChild(bullet)
            bulletLayerNode.addChild(bulletLeft)
            bulletLayerNode.addChild(bulletRight)
            
            // 3: Sequence: Move up screen, remove from parent
            
            bullet.runAction(SKAction.sequence([
                SKAction.moveByX(0, y: size.height - hudHeight, duration: 1),
                SKAction.removeFromParent()
                ]))
            bulletLeft.runAction(SKAction.sequence([
                SKAction.moveByX(-30, y: size.height - hudHeight, duration: 1),
                SKAction.removeFromParent()
                ]))
            bulletRight.runAction(SKAction.sequence([
                SKAction.moveByX(30, y: size.height - hudHeight, duration: 1),
                SKAction.removeFromParent()
                ]))
        }
        
        
    }
}

//
//  GameScene.swift
//  CatNap
//
//  Created by James Small on 6/6/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import SpriteKit

protocol EventListenerNode {
    func didMoveToScene()
}

protocol InteractiveNode {
    func interact()
}

struct PhysicsCategory {
    static let none:  UInt32 = 0
    static let Cat:   UInt32 = 0b1 // 1
    static let Block: UInt32 = 0b10 // 2
    static let Bed:   UInt32 = 0b100 // 4
    static let Edge:  UInt32 = 0b1000 // 8
    static let Label: UInt32 = 0b10000 // 16
    static let Spring:UInt32 = 0b100000 // 32
    static let Hook:  UInt32 = 0b1000000 // 64
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bedNode: BedNode!
    var catNode: CatNode!
    var hookBaseNode: HookBaseNode?
    var playable = true
    var currentLevel: Int = 0
    

    override func didMove(to view: SKView) {
        let maxAspectRatio : CGFloat = 16.0/9.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight) / 2
        
        let playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height - playableMargin*2)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody?.categoryBitMask = PhysicsCategory.Edge
        
        
        enumerateChildNodes(withName: "//*") { node, _ in
            if let eventListenderNode = node as? EventListenerNode {
                eventListenderNode.didMoveToScene()
            }
            
        }
        
        bedNode = childNode(withName: "bed") as! BedNode
        catNode = childNode(withName: "//cat_body") as! CatNode
        
        hookBaseNode = childNode(withName: "hookBase") as? HookBaseNode
        
       // SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
    
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Edge | PhysicsCategory.Label {
            let labelNode = contact.bodyA.categoryBitMask == PhysicsCategory.Label ? contact.bodyA.node : contact.bodyB.node
            if let lNode = labelNode as? MessageNode {
                lNode.didBounce()
            }
        }

        if !playable {
            return
        }
        
        if collision == PhysicsCategory.Cat | PhysicsCategory.Bed {
            print("success")
            win()
        } else if collision == PhysicsCategory.Cat | PhysicsCategory.Edge {
            print("fail")
            lose()
        }
        
        if collision == PhysicsCategory.Cat | PhysicsCategory.Hook
            && hookBaseNode?.isHooked == false {
            hookBaseNode!.hookCat(catPhysicsBody:
                catNode.parent!.physicsBody!)
        }
    }
    
    func inGameMessage(text: String) {
        let message = MessageNode(message: text)
        message.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(message)
    }
    
    func newGame() {
       view!.presentScene(GameScene.level(levelNum: currentLevel))
    }
    
    func lose() {
        
        if currentLevel > 1 {
            currentLevel -= 1
        }
        
        playable = false
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("lose.mp3")
        
        inGameMessage(text: "Try again...")
        
        perform(#selector(newGame), with: nil, afterDelay: 5)
        
        catNode.wakeUp()
    }

    func win() {
        
        if currentLevel < 6 {
            currentLevel += 1
        }
        
        
        playable = false
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("win.mp3")
        
        inGameMessage(text: "Nice Job!")
        
        perform(#selector(newGame), with: nil, afterDelay: 3)
        
        catNode.curlAt(scenePoint: bedNode.position)
    }
    
    override func didSimulatePhysics() {
        if playable && hookBaseNode?.isHooked != true {
            if fabs(catNode.parent!.zRotation) > CGFloat(25).degreesToRadians() {
                lose()
            }
        }
    }
    
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.currentLevel = levelNum
        scene.scaleMode = .aspectFill
        return scene
    }
    
}

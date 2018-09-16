//
//  Bug.swift
//  PestControl
//
//  Created by James Small on 6/19/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import SpriteKit

extension Bug : Animatable {}

enum BugSettings {
  static let bugDistance: CGFloat = 16
}

class Bug: SKSpriteNode {
  
  var animations: [SKAction] = []


  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    animations = aDecoder.decodeObject(forKey: "Bug.animations") as! [SKAction]
  }
  
  override func encode(with aCoder: NSCoder) {
    aCoder.encode(animations, forKey: "Bug.animations")
    super.encode(with: aCoder)
  }

  init() {
    let texture = SKTexture(pixelImageNamed: "bug_ft1")
    super.init(texture: texture, color: .white, size: texture.size())
    name = "bug"
    zPosition = 50
    
    physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
    physicsBody?.restitution = 0.5
    physicsBody?.allowsRotation = false
    physicsBody?.categoryBitMask = PC.Bug
    
    createAnimations(character: "bug")
    
  }
  
  func moveBug() {
    let randomX = CGFloat(Int.random(min: -1, max: 1))
    let randomY = CGFloat(Int.random(min: -1, max: 1))
    
    let vector = CGVector(dx: randomX * BugSettings.bugDistance, dy: randomY * BugSettings.bugDistance)
    
    let moveBy = SKAction.move(by: vector, duration: 1)
    let moveAgain = SKAction.perform(#selector(moveBug), onTarget: self)
    
    let direction = animationDirection(for: vector)
    
    if direction == .left {
      xScale = abs(xScale)
    } else if direction == .right {
      xScale = -abs(xScale)
    }
    
    run(animations[direction.rawValue], withKey: "animation")
    run(SKAction.sequence([moveBy, moveAgain]))
    
    
    
    
  }
  
  func die() {
    removeAllActions()
    texture = SKTexture(pixelImageNamed: "bug_lt1")
    yScale = -1
    physicsBody = nil
    run(SKAction.sequence([SKAction.fadeOut(withDuration: 3), SKAction.removeFromParent()]))
  }
}




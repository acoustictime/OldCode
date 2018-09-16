//
//  GameScene.swift
//  ZombieConga
//
//  Created by James Small on 5/17/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var lastUpdateTime: TimeInterval = 0
    let cameraNode = SKCameraNode()
    var lives = 5
    var gameOver = false
    var dt: TimeInterval = 0
    let zombieMovePointsPerSec: CGFloat = 480.0
    let trainMovePointsPerSec: CGFloat = 480.0
    let cameraMovePointsPerSec: CGFloat = 200.0
    let zombieRotateRadiansPerSec: CGFloat = 4.0 * π
    let zombieAnimation : SKAction
    var zombieInvincible = false
    var velocity = CGPoint.zero
    let playableRect: CGRect
    var lastTouchLocation: CGPoint?
    let catCollisionSound = SKAction.playSoundFileNamed("hitCat.wav", waitForCompletion: false)
    let enemyCollisionSound = SKAction.playSoundFileNamed("hitCatLady.wav", waitForCompletion: false)
    let livesLabel = SKLabelNode(fontNamed: "Chalkduster")
    let catsLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    
    var cameraRect : CGRect {
        let x = cameraNode.position.x - size.width / 2 + (size.width - playableRect.width) / 2
        let y = cameraNode.position.y - size.height / 2 + (size.height - playableRect.height) / 2
        return CGRect(x: x, y: y, width: playableRect.width, height: playableRect.height)
    }
    
    private func moveCamera() {
        let backgroundVelocity = CGPoint(x: cameraMovePointsPerSec, y: 0)
        let amountToMove = backgroundVelocity * CGFloat(dt)
        cameraNode.position += amountToMove
        
        enumerateChildNodes(withName: "background") { node, _ in
            let background = node as! SKSpriteNode
            if background.position.x + background.size.width < self.cameraRect.origin.x {
                background.position = CGPoint(x: background.position.x + background.size.width * 2, y: background.position.y)
            }
        }
    }
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight) / 2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        var textures: [SKTexture] = []
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "zombie\(i)"))
        }
        textures.append(textures[2])
        textures.append(textures[1])
        
        zombieAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
        zombie.zPosition = 100
        
        
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
//        let background = SKSpriteNode(imageNamed: "background1")
//        background.position = CGPoint(x: size.width/2, y: size.height/2)
//        background.zPosition = -1
//        addChild(background)
        
        for i in 0...1 {
            let background = backgroundNode()
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: CGFloat(i) * background.size.width, y: 0)
            background.name = "background"
            addChild(background)
        }
        
        
        
        zombie.position = CGPoint(x: 400, y: 400)
        addChild(zombie)
        
       // zombie.run(SKAction.repeatForever(zombieAnimation))
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() {[weak self] in self?.spawnEnemy()},SKAction.wait(forDuration: 2.0)])))
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() {[weak self] in self?.spawnCat()},SKAction.wait(forDuration: 1.0)])))

        debugDrawPlayableArea()
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        livesLabel.text = "Lives: X"
        livesLabel.fontColor = SKColor.black
        livesLabel.fontSize = 100
        livesLabel.zPosition = 150
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.verticalAlignmentMode = .bottom
        livesLabel.position = CGPoint(x: -playableRect.size.width/2 + CGFloat(20), y: -playableRect.size.height/2 + CGFloat(20))
        cameraNode.addChild(livesLabel)
        
        catsLabel.text = "Cats: X"
        catsLabel.fontColor = SKColor.black
        catsLabel.fontSize = 100
        catsLabel.zPosition = 150
        catsLabel.horizontalAlignmentMode = .right
        catsLabel.verticalAlignmentMode = .bottom
        catsLabel.position = CGPoint(x: playableRect.size.width/2 - CGFloat(20), y: -playableRect.size.height/2 + CGFloat(20))
        cameraNode.addChild(catsLabel)
        
    }
    
    func backgroundNode() -> SKSpriteNode {
        let backgroundNode = SKSpriteNode()
        backgroundNode.anchorPoint = CGPoint.zero
        backgroundNode.name = "background"
        
        let background1 = SKSpriteNode(imageNamed: "background1")
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint(x: 0, y: 0)
        backgroundNode.addChild(background1)
        
        let background2 = SKSpriteNode(imageNamed: "background2")
        background2.anchorPoint = CGPoint.zero
        background2.position = CGPoint(x: background1.size.width, y: 0)
        backgroundNode.addChild(background2)
        
        backgroundNode.size = CGSize(width: background1.size.width + background2.size.width, height: background1.size.height)
        return backgroundNode
    }
    
    override func update(_ currentTime: TimeInterval) {
        
//        if let lastTouch = lastTouchLocation {
//            if (lastTouch - zombie.position).length() <= zombieMovePointsPerSec * CGFloat(dt) {
//                zombie.position = lastTouch
//                velocity = CGPoint.zero
//                stopZombieAnimation()
//            } else {
                move(sprite: zombie, velocity: velocity)
                rotate(sprite: zombie, direction: velocity, rotateRadiansPerSec: zombieRotateRadiansPerSec)
//            }
//        }

        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        boundsCheckZombie()
      //  checkCollisions()
        moveTrain()
        moveCamera()
        livesLabel.text = "Lives: \(lives)"
        
        
        if lives <= 0 && !gameOver {
            gameOver = true
            
            let gameOverScene = GameOverScene(size: size, won: false)
            gameOverScene.scaleMode = scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
    private func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
    }
    
    private func moveZombieToward(location: CGPoint) {
        startZombieAnimation()
        let offset = location - zombie.position
      //let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        let direction = offset.normalized() //CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
        velocity = direction * zombieMovePointsPerSec //CGPoint(x: direction.x * zombieMovePointsPerSec, y: direction.y * zombieMovePointsPerSec)
    }
    
    private func sceneTouched(touchLocation: CGPoint) {
        lastTouchLocation = touchLocation
        moveZombieToward(location: touchLocation)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    private func boundsCheckZombie() {
        let bottomLeft = CGPoint(x: cameraRect.minX, y: cameraRect.minY)
        let topRight = CGPoint(x: cameraRect.maxX, y: cameraRect.maxY)
        
        if zombie.position.x <= bottomLeft.x {
            zombie.position.x = bottomLeft.x
            velocity.x = abs(velocity.x)
        }
        
        if zombie.position.y <= bottomLeft.y {
            zombie.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        
        if zombie.position.x >= topRight.x {
            zombie.position.x = topRight.x
            velocity.x = -velocity.x
        }
        
        if zombie.position.y >= topRight.y {
            zombie.position.y = topRight.y
            velocity.y = -velocity.y
        }
        
        
    }
    
    private func rotate(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
        //sprite.zRotation = CGFloat(atan2(Double(direction.y), Double(direction.x)))
        
        let shortest = shortestAngleBetween(angle1: sprite.zRotation, angle2: velocity.angle)
        let amountToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
        sprite.zRotation += shortest.sign() * amountToRotate
    }
    
    func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.name = "enemy"
        enemy.position = CGPoint(
            x: cameraRect.maxX + enemy.size.width / 2,
            y: CGFloat.random(
                min: cameraRect.minY + enemy.size.height/2,
                max: cameraRect.maxY - enemy.size.height/2))
        addChild(enemy)
        enemy.zPosition = 50
        
        let actionMove = SKAction.moveBy(x: -(size.width + enemy.size.width), y: 0, duration: 2.0)
        let actionRemove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([actionMove, actionRemove])
        
        enemy.run(sequence)
    }
    
    private func startZombieAnimation() {
        if zombie.action(forKey: "animation") == nil {
            zombie.run(SKAction.repeatForever(zombieAnimation), withKey: "animation")
        }
    }
    
    func stopZombieAnimation() {
        zombie.removeAction(forKey: "animation")
    }
    
    func spawnCat() {
        let cat = SKSpriteNode(imageNamed: "cat")
        cat.name = "cat"
        cat.position = CGPoint(
            x: CGFloat.random(min: cameraRect.minX,
            max: cameraRect.maxX),
            y: CGFloat.random(min: cameraRect.minY,
            max: cameraRect.maxY))
        cat.zPosition = 50
    
        cat.setScale(0)
        addChild(cat)
        
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        cat.zRotation = -π / 16.0
        let leftWiggle = SKAction.rotate(byAngle: π/8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversed()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
        //let wiggleWait = SKAction.repeat(fullWiggle, count: 10)
        
        let scaleUp = SKAction.scale(by: 1.2, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullScale = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleDown])
        let group = SKAction.group([fullScale, fullWiggle])
        let groupWait = SKAction.repeat(group, count: 10)
        
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, groupWait, disappear, removeFromParent]
        cat.run(SKAction.sequence(actions))
    }
    
    private func zombieHit(cat: SKSpriteNode) {
        cat.name = "train"
        cat.removeAllActions()
        cat.setScale(1.0)
        cat.zRotation = 0
        
        let turnGreen = SKAction.colorize(with: SKColor.green, colorBlendFactor: 1.0, duration: 0.2)
        cat.run(turnGreen)

        
      //  cat.removeFromParent()
        run(catCollisionSound)
    }
    
    private func zombieHit(enemy: SKSpriteNode) {
        
        
        // enemy.removeFromParent()
        
        zombieInvincible = true
        
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        
        let setHidden = SKAction.run() { [weak self] in
            self?.zombie.isHidden = false
            self?.zombieInvincible = false
        }
        
        zombie.run(SKAction.sequence([blinkAction, setHidden ]))
        
        run(enemyCollisionSound)
        loseCats()
        lives -= 1
    }
    
    func checkCollisions() {
        var hitCats: [SKSpriteNode] = []
        enumerateChildNodes(withName: "cat") { node, _ in
            let cat = node as! SKSpriteNode
            if cat.frame.intersects(self.zombie.frame) {
                hitCats.append(cat)
            }
        }
        
        for currentCat in hitCats {
            zombieHit(cat: currentCat)
        }
        
        if !zombieInvincible {
            var hitEnemies: [SKSpriteNode] = []
            enumerateChildNodes(withName: "enemy") { node, _ in
                let enemy = node as! SKSpriteNode
                if enemy.frame.insetBy(dx: 20, dy: 20).intersects(self.zombie.frame) {
                    hitEnemies.append(enemy)
                }
            }
            
            for currentEnemy in hitEnemies {
                zombieHit(enemy: currentEnemy)
            }
        }
        
        
    }
    
    private func moveTrain() {
        var targetPosition = zombie.position
        var trainCount = 0
        
        enumerateChildNodes(withName: "train") { node, stop in
            trainCount += 1
            if !node.hasActions() {
                let actionDuration = 0.3
                let offset = targetPosition - node.position
                let direction = offset.normalized()
                let amountToMovePerSec = direction * self.trainMovePointsPerSec
                let amountToMove = amountToMovePerSec * CGFloat(actionDuration)
                let moveAction = SKAction.moveBy(x: amountToMove.x, y: amountToMove.y, duration: actionDuration)
                node.run(moveAction)
            }
            targetPosition = node.position
        }
        
        if trainCount > 5 && !gameOver {
            gameOver = true
            
            let gameOverScene = GameOverScene(size: size, won: true)
            gameOverScene.scaleMode = scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameOverScene, transition: reveal)
            
        }
        catsLabel.text = "Cats: \(trainCount)"
    }
    
    func loseCats() {
        // 1
        var loseCount = 0
        enumerateChildNodes(withName: "train") { node, stop in
            // 2
            var randomSpot = node.position
            randomSpot.x += CGFloat.random(min: -100, max: 100)
            randomSpot.y += CGFloat.random(min: -100, max: 100)
            // 3
            node.name = ""
            node.run(
                SKAction.sequence([
                    SKAction.group([
                        SKAction.rotate(byAngle: π*4, duration: 1.0),
                        SKAction.move(to: randomSpot, duration: 1.0),
                        SKAction.scale(to: 0, duration: 1.0)
                        ]),
                    SKAction.removeFromParent()
                    ]))
            // 4
            loseCount += 1
            if loseCount >= 2 {
                stop[0] = true
            }
        }
    }
}

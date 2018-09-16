//
//  GameScene.swift
//  DropCharge
//
//  Created by James Small on 6/23/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import SpriteKit
import CoreMotion

struct PC {
    static let None: UInt32              = 0
    static let Player: UInt32            = 0b1
    static let PlatformNormal: UInt32    = 0b10
    static let PlatformBreakable: UInt32 = 0b100
    static let CoinNormal: UInt32        = 0b1000
    static let CoinSpecial: UInt32       = 0b10000
    static let Edges: UInt32             = 0b100000
}

// MARK: - Game States
enum GameStatus: Int {
    case waitingForTap = 0
    case waitingForBomb = 1
    case playing = 2
    case gameOver = 3
}

enum PlayerStatus: Int {
    case idle = 0
    case jump = 1
    case fall = 2
    case lava = 3
    case dead = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    
    var bgNode: SKNode!
    var fgNode: SKNode!
    var backgroundOverlayTemplate: SKNode!
    var backgroundOverlayHeight: CGFloat!
    var player: SKSpriteNode!
    
    var platform5Across: SKSpriteNode!
    var coinArrow: SKSpriteNode!
    var coinCross: SKSpriteNode!
    var coinSCross: SKSpriteNode!
    var breakArrow: SKSpriteNode!
    var coinSDiagonal: SKSpriteNode!
    var coinDiagonal: SKSpriteNode!
    var coin5Across: SKSpriteNode!
    var coinS5Across: SKSpriteNode!
    var breakDiagonal: SKSpriteNode!
    var platformArrow: SKSpriteNode!
    var platformDiagonal: SKSpriteNode!
    var break5Across: SKSpriteNode!
    var coinSArrow: SKSpriteNode!
    
    var lastOverlayPosition = CGPoint.zero
    var lastOverlayHeight: CGFloat = 0.0
    var levelPositionY: CGFloat = 0.0
    
    var gameState: GameStatus = .waitingForTap
    var playerState: PlayerStatus = .idle
    
    let motionManager = CMMotionManager()
    var xAcceleration = CGFloat(0)
    
    var lava: SKSpriteNode!
    
    let cameraNode = SKCameraNode()
    
    var lastUpdateTimeInterval: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    
    var lives = 3
    
    var coin: SKSpriteNode!
    var coinSpecial: SKSpriteNode!
    
    var playerAnimationJump: SKAction!
    var playerAnimationFall: SKAction!
    var playerAnimationSteerLeft: SKAction!
    var playerAnimationSteerRight: SKAction!
    var currentPlayerAnimation: SKAction?
    
    var playerTrail: SKEmitterNode!
    
    let gameGain: CGFloat = 2.5
    

    override func didMove(to view: SKView) {
        setupCoreMotion()
        physicsWorld.contactDelegate = self
        setupNodes()
        setupLevel()
        let scale = SKAction.sequence([SKAction.scale(to: 2.0, duration: 0.5),SKAction.scale(to: 1.0, duration: 0.5)])
        fgNode.childNode(withName: "Ready")!.run(scale)
        setupPlayer()
        camera?.position = CGPoint(x: size.width/2, y: size.height/2)
        
        playerAnimationJump = setupAnimationWithPrefix("player01_jump_", start: 1, end: 4, timePerFrame: 0.1)
        playerAnimationFall = setupAnimationWithPrefix("player01_fall_", start: 1, end: 3, timePerFrame: 0.1)
        playerAnimationSteerLeft = setupAnimationWithPrefix("player01_steerleft_", start: 1, end: 2, timePerFrame: 0.1)
        playerAnimationSteerRight = setupAnimationWithPrefix("player01_steerright_", start: 1, end: 2, timePerFrame: 0.1)
        
    }
    
    func setupNodes() {
        let worldNode = childNode(withName: "World")!

        bgNode = worldNode.childNode(withName: "Background")!
        backgroundOverlayTemplate = bgNode.childNode(withName: "Overlay")!.copy() as! SKNode
        backgroundOverlayHeight = backgroundOverlayTemplate.calculateAccumulatedFrame().height
        fgNode = worldNode.childNode(withName: "Foreground")!
        player = fgNode.childNode(withName: "Player") as! SKSpriteNode
        fgNode.childNode(withName: "Bomb")?.run(SKAction.hide())
        
        setupLava()

        platform5Across = loadForegroundOverlayTemplate("Platform5Across")
        breakArrow = loadForegroundOverlayTemplate("BreakArrow")
        breakDiagonal = loadForegroundOverlayTemplate("BreakDiagonal")
        platformArrow = loadForegroundOverlayTemplate("PlatformArrow")
        platformDiagonal = loadForegroundOverlayTemplate("PlatformDiagonal")
        break5Across = loadForegroundOverlayTemplate("Break5Across")
        
        coin = loadCoin("Coin")
        coinSpecial = loadCoin("CoinSpecial")
        
        coinArrow = loadCoinOverlayTemplate("CoinArrow")
        coinCross = loadCoinOverlayTemplate("CoinCross")
        coinSCross = loadCoinOverlayTemplate("CoinSCross")
        coinSDiagonal = loadCoinOverlayTemplate("CoinSDiagonal")
        coinDiagonal = loadCoinOverlayTemplate("CoinDiagonal")
        coin5Across = loadCoinOverlayTemplate("Coin5Across")
        coinS5Across = loadCoinOverlayTemplate("CoinS5Across")
        
        coinSArrow = loadCoinOverlayTemplate("CoinSArrow")
        
        
        
        addChild(cameraNode)
        camera = cameraNode
        
        
        
        
    }
    
    func setupLevel() {
        let initialPlatform = platform5Across.copy() as! SKSpriteNode
        var overlayPosition = player.position
        overlayPosition.y = player.position.y - ((player.size.height * 0.5) + (initialPlatform.size.height * 0.20))
        initialPlatform.position = overlayPosition
        fgNode.addChild(initialPlatform)
        lastOverlayPosition = overlayPosition
        lastOverlayHeight = initialPlatform.size.height / 2.0
        
        levelPositionY = bgNode.childNode(withName: "Overlay")!.position.y + backgroundOverlayHeight
        while lastOverlayPosition.y < levelPositionY {
            addRandomForegroundOverlay()
        }
    }
    
    func setupPlayer() {
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width * 0.3)
        player.physicsBody!.isDynamic = false
        player.physicsBody!.allowsRotation = false
        player.physicsBody!.categoryBitMask = PC.Player
        player.physicsBody!.collisionBitMask = 0
        player.zPosition = 10
        playerTrail = addTrail(name: "PlayerTrail")
    }
    
    func setupCoreMotion() {
        motionManager.accelerometerUpdateInterval = 0.2
        let queue = OperationQueue()
        motionManager.startAccelerometerUpdates(to: queue, withHandler: {
            accelerometerData, error in
            guard let accelerometerData = accelerometerData else {
                return
            }
            let acceleration = accelerometerData.acceleration
            self.xAcceleration = (CGFloat(acceleration.x) * 0.75) + (self.xAcceleration * 0.25)
        })
    }
    
    func loadForegroundOverlayTemplate(_ fileName: String) -> SKSpriteNode {
        let overlayScene = SKScene(fileNamed: fileName)!
        let overlayTemplate = overlayScene.childNode(withName: "Overlay")
        return overlayTemplate as! SKSpriteNode
    }
    
    func loadCoin(_ fileName: String) -> SKSpriteNode {
        let coinScene = SKScene(fileNamed: fileName)!
        let coinTemplate = coinScene.childNode(withName: "Coin")
        return coinTemplate as! SKSpriteNode
    }
    
    func loadCoinOverlayTemplate(_ fileName: String) -> SKSpriteNode {
        let overlayTemplate = loadForegroundOverlayTemplate(fileName)
        
        overlayTemplate.enumerateChildNodes(withName: "*",
                                            using: { (node, stop) in
                                                let coinPos = node.position
                                                let coin: SKSpriteNode
                                                // 3
                                                if node.name == "special" {
                                                    coin = self.coinSpecial.copy() as! SKSpriteNode
                                                } else {
                                                    coin = self.coin.copy() as! SKSpriteNode
                                                }
                                                // 4
                                                coin.position = coinPos
                                                overlayTemplate.addChild(coin)
                                                node.removeFromParent()
        })

        
        return overlayTemplate
    }
    
    func createForegroundOverlay(_ overlayTemplate: SKSpriteNode, flipX: Bool) {
        let foregroundOverlay = overlayTemplate.copy() as! SKSpriteNode
        lastOverlayPosition.y = lastOverlayPosition.y + (lastOverlayHeight + (foregroundOverlay.size.height / 2.0))
        lastOverlayHeight = foregroundOverlay.size.height / 2.0
        foregroundOverlay.position = lastOverlayPosition
        if flipX == true {
            foregroundOverlay.xScale = -1.0
        }
        fgNode.addChild(foregroundOverlay)
    }
    
    func addRandomForegroundOverlay() {
        let overlaySprite: SKSpriteNode!
        let platformPercentage = 60
        let breakablePlatformsPercentage = 25
        let specialCoinsPercentage = 25
        
        
        if Int.random(min: 1, max: 100) <= platformPercentage {
            if Int.random(min: 1, max: 100) <= breakablePlatformsPercentage {
                //breakable platforms
                switch Int.random(min: 1, max: 3) {
                case 1:
                    overlaySprite = breakArrow
                case 2:
                    overlaySprite = breakDiagonal
                case 3:
                    overlaySprite = break5Across
                default:
                    overlaySprite = break5Across
                }
            } else {
                // non breakable platforms
                switch Int.random(min: 1, max: 3) {
                case 1:
                    overlaySprite = platformArrow
                case 2:
                    overlaySprite = platformDiagonal
                case 3:
                    overlaySprite = platform5Across
                default:
                    overlaySprite = platform5Across
                }
            }
        } else {
            if Int.random(min: 1, max: 100) <= specialCoinsPercentage {
                //special coins
                switch Int.random(min: 1, max: 4) {
                case 1:
                    overlaySprite = coinSCross
                case 2:
                    overlaySprite = coinSDiagonal
                case 3:
                    overlaySprite = coinS5Across
                case 4:
                    overlaySprite = coinSArrow
                default:
                    overlaySprite = coinS5Across
                }
            } else {
                // regular coins
                switch Int.random(min: 1, max: 4) {
                case 1:
                    overlaySprite = coinCross
                case 2:
                    overlaySprite = coinDiagonal
                case 3:
                    overlaySprite = coin5Across
                case 4:
                    overlaySprite = coinArrow
                default:
                    overlaySprite = coin5Across
                }
            }
        }
        createForegroundOverlay(overlaySprite, flipX: false)
    }
    
    func createBackgroundOverlay() {
        let backgroundOverlay = backgroundOverlayTemplate.copy() as! SKNode
        backgroundOverlay.position = CGPoint(x: 0.0, y: levelPositionY)
        bgNode.addChild(backgroundOverlay)
        levelPositionY += backgroundOverlayHeight
    }
    
    // MARK: - Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState == .waitingForTap {
            bombDrop()
        } else if gameState == .gameOver {
            let newScene = GameScene(fileNamed: "GameScene")
            newScene!.scaleMode = .aspectFill
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(newScene!, transition: reveal)
        }
    }
    
    func bombDrop() {
        gameState = .waitingForBomb
        
        let scale = SKAction.scale(to: 0, duration: 0.4)
        fgNode.childNode(withName: "Title")!.run(scale)
        fgNode.childNode(withName: "Ready")!.run(SKAction.sequence([SKAction.wait(forDuration: 0.2),scale]))
        
        let scaleUp = SKAction.scale(to: 1.25, duration: 0.25)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.25)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        let repeatSeq = SKAction.repeatForever(sequence)
        fgNode.childNode(withName: "Bomb")!.run(SKAction.unhide())
        fgNode.childNode(withName: "Bomb")!.run(repeatSeq)
        run(SKAction.sequence([SKAction.wait(forDuration: 2.0),SKAction.run(startGame)]))
    }
    
    func startGame() {
        let bomb = fgNode.childNode(withName: "Bomb")!
        
        let bombBlast = explosion(intensity: 2.0)
        bombBlast.position = bomb.position
        fgNode.addChild(bombBlast)
        bomb.removeFromParent()
        gameState = .playing
        player.physicsBody!.isDynamic = true
        superBoostPlayer()
    }
    
    func setupPlayerVelocity(_ amount: CGFloat) {
        let gain: CGFloat = 2.5
        player.physicsBody!.velocity.dy = max(player.physicsBody!.velocity.dy, amount * gain)
    }
    
    func jumpPlayer() {
        setupPlayerVelocity(650)
    }
    
    func boostPlayer() {
        setupPlayerVelocity(1200)
    }
    
    func superBoostPlayer() {
        setupPlayerVelocity(1700)
    }
    

    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == PC.Player ? contact.bodyB : contact.bodyA
        
        switch other.categoryBitMask {
        case PC.CoinNormal:
            if let coin = other.node as? SKSpriteNode {
                coin.removeFromParent()
                jumpPlayer()
            }
        case PC.CoinSpecial:
            if let coin = other.node as? SKSpriteNode {
                superBoostPlayer()
                coin.removeFromParent()
            }
        case PC.PlatformNormal:
            if let _ = other.node as? SKSpriteNode {
                if player.physicsBody!.velocity.dy < 0 {
                    jumpPlayer()
                }
            }
        case PC.PlatformBreakable:
            if let breakablePlatform = other.node as? SKSpriteNode {
                if player.physicsBody!.velocity.dy < 0 {
                    breakablePlatform.removeFromParent()
                    jumpPlayer()
                }
            }
        default:
            break
        }
    }
  
    func sceneCropAmount() -> CGFloat {
        guard let view = self.view else {
            return 0
        }
        let scale = view.bounds.size.height / self.size.height
        let scaledWidth = self.size.width * scale
        let scaledOverlap = scaledWidth - view.bounds.size.width
        return scaledOverlap / scale
    }
    
    func updatePlayer() {
        player.physicsBody?.velocity.dx = xAcceleration * 4000.0
        
        var playerPosition = convert(player.position, from: fgNode)
        let leftLimit = sceneCropAmount()/2 - player.size.width/2
        let rightLimit = size.width - sceneCropAmount()/2 + player.size.width/2
        if playerPosition.x < leftLimit {
            playerPosition = convert(CGPoint(x: rightLimit, y: 0.0), to: fgNode)
            player.position.x = playerPosition.x
        } else if playerPosition.x > rightLimit {
            playerPosition = convert(CGPoint(x: leftLimit, y: 0.0), to: fgNode)
            player.position.x = playerPosition.x
        }
        
        if player.physicsBody!.velocity.dy < CGFloat(0.0) && playerState != .fall {
            playerState = .fall
        } else if player.physicsBody!.velocity.dy > CGFloat(0.0) && playerState != .jump {
            playerState = .jump
        }
        
        if playerState == .jump {
            if abs(player.physicsBody!.velocity.dx) > 100.0 {
                if player.physicsBody!.velocity.dx > 0 {
                    runPlayerAnimation(playerAnimationSteerRight)
                } else {
                    runPlayerAnimation(playerAnimationSteerLeft)
                }
            } else {
                runPlayerAnimation(playerAnimationJump)
            }
        } else if playerState == .fall {
            runPlayerAnimation(playerAnimationFall)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTimeInterval > 0 {
            deltaTime = currentTime - lastUpdateTimeInterval
        } else {
            deltaTime = 0
        }
        
        lastUpdateTimeInterval = currentTime
        
        if isPaused {
            return
        }
        
        if gameState == .playing {
            updateCamera()
            updateLevel()
            updatePlayer()
            updateLava(deltaTime)
            updateCollisionLava()
        }
        
        
        
        
        
    }
    
    func updateCamera() {
        let cameraTarget = convert(player.position, from: fgNode)
        var targetPositionY = cameraTarget.y - (size.height * 0.10)
        
        let lavaPos = convert(lava.position, from: fgNode)
        targetPositionY = max(targetPositionY, lavaPos.y)
        
        let diff = targetPositionY - camera!.position.y
        let cameraLagFactor = CGFloat(0.2)
        let lagDiff = diff * cameraLagFactor
        let newCameraPositionY = camera!.position.y + lagDiff
        
        camera!.position.y = newCameraPositionY
    }
    
    func updateLava(_ dt: TimeInterval) {
        let bottomOfScreenY = camera!.position.y - (size.height / 2)
        
        let bottomOfScreenYFg = convert(CGPoint(x: 0, y: bottomOfScreenY), to: fgNode).y
        
        let lavaVelocityY = CGFloat(120)
        let lavaStep = lavaVelocityY * CGFloat(dt)
        
        var newLavaPositionY = lava.position.y + lavaStep
        
        newLavaPositionY = max(newLavaPositionY, (bottomOfScreenYFg - 125.0))
        
        lava.position.y = newLavaPositionY
        
    }
    
    func updateCollisionLava() {
        if player.position.y < lava.position.y + 180 {
            if playerState != .lava {
                playerState = .lava
                let smokeTrail = addTrail(name: "SmokeTrail")
                run(SKAction.sequence([SKAction.wait(forDuration: 3.0),SKAction.run() {self.removeTrail(trail: smokeTrail)}]))
            }

            boostPlayer()
            lives -= 1
            if lives <= 0 {
                gameOver()
            }
        }
    }
    
    func updateLevel() {
        let cameraPos = camera!.position
        if cameraPos.y > levelPositionY - (size.height * 0.55) {
            createBackgroundOverlay()
            while lastOverlayPosition.y < levelPositionY {
                addRandomForegroundOverlay()
            }
        }
    }
    
    func gameOver() {
        gameState = .gameOver
        playerState = .dead
        
        physicsWorld.contactDelegate = nil
        player.physicsBody?.isDynamic = false
        
        let moveUp = SKAction.moveBy(x: 0.0, y: size.height/2.0, duration: 0.5)
        moveUp.timingMode = .easeOut
        let moveDown = SKAction.moveBy(x: 0.0, y: -(size.height * 1.5), duration: 1.0)
        moveDown.timingMode = .easeIn
        player.run(SKAction.sequence([moveUp,moveDown]))
        
        let gameOverSprite = SKSpriteNode(imageNamed: "GameOver")
        gameOverSprite.position = camera!.position
        gameOverSprite.zPosition = 10
        addChild(gameOverSprite)
    }
    
    func setupLava() {
        lava = fgNode.childNode(withName: "Lava") as! SKSpriteNode
        let emitter = SKEmitterNode(fileNamed: "Lava.sks")!
        
        emitter.particlePositionRange = CGVector(dx: size.width * 1.25, dy: 0.0)
        emitter.advanceSimulationTime(3.0)
        lava.addChild(emitter)
        
    }
    
    // MARK: - Particles
    
    func explosion(intensity: CGFloat) -> SKEmitterNode {
        let emitter = SKEmitterNode()
        let particleTexture = SKTexture(imageNamed: "spark")
        emitter.zPosition = 2
        emitter.particleTexture = particleTexture
        emitter.particleBirthRate = 4000 * intensity
        emitter.numParticlesToEmit = Int(400 * intensity)
        emitter.particleLifetime = 2.0
        emitter.emissionAngle = CGFloat(90).degreesToRadians()
        emitter.emissionAngleRange = CGFloat(360).degreesToRadians()
        emitter.particleSpeed = 600*intensity
        emitter.particleSpeedRange = 1000*intensity
        emitter.particleAlpha = 1.0
        emitter.particleAlphaRange = 0.25
        emitter.particleScale = 1.2
        emitter.particleScaleRange = 2.0
        emitter.particleScaleSpeed = -1.5
        emitter.particleColorBlendFactor = 1
        emitter.particleBlendMode = SKBlendMode.add
        emitter.run(SKAction.removeFromParentAfterDelay(2.0))
        
        let sequence = SKKeyframeSequence(capacity: 5)
        sequence.addKeyframeValue(SKColor.white, time: 0)
        sequence.addKeyframeValue(SKColor.yellow, time: 0.10)
        sequence.addKeyframeValue(SKColor.orange, time: 0.15)
        sequence.addKeyframeValue(SKColor.red, time: 0.75)
        sequence.addKeyframeValue(SKColor.black, time: 0.95)
        emitter.particleColorSequence = sequence
        
        return emitter
    }
    
    func addTrail(name: String) -> SKEmitterNode {
        let trail = SKEmitterNode(fileNamed: name)!
        trail.zPosition = 1
        trail.targetNode = fgNode
        player.addChild(trail)
        return trail
    }
    
    func removeTrail(trail: SKEmitterNode) {
        trail.numParticlesToEmit = 1
        trail.run(SKAction.removeFromParentAfterDelay(1.0))
    }
    
    func setupAnimationWithPrefix(_ prefix: String ,start: Int, end: Int, timePerFrame: TimeInterval) -> SKAction {
        
        var textures = [SKTexture]()
        
        for i in start...end {
            textures.append(SKTexture(imageNamed: "\(prefix)\(i)"))
        }
        
        return SKAction.animate(with: textures, timePerFrame: timePerFrame)
    }
    
    func runPlayerAnimation(_ animation: SKAction) {
        if currentPlayerAnimation == nil || currentPlayerAnimation != animation {
            player.removeAction(forKey: "playerAnimation")
            player.run(animation, withKey: "playerAnimation")
            currentPlayerAnimation = animation
        }
    }
    
    func screenShakeAmt(_ amt: CGFloat) {
        let worldNode = childNode(withName: "World")!
        worldNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        worldNode.removeAction(forKey: "shake")
        let amount = CGPoint(x: 0, y: -(amt * gameGain))
        let action = SKAction.screenShakeWithNode(worldNode, amount: amount, oscillations: 10, duration: 20.0)
        worldNode.run(action, withKey: "shake")
    }
    
}

//
//  GameScene.swift
//  CircuitRacer
//
//  Created by James Small on 9/24/15.
//  Copyright (c) 2015 SmallJames. All rights reserved.
//

import SpriteKit

enum CarType: Int {
    case Yellow, Blue, Red
}

enum LevelType: Int {
    case Easy, Medium, Hard
}

class GameScene: SKScene, AnalogControlPositionChange {
  
    var carType: CarType!
    var levelType: LevelType!
    private var timeInSeconds = 0
    private var numberOfLaps = 0
    private var maxSpeed = 0
    private var box1: SKSpriteNode!, box2: SKSpriteNode!
    private var laps: SKLabelNode!, time: SKLabelNode!
    private var trackCenter = CGPoint.zero
    private var nextProgressAngle = M_PI
    private var previousTimeInterval: CFTimeInterval = 0
    typealias GameOverBlock = (didWin: Bool) -> Void
    var gameOverBlock: GameOverBlock?
    
    private func loadObstacles() {
        box1 = self.childNodeWithName("box_1") as! SKSpriteNode
        box2 = self.childNodeWithName("box_2") as! SKSpriteNode
    }
    
    private func loadLevel() {
        let filePath = NSBundle.mainBundle().pathForResource("LevelDetails", ofType: "plist")
        
        let levels = NSArray(contentsOfFile: filePath!)!
        let levelData = levels[levelType.rawValue] as! NSDictionary
        timeInSeconds = levelData["time"] as! Int
        numberOfLaps = levelData["laps"] as! Int
    }
    
    private func addLabels() {
        laps = self.childNodeWithName("laps_label") as! SKLabelNode
        time = self.childNodeWithName("time_left_label") as! SKLabelNode
        
        laps.text = "Laps: \(numberOfLaps)"
        time.text = "Time: \(timeInSeconds)"
    }
    
    override func didMoveToView(view: SKView) {
        initializeGame()
    }
    
    override func update(currentTime: NSTimeInterval) {
        let carPosition = childNodeWithName("car")!.position
        let vector = carPosition - trackCenter
        let progressAngle = Double(vector.angle) + M_PI
        
        if progressAngle > nextProgressAngle && (progressAngle - nextProgressAngle) < M_PI_4 {
            //2
            nextProgressAngle += M_PI_2
            
            //3
            if nextProgressAngle >= (2 * M_PI) {
                nextProgressAngle = 0
            }
            
            //4
            if fabs(nextProgressAngle - M_PI) < Double(FLT_EPSILON) {
                // lap completed
                numberOfLaps -= 1
                laps.text = "Laps: \(numberOfLaps)"
            }
        }
        
        if previousTimeInterval == 0 {
            previousTimeInterval = currentTime
        }
        
        if paused {
            previousTimeInterval = currentTime
        }
        
        if currentTime - previousTimeInterval > 1 {
            timeInSeconds -= Int(currentTime - previousTimeInterval)
            previousTimeInterval = currentTime
            if timeInSeconds >= 0 {
                time.text = "Time: \(timeInSeconds)"
            }
        }
        
        if timeInSeconds < 0 || numberOfLaps == 0 {
            paused = true
            
            if let block = gameOverBlock {
                block(didWin: numberOfLaps == 0)
            }
        }
    }
    
    private func initializeGame() {
        loadLevel()
        loadTrackTexture()
        loadCarTexture()
        setupPhysicsBodies()
        loadObstacles()
        addLabels()
        maxSpeed = 500 * (2 + carType.rawValue)
        trackCenter = childNodeWithName("track")!.position
    }
    
    private func loadCarTexture() {
        let car = self.childNodeWithName("car") as! SKSpriteNode
        car.texture = SKTexture(imageNamed: "car_\(carType.rawValue + 1)")
    }

    private func loadTrackTexture() {
        let track = self.childNodeWithName("track") as! SKSpriteNode
        track.texture = SKTexture(imageNamed: "track_\(levelType.rawValue + 1)")
    }
    
    private func setupPhysicsBodies() {
        let innerBoundary = SKNode()
        innerBoundary.position = childNodeWithName("track")!.position
        addChild(innerBoundary)
        
        innerBoundary.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(720, 480))
        innerBoundary.physicsBody!.dynamic = false
        
        let trackFrame = CGRectInset(self.childNodeWithName("track")!.frame,200,0)
        let maxAspectRatio: CGFloat = 3.0/2.0 // iPhone 4
        let maxAspectRatioHeight = trackFrame.size.width / maxAspectRatio
        let playableMarginY: CGFloat = (trackFrame.size.height - maxAspectRatioHeight)/2
        
        let playableMarginX: CGFloat = (frame.size.width - trackFrame.size.width)/2
        
        let playableRect = CGRect(x: playableMarginX, y: playableMarginY, width: trackFrame.size.width, height: trackFrame.size.height - playableMarginY*2)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
        
        
    }
    
    
 
    func analogControlPositionChanged(analogControl: AnalogControl, position: CGPoint) {
        let car = self.childNodeWithName("car") as! SKSpriteNode
        
        car.physicsBody!.velocity = CGVector(dx: position.x * CGFloat(maxSpeed), dy: -position.y * CGFloat(maxSpeed))
        
        if position != CGPointZero {
            car.zRotation = CGPoint(x: position.x, y: -position.y).angle
        }
    }


}

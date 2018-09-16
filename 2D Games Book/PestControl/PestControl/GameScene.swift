/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit

extension GameScene : SKPhysicsContactDelegate {
  func remove(bug: Bug) {
    bug.removeFromParent()
    background.addChild(bug)
    bug.die()
    hud.updateBugCount(count: bugsNode.children.count)
  }
}

// MARK: - Notifications
extension GameScene {
  func applicationDidBecomeActive() {
    if gameState == .pause {
      gameState = .reload
    }
  }
  
  func applicationWillResignActive() {
    isPaused = true
    if gameState != .lose {
      gameState = .pause
    }
  }
  
  func applicationDidEnterBackground() {
    if gameState != .lose {
      saveGame()
    }
  }
  
  func addObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: .UIApplicationWillResignActive, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
  }
}

// MARK: - Saving Games
extension GameScene {
  func saveGame() {
    let fileManager = FileManager.default
    guard let directory = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first else { return }
    
    let saveURL = directory.appendingPathComponent("SavedGames")
    
    do {
      try fileManager.createDirectory(atPath: saveURL.path, withIntermediateDirectories: true, attributes: nil)
      
    } catch let error as NSError {
      fatalError("Failed to create directory: \(error.debugDescription)")
    }
    
    let fileURL = saveURL.appendingPathComponent("saved-game")
    print("* Saving:  \(fileURL.path)")
    
    NSKeyedArchiver.archiveRootObject(self, toFile: fileURL.path)
  }
  
  override func encode(with aCoder: NSCoder) {
    aCoder.encode(firebugCount, forKey: "Scene.firebugCount")
    aCoder.encode(elapsedTime, forKey: "Scene.elapsedTime")
    aCoder.encode(gameState.rawValue, forKey: "Scene.gameState")
    aCoder.encode(currentLevel, forKey: "Scene.currentLevel")
    super.encode(with: aCoder)
  }
  
  class func loadGame() -> SKScene? {
    var scene: SKScene?
    
    let fileManager = FileManager.default
    guard let directory = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first else { return nil }
    
    let url = directory.appendingPathComponent("SavedGames/saved-game")
    
    if FileManager.default.fileExists(atPath: url.path) {
      scene = NSKeyedUnarchiver.unarchiveObject(withFile: url.path) as? GameScene
      _ = try? fileManager.removeItem(at: url)
    }
    
    return scene
  }
}

class GameScene: SKScene {
  
  var background: SKTileMapNode!
  var obstaclesTileMap: SKTileMapNode?
  var player = Player()
  var bugsNode = SKNode()
  var firebugCount: Int = 0
  var bugsprayTileMap: SKTileMapNode?
  var hud = HUD()
  var timeLimit: Int = 10
  var elapsedTime: Int = 0
  var startTime: Int?
  var currentLevel: Int = 1
  
  var gameState: GameState = .initial {
    didSet {
      hud.updateGameState(from: oldValue, to: gameState)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    background = childNode(withName: "background") as! SKTileMapNode
    obstaclesTileMap = childNode(withName: "obstacles") as? SKTileMapNode
    
    if let timeLimit = userData?.object(forKey: "timeLimit") as? Int {
      self.timeLimit = timeLimit
    }
    
    
    let savedGameState = aDecoder.decodeInteger(forKey: "Scene.gameState")
    if let gameState = GameState(rawValue: savedGameState), gameState == .pause {
      self.gameState = gameState
      firebugCount = aDecoder.decodeInteger(forKey: "Scene.firebugCount")
      elapsedTime = aDecoder.decodeInteger(forKey: "Scene.elapsedTime")
      currentLevel = aDecoder.decodeInteger(forKey: "Scene.currentLevel")
      
      player = childNode(withName: "Player") as! Player
      hud = camera!.childNode(withName: "HUD") as! HUD
      bugsNode = childNode(withName: "Bugs")!
      bugsprayTileMap = childNode(withName: "Bugsspray") as? SKTileMapNode
 
    }
    
    addObservers()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func didMove(to view: SKView) {
    
    if gameState == .initial {
      addChild(player)      
      setupWorldPhysics()
      createBugs()
      setupObstaclePhysics()
      if firebugCount > 0 {
        createBugspray(quantity: firebugCount + 10)
      }
      setupHUD()
      gameState = .start
    }
    setupCamera()
  }
  
  override func update(_ currentTime: TimeInterval) {
    
    if gameState != .play {
      isPaused = true
      return
    }
    
    if !player.hasBugspray {
      updateBugspray()
    }
    advanceBreakableTile(locatedAt: player.position)
    updateHUD(currentTime: currentTime)
    checkEndGame()
  }
  
  func setupHUD() {
    camera?.addChild(hud)
    hud.addTimer(time: timeLimit)
    hud.addBugCount(with: bugsNode.children.count)
  }
  
  func tile(in tileMap: SKTileMapNode, at coordinates: TileCoordinates) -> SKTileDefinition? {
    return tileMap.tileDefinition(atColumn: coordinates.column, row: coordinates.row)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {return}
    
    switch gameState {
    case .start:
      gameState = .play
      isPaused = false
      startTime = nil
      elapsedTime = 0
    case .play:
       player.move(target: touch.location(in: self))
    case .win:
       transitionToScene(level: currentLevel + 1)
    case .lose:
      transitionToScene(level: 1)
    case .reload:
      if let touchedNode = atPoint(touch.location(in: self)) as? SKLabelNode {
        if touchedNode.name == HUDMessages.yes {
          isPaused = false
          startTime = nil
          gameState = .play
        } else if touchedNode.name == HUDMessages.no {
          transitionToScene(level: 1)
        }
      }
    default:
      break
    }
    
   
  }
  
  func setupCamera() {
    guard let camera = camera, let view = view else { return }
    
    let zeroDistance = SKRange(constantValue: 0)
    let playerConstraint = SKConstraint.distance(zeroDistance, to: player)
    
    let xInset = min(view.bounds.width/2 * camera.xScale, background.frame.width/2)
    let yInset = min(view.bounds.height/2 * camera.yScale, background.frame.height/2)
    
    let constraintRect = background.frame.insetBy(dx: xInset, dy: yInset)
    
    let xRange = SKRange(lowerLimit: constraintRect.minX, upperLimit: constraintRect.maxX)
    let yRange = SKRange(lowerLimit: constraintRect.minY, upperLimit: constraintRect.maxY)
    
    let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
    edgeConstraint.referenceNode = background
    
    
    camera.constraints = [playerConstraint, edgeConstraint]
  }
  
  func setupWorldPhysics() {
    background.physicsBody = SKPhysicsBody(edgeLoopFrom: background.frame)
    background.physicsBody?.categoryBitMask = PC.Edge
    physicsWorld.contactDelegate = self
  }
  
  func createBugs() {
    guard let bugsMap = childNode(withName: "bugs") as? SKTileMapNode else {return}
    
    for row in 0..<bugsMap.numberOfRows {
      for column in 0..<bugsMap.numberOfColumns {
        guard let tile = tile(in: bugsMap, at: (column, row)) else {continue}
        
        let bug: Bug
        
        if tile.userData?.object(forKey: "firebug") != nil {
          bug = Firebug()
          firebugCount += 1
        } else {
          bug = Bug()
        }
        bug.position = bugsMap.centerOfTile(atColumn: column, row: row)
        bugsNode.addChild(bug)
        bug.moveBug()
      }
    }
    bugsNode.name = "Bugs"
    addChild(bugsNode)
    
    bugsMap.removeFromParent()
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    let other = contact.bodyA.categoryBitMask == PC.Player ? contact.bodyB : contact.bodyA
    
    switch other.categoryBitMask {
    case PC.Bug:
      if let bug = other.node as? Bug {
        remove(bug: bug)
      }
    case PC.FireBug:
      if player.hasBugspray {
        if let fireBug = other.node as? Firebug {
          remove(bug: fireBug)
          player.hasBugspray = false
        }
      }
    case PC.Breakable:
      if let obstacleNode = other.node {
        advanceBreakableTile(locatedAt: obstacleNode.position)
        obstacleNode.removeFromParent()
      }
    default:
      break
    }
    
    if let physicsBody = player.physicsBody {
      if physicsBody.velocity.length() > 0 {
        player.checkDirection() 
      }
    }
  }
  
  func setupObstaclePhysics() {
    guard let obstaclesTileMap = obstaclesTileMap else { return }

    for row in 0..<obstaclesTileMap.numberOfRows {
      for column in 0..<obstaclesTileMap.numberOfColumns {
        guard let tile = tile(in: obstaclesTileMap, at: (column, row)) else { continue }
        guard tile.userData?.object(forKey: "obstacle") != nil else { continue }
        
        let node = SKNode()
        node.physicsBody = SKPhysicsBody(rectangleOf: tile.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.friction = 0
        node.physicsBody?.categoryBitMask = PC.Breakable
        
        node.position = obstaclesTileMap.centerOfTile(atColumn: column, row: row)
        obstaclesTileMap.addChild(node)
        

      }
    }
  }
  
  func createBugspray(quantity: Int) {
    let tile = SKTileDefinition(texture: SKTexture(pixelImageNamed: "bugspray"))
    let tilerule = SKTileGroupRule(adjacency: SKTileAdjacencyMask.adjacencyAll, tileDefinitions: [tile])
    let tilegroup = SKTileGroup(rules: [tilerule])
    let tileSet = SKTileSet(tileGroups: [tilegroup])
    
    let columns = background.numberOfColumns
    let rows = background.numberOfRows
    
    bugsprayTileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tile.size)
    
    for _ in 1...quantity {
      let column = Int.random(min: 0, max: columns - 1)
      let row = Int.random(min: 0, max: rows - 1)
      bugsprayTileMap?.setTileGroup(tilegroup, forColumn: column, row: row)
    }
    
    bugsprayTileMap?.name = "Bugspray"
    addChild(bugsprayTileMap!)
    
  }
  
  func tileCoordinates(in tileMap: SKTileMapNode, at position: CGPoint) -> TileCoordinates {
    let column = tileMap.tileColumnIndex(fromPosition: position)
    let row = tileMap.tileRowIndex(fromPosition: position)
    return (column, row)
  }
  
  func updateBugspray() {
    guard let bugsprayTileMap = bugsprayTileMap else { return }
    let (column, row) = tileCoordinates(in: bugsprayTileMap, at: player.position)
    
    if tile(in: bugsprayTileMap, at: (column, row)) != nil {
      bugsprayTileMap.setTileGroup(nil, forColumn: column, row: row)
      player.hasBugspray = true
    }
  }
  
  func tileGroupForName(tileSet: SKTileSet, name: String) -> SKTileGroup? {
    let tileGroup = tileSet.tileGroups.filter { $0.name == name}.first
    return tileGroup
  }
  
  func advanceBreakableTile(locatedAt nodePosition: CGPoint) {
    guard let obstaclesTileMap = obstaclesTileMap else { return }
    
    let (column, row) = tileCoordinates(in: obstaclesTileMap, at: nodePosition)
    
    let obstacle = tile(in: obstaclesTileMap, at: (column, row))
    
    guard let nextTileGroupName = obstacle?.userData?.object(forKey: "breakable") as? String else { return }
    
    if let nextTileGroup = tileGroupForName(tileSet: obstaclesTileMap.tileSet, name: nextTileGroupName) {
      obstaclesTileMap.setTileGroup(nextTileGroup, forColumn: column, row: row)
    }
  }
  
  func updateHUD(currentTime: TimeInterval) {
    if let startTime = startTime {
      elapsedTime = Int(currentTime) - startTime
    } else {
      startTime = Int(currentTime) - elapsedTime
    }
    hud.updateTimer(time: timeLimit - elapsedTime)
  }
  
  func checkEndGame() {
    if bugsNode.children.count == 0 {
      player.physicsBody?.linearDamping = 1
      gameState = .win
    } else if timeLimit - elapsedTime <= 0 {
      player.physicsBody?.linearDamping = 1
      gameState = .lose
    }
    
  }
  
  func transitionToScene(level: Int) {
    guard let newScene = SKScene(fileNamed: "Level\(level)") as? GameScene else {
      fatalError("Level: \(level) not found")
    }
    
    newScene.currentLevel = level
    view!.presentScene(newScene, transition: SKTransition.flipVertical(withDuration: 0.5))
  }
  
  
}

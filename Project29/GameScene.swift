//
//  GameScene.swift
//  Project29
//
//  Created by Macbook on 18/07/2017.
//  Copyright © 2017 Chappy-App. All rights reserved.
//  Remember to set height and width 1024 x 768 and archor points 0 x 0 in GameScene.sks

import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
  
  case banana = 1
  case building = 2
  case player = 4
  
}




class GameScene: SKScene, SKPhysicsContactDelegate {
  
  var buildings = [BuildingNode]()
  
  weak var viewController: GameViewController!
  
  var player1: SKSpriteNode!
  var player2: SKSpriteNode!
  var banana: SKSpriteNode!
  
  var currentPlayer = 1

  
  override func didMove(to view: SKView) {
    backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
    
    physicsWorld.contactDelegate = self
    
    createBuildings()
    createPlayers()
    
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody
    
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    
    } else {
      
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }
    
    if let firstNode = firstBody.node {
      
      if let secondNode = secondBody.node {
      
        if firstNode.name == "banana" && secondNode.name == "building" {
          bananaHit(building: secondNode as! BuildingNode, atPoint: contact.contactPoint)
      }
        
        if firstNode.name == "banana" && secondNode.name == "player" {
          destroy(player: player1)
          
        }
        
        if firstNode.name == "banana" && secondNode.name == "player2" {
          destroy(player: player2)
          
        }
      }
    }
  }
  
  func destroy(player: SKSpriteNode) {
    
    let explosion = SKEmitterNode(fileNamed: "hitPlayer")!
    explosion.position = player.position
    addChild(explosion)
    
    player.removeFromParent()
    banana?.removeFromParent()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
      let newGame = GameScene(size: self.size)
      newGame.viewController = self.viewController
      self.viewController.currentGame = newGame
      
      self.changePlayer()
      newGame.currentPlayer = self.currentPlayer
      
      let transition = SKTransition.doorway(withDuration: 1.5)
      self.view?.presentScene(newGame, transition: transition)
      
    }
    
}
  
  func changePlayer() {
    
    if currentPlayer == 1 {
      currentPlayer = 2
      
    } else {
      
      currentPlayer = 1
    }
    
    viewController.activatePlayer(number: currentPlayer)
    
  }
  
  func bananaHit(building: BuildingNode, atPoint contactPoint: CGPoint) {
    
    let buildingLocation = convert(contactPoint, to: building)
    building.hitAt(point: buildingLocation)
    
    let explosion = SKEmitterNode(fileNamed: "hitBuilding")!
    explosion.position = contactPoint
    addChild(explosion)
    
    banana.name = ""
    banana?.removeFromParent()
    banana = nil
    
    changePlayer()
 
  }
  
  func launch(angle: Int, velocity: Int) {
    
   // 1. Figure out how hard to throw the banana, we accept a velocity parameter but I'll be dividing that by 10.
    
    let speed = Double(velocity) / 10.0
    
  // 2. convert the input angle to radians
    
    let radians = deg2rad(degrees: angle)
    
  // 3. if somehow there's a banana already, we remove it then create a new one using circle physics
    
    if banana != nil {
      
      banana.removeFromParent()
      banana = nil
    
    }
    
   
    banana = SKSpriteNode(imageNamed: "banana")
    banana.name = "banana"
    banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
    banana.physicsBody!.categoryBitMask = CollisionTypes.banana.rawValue
    banana.physicsBody!.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
    banana.physicsBody!.contactTestBitMask = CollisionTypes.banana.rawValue | CollisionTypes.player.rawValue
    banana.physicsBody!.usesPreciseCollisionDetection = true
    addChild(banana)
    
    if currentPlayer == 1 {
      
  //4. if player1 was throwing we position it up to the left and give it some spin

    banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
    banana.physicsBody!.angularVelocity = -20
      
  // 5. Animate player1 throwing their arm up then putting it down again
      let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
      let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
      let pause = SKAction.wait(forDuration: 0.15)
      let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
      player1.run(sequence)
  
  // 6. made the banana move in the correct direction
      let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
      banana.physicsBody?.applyImpulse(impulse)
      
    } else {
      
  // 7. then player 2
      
      banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
      banana.physicsBody!.angularVelocity = 20
      
      let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
      let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
      let pause = SKAction.wait(forDuration: 0.15)
      let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
      player2.run(sequence)
      
      let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
      banana.physicsBody?.applyImpulse(impulse)

    }
  }
  
  // function converting degrees into radians
  
  func deg2rad(degrees: Int) -> Double {
    return Double(degrees) * Double.pi / 180.0
  }
  
  func createBuildings() {
    
    var currentX: CGFloat = -15
    
    while currentX < 1024 {
      
      let size = CGSize(width: RandomInt(min: 2, max: 4) * 40, height: RandomInt(min: 300, max: 600))
      
      currentX += size.width + 2
      
      let building = BuildingNode(color: UIColor.red, size: size)
      building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
      building.setup()
      addChild(building)
      
      buildings.append(building)
      
      }
  }
  
  func createPlayers() {
    
    player1 = SKSpriteNode(imageNamed: "player")
    player1.name = "player1"
    player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
    player1.physicsBody!.categoryBitMask = CollisionTypes.player.rawValue
    player1.physicsBody!.collisionBitMask = CollisionTypes.banana.rawValue
    player1.physicsBody!.contactTestBitMask = CollisionTypes.banana.rawValue
    player1.physicsBody!.isDynamic = false
    
    let playing1Building = buildings[1]
    player1.position = CGPoint(x: playing1Building.position.x, y: playing1Building.position.y + ((playing1Building.size.height + player1.size.height) / 2))
    addChild(player1)
    
    
    player2 = SKSpriteNode(imageNamed: "player")
    player2.name = "player2"
    player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
    player2.physicsBody!.categoryBitMask = CollisionTypes.player.rawValue
    player2.physicsBody!.collisionBitMask = CollisionTypes.banana.rawValue
    player2.physicsBody!.contactTestBitMask = CollisionTypes.banana.rawValue
    player2.physicsBody!.isDynamic = false
    
    let playing2Building = buildings[buildings.count - 2]
    player2.position = CGPoint(x: playing2Building.position.x, y: playing2Building.position.y + ((playing2Building.size.height + player2.size.height) / 2))
    addChild(player2)
  
     }
  
  override func update(_ currentTime: TimeInterval) {
    if banana != nil {
      if banana.position.y < -1000 {
        banana.removeFromParent()
        banana = nil
        
        changePlayer()
      }
    }
  }
 }

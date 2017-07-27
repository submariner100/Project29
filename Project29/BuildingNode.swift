//
//  BuildingNode.swift
//  Project29
//
//  Created by Macbook on 18/07/2017.
//  Copyright © 2017 Chappy-App. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

var currentImage: UIImage!

class BuildingNode: SKSpriteNode {
  
  func setup() {
    
    name = "building"
    
    currentImage = drawBuilding(size: size)
    texture = SKTexture(image: currentImage)
    
    configurePhysics()

   }
  
  func configurePhysics() {
    
    physicsBody = SKPhysicsBody(texture: texture!, size: size)
    physicsBody!.isDynamic = false
    physicsBody!.categoryBitMask = CollisionTypes.building.rawValue
    physicsBody!.contactTestBitMask = CollisionTypes.banana.rawValue
    
  }
  
  func drawBuilding(size: CGSize) -> UIImage {
    
    let renderer = UIGraphicsImageRenderer(size: size)
    let img = renderer.image { ctx in
      
      let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
      var color: UIColor
      
      switch GKRandomSource.sharedRandom().nextInt(upperBound: 3) {
      case 0:
        color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
      case 1:
        color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
      default:
        color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
        
      }
      
      ctx.cgContext.setFillColor(color.cgColor)
      ctx.cgContext.addRect(rectangle)
      ctx.cgContext.drawPath(using: .fill)
      
      let lightColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
      let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
      
      for row in stride(from: 10, to: Int(size.height - 10), by: 40) {
        for col in stride(from: 10, to: Int(size.width - 10), by: 40) {
          if RandomInt(min: 0, max: 1) == 0 {
            
            ctx.cgContext.setFillColor(lightColor.cgColor)
            
          } else {
            
            ctx.cgContext.setFillColor(lightOffColor.cgColor)
            
          }
          
          ctx.cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
        }
      }
    }
    
      return img
    }
  
  func hitAt(point: CGPoint) {
    
    let convertPoint = CGPoint(x: point.x + size.width / 2.0, y: abs(point.y - (size.height / 2.0)))
    
    let renderer = UIGraphicsImageRenderer(size: size)
    let img = renderer.image { ctx in
      currentImage.draw(at: CGPoint(x: 0, y: 0))
      
      ctx.cgContext.addEllipse(in: CGRect(x: convertPoint.x - 32, y: convertPoint.y - 32, width: 64, height: 64))
      ctx.cgContext.setBlendMode(.clear)
      ctx.cgContext.drawPath(using: .fill)
      
    }
    
    texture = SKTexture(image: img)
    currentImage = img
    
    configurePhysics()
  }
  

}

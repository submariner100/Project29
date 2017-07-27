//
//  GameViewController.swift
//  Project29
//
//  Created by Macbook on 18/07/2017.
//  Copyright © 2017 Chappy-App. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
  @IBOutlet weak var angleSlider: UISlider!
  @IBOutlet weak var angleLabel: UILabel!
  @IBOutlet weak var velocitySlider: UISlider!
  @IBOutlet weak var velocityLabel: UILabel!
  @IBOutlet weak var launchButton: UIButton!
  @IBOutlet weak var playerNumber: UILabel!
  
  var currentGame: GameScene!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    angleChanged(angleSlider)
    velocityChanged(velocitySlider)
    
    if let view = self.view as! SKView? {
      // Load the SKScene from 'GameScene.sks'
      if let scene = SKScene(fileNamed: "GameScene") {
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        // Present the scene
        view.presentScene(scene)
        
        currentGame = scene as! GameScene
        currentGame.viewController = self
      }
      
      view.ignoresSiblingOrder = true
      
      view.showsFPS = true
      view.showsNodeCount = true
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  @IBAction func angleChanged(_ sender: Any) {
    angleLabel.text = "Angle: \(Int(angleSlider.value))°"
   
  }
  
  @IBAction func velocityChanged(_ sender: Any) {
    velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    
  }
  
  @IBAction func launch(_ sender: Any) {
    
    angleSlider.isHidden = true
    angleLabel.isHidden = true
    
    velocitySlider.isHidden = true
    velocityLabel.isHidden = true
    
    launchButton.isHidden = true
    
    currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
  
  }
  
  func activatePlayer(number: Int) {
    
    if number == 1 {
      playerNumber.text = "<<< PLAYER ONE"
    
    } else {
      
      playerNumber.text = "PLAYER TWO >>>"
      
    }
    
    angleSlider.isHidden = false
    angleLabel.isHidden = false
    
    velocitySlider.isHidden = false
    velocityLabel.isHidden = false
    
    launchButton.isHidden = false
   
  
  }
  
  
}

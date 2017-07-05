//
//  GameScene.swift
//  JumpUnderPlatform
//
//  Created by justin fluidity on 7/4/17.
//  Copyright © 2017 justin fluidity. All rights reserved.
//

import SpriteKit
import GameplayKit

// Props:
class GameScene: SKScene, SKPhysicsContactDelegate {

  lazy private(set) var player: Player = {
    $0.makePB()
    $0.position.y -= 200
    return $0
  }(Player(color: .blue, size: CGSize(width: 50, height: 50)))

}

// Randos:
extension GameScene {
  
  // Testing purposes:
  func getJup() -> JumpUnderPlatform {
     return childNode(withName: "jup")! as! JumpUnderPlatform
  }
  
  // Scene setup:
  override func didMove(to view: SKView) {
    physicsWorld.contactDelegate = self
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    addChild(player)
  }
}

// Game loop:
extension GameScene {
  
  // Touch handling:
  override func mouseDown(with event: NSEvent) {
    guard let playerPB = player.physicsBody else { fatalError() }
    playerPB.applyImpulse(CGVector(dx: 0, dy: 50))
  }
  
  override func update(_ currentTime: TimeInterval) {
    player._update()
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    self._didBegin(contact) // Defined below :(
  }
  
  override func didSimulatePhysics() {
    player._didSimulatePhysics()
  }
  
  override func didFinishUpdate() {
    let platform = getJup()
    
    if player.isUnderPlatform(platform) == false {
      print("resetting")
      player.flag_isPassThrough = false
      platform.flag_isPassThrough = false
    }
    
    player._didFinishUpdate()
    getJup()._didFinishUpdate()
  }
}



// MARK: - Physics handling:
extension GameScene {
  
  func _didBegin(_ contact: SKPhysicsContact) {
    
    if player.hitThisFrame { return }
    
    player.hitThisFrame = true
    
    let platform = getJup()
    
    if player.isUnderPlatform(platform) {
      
      // Let play pass through:
      player.flag_isPassThrough = true
      platform.flag_isPassThrough = true
      player.physicsBody!.collisionBitMask = UInt32(0)
      platform.physicsBody!.collisionBitMask = UInt32(0)
      
      // Set speed to go higher:
      player.physicsBody!.velocity = player.startingVelocity
    }
    
    else {
      // Is this secondary check unnecessary?
      player.flag_isPassThrough = false
      platform.flag_isPassThrough = false
    }
    
  }
}

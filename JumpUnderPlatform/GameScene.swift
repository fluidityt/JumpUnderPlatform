//
//  GameScene.swift

import SpriteKit
import GameplayKit

// MARK: - Props:
class GameScene: SKScene, SKPhysicsContactDelegate {

  let jupName = "jup"
  
  let player = Player.makePlayer()


  var contactedPlatform: JumpUnderPlatform?
  
}

// MARK: - Funky:
extension GameScene {
  
  // Testing purposes:

  func getJup() -> JumpUnderPlatform {
     return childNode(withName: jupName)! as! JumpUnderPlatform
  }
  
  // Scene setup:
  override func didMove(to view: SKView) {
    physicsWorld.contactDelegate = self
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    addChild(player)
  }
}


// MARK: - Physics handling:
extension GameScene {
  
  private func findJup(contact: SKPhysicsContact) -> JumpUnderPlatform? {
    guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { fatalError() }
    
    if      nodeA.name == jupName { return (nodeA as! JumpUnderPlatform) }
    else if nodeB.name == jupName { return (nodeB as! JumpUnderPlatform) }
    else                          { return nil }
  }
  
  // Player is 2, platform is 4:
  private func doContactPlayer_X_Jup(platform: JumpUnderPlatform) {
    
    // Check if jumping; if not, then just land on platform normally.
    guard player.initialDY > 0 else { return }

    // platform.physicsBody!.collisionBitMask = BitMasks.jupCategory
    player.physicsBody!.collisionBitMask = BitMasks.playerCategory
    player.platformToPassThrough = platform
  }
  
  func _didBegin(_ contact: SKPhysicsContact) {
  
    let contactedSum = contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask
    
    switch contactedSum {
    
    case BitMasks.jupCategory + BitMasks.playerCategory:
      guard let platform = findJup(contact: contact) else { fatalError("must be platform!") }
      doContactPlayer_X_Jup(platform: platform)
      
    default: ()
    }
  }
}

// MARK: - Game loop:
extension GameScene {
  
  // Touch handling:
  override func mouseDown(with event: NSEvent) {
    player.pb.applyImpulse(CGVector(dx: 0, dy: 50))
  }
  
  override func update(_ currentTime: TimeInterval) {
    player._update() // Updates initialDY
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    self._didBegin(contact)
  }
  
  override func didFinishUpdate() {
    player._didFinishUpdate()
  }
}




//
//  GameScene.swift

import SpriteKit
import GameplayKit

// MARK: - Props:
class GameScene: SKScene, SKPhysicsContactDelegate {

  // Because I hate crashes related to spelling errors.
  let names = (jup: "jup", resetLabel: "resetLabel")
  
  let player = Player.makePlayer()
}


// MARK: - Physics handling:
extension GameScene {
  
  private func findJup(contact: SKPhysicsContact) -> JumpUnderPlatform? {
    guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { fatalError("how did this happne!!??") }
    
    if      nodeA.name == names.jup { return (nodeA as! JumpUnderPlatform) }
    else if nodeB.name == names.jup { return (nodeB as! JumpUnderPlatform) }
    else                            { return nil }
  }
  
  // Player is 2, platform is 4:
  private func doContactPlayer_X_Jup(platform: JumpUnderPlatform) {
    
    // Check if jumping; if not, then just land on platform normally.
    guard player.initialDY > 0 else { return }

    // Gives us the ability to pass through the platform!
    player.physicsBody!.collisionBitMask = BitMasks.playerCategory
    
    // Will push the player through the platform (instead of bouncing off) on first hit
    if player.platformToPassThrough == nil { player.pb.velocity.dy = player.initialDY }
    player.platformToPassThrough = platform
  }
  
  func _didBegin(_ contact: SKPhysicsContact) {
  
    // Crappy way to do bit-math:
    let contactedSum = contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask
    
    switch contactedSum {
    
    case BitMasks.jupCategory + BitMasks.playerCategory:
      guard let platform = findJup(contact: contact) else { fatalError("must be platform!") }
      doContactPlayer_X_Jup(platform: platform)
      
    // Put your other contact cases here...
    // case BitMasks.xx + BitMasks.yy:
      
    default: ()
    }
  }
}

// MARK: - Game loop:
extension GameScene {
  
  // Scene setup:
  override func didMove(to view: SKView) {
    physicsWorld.contactDelegate = self
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    addChild(player)
  }
  
  // Touch handling: (convert to touchesBegan for iOS):
  override func mouseDown(with event: NSEvent) {
    // Make player jump:
    player.pb.applyImpulse(CGVector(dx: 0, dy: 50))
    
    // Reset player on label click:
    if nodes(at: event.location(in: self)).first?.name == names.resetLabel {
      player.position.y = frame.minY + player.size.width/2 + CGFloat(1)
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    player._update()
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    self._didBegin(contact)
  }
  
  override func didFinishUpdate() {
    player._didFinishUpdate()
  }
}




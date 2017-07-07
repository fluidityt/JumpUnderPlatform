//
//  Player.swift

import SpriteKit


class Player: SKSpriteNode {
  
  // If you see this on a crash, then WHY DOES PLAYER NOT HAVE A PB??
  var pb: SKPhysicsBody { return self.physicsBody! }
  
  // This is set when we detect contact with a platform, but are underneath it (jumping up)
  weak var platformToPassThrough: JumpUnderPlatform?
  
  // For use inside of gamescene's didBeginContact (because current DY is altered by the time we need it)
  var initialDY = CGFloat(0)
}

// MARK: - Funkys:
extension Player {
  
  static func makePlayer() -> Player {
  
    let newPlayer = Player(color: .blue, size: CGSize(width: 50, height: 50))
    let newPB = SKPhysicsBody(rectangleOf: newPlayer.size)
    
    newPB.categoryBitMask = BitMasks.playerCategory
    newPB.usesPreciseCollisionDetection = true
    
    newPlayer.physicsBody = newPB
    newPlayer.position.y -= 200 // For demo purposes.
    
    return newPlayer
  }
  
  func isAbovePlatform() -> Bool {
    guard let platform = platformToPassThrough else { fatalError("wtf is the platform!") }
    
    if frame.minY > platform.frame.maxY { return true  }
    else                                { return false }
  }
  
  func landOnPlatform() {
      print("resetting stuff!")
      platformToPassThrough = nil
      pb.collisionBitMask = BitMasks.jupCategory
  }
}

// MARK: - Player GameLoop:
extension Player {
  
  func _update() {
    // We have to keep track of this for proper detection of when to pass-through platform
    initialDY = pb.velocity.dy
  }
  
  func _didFinishUpdate() {
    
    // Check if we need to reset our collision mask (allow us to land on platform again)
    if platformToPassThrough != nil {
      if isAbovePlatform() { landOnPlatform() }
    }
  }
}


//
//  JumpUnderPlatform.swift

import SpriteKit
  
class JumpUnderPlatform: SKSpriteNode {

  var pb: SKPhysicsBody { return self.physicsBody! } // If you see this on a crash, then WHY DOES JUP NOT HAVE A PB??
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
}

class Player: SKSpriteNode {

  var pb: SKPhysicsBody { return self.physicsBody! } // If you see this on a crash, then WHY DOES PLAYER NOT HAVE A PB??

  weak var platformToPassThrough: JumpUnderPlatform?
  
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
    newPlayer.position.y -= 200
    
    return newPlayer
  }

  func isOnTopOfPlatform() -> Bool {
   guard let platform = platformToPassThrough else { fatalError("wtf is the platform!") }
    
    if frame.minY > platform.frame.maxY { return true
    } else { return false }
  }
}

// MARK: - Player GameLoop:
extension Player {

  func _update() {
    initialDY = pb.velocity.dy
  }
  
  func _didFinishUpdate() {
    
    if platformToPassThrough != nil {
      if isOnTopOfPlatform() {
        print("resetting!")
        platformToPassThrough = nil
        pb.collisionBitMask = BitMasks.jupCategory
      }
    }
  }
}


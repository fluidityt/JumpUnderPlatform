//
//  JumpUnderPlatform.swift

import SpriteKit
  
class JumpUnderPlatform: SKSpriteNode {

  var zip: Int
  
  var flag_isPassThrough = false
  
  required init?(coder aDecoder: NSCoder) {
    zip = 45
    super.init(coder: aDecoder)
  }
  
  func _didFinishUpdate() {
    if flag_isPassThrough == false {
      physicsBody!.collisionBitMask = BitMasks.jupCategory
    }
  }
  
  private func assignPB() {
    
    //let pb = SKPhysicsBody(rectangleOf: self.size)
    // pb.categoryBitMask = BitMasks.jupCategory
    //pb.contactTestBitMask = BitMasks.playerCategory
    //pb.affectedByGravity = true
    //pb.isDynamic = true
    
    //self.physicsBody = pb
    //self.physicsBody?.affectedByGravity = false
    
    self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
    
    super.color = .gray
    
    assert(self.physicsBody != nil)
    print("successfully added new pb")
  }
  
}

class Player: SKSpriteNode {
  
  // New data at start of update. Used for proper "under platform" detection
  var startingLocation = CGPoint()
  var startingVelocity = CGVector()
  
  var flag_isPassThrough = false
  
  var hitThisFrame = false
  
  func makePB() {
    let pb = SKPhysicsBody(rectangleOf: self.size)
    pb.categoryBitMask = BitMasks.playerCategory
    pb.collisionBitMask = BitMasks.playerCategory
    pb.usesPreciseCollisionDetection = true
    physicsBody = pb
  }
  
  func isUnderPlatform(_ platform: SKSpriteNode) -> Bool {
    if startingLocation.y < platform.position.y {
      return true
    } else { return false }
  }
  
  func _update() {
    startingLocation = position
    startingVelocity = physicsBody!.velocity
  }
  
  func _didSimulatePhysics() {
  }
  
  func _didFinishUpdate() {
    hitThisFrame = false
    
    if flag_isPassThrough == false {
      physicsBody!.collisionBitMask = BitMasks.jupCategory
    }
  }
  
  // // // YAGNI funcs? // // //
  func snapToPlatform(platform: SKSpriteNode) {
    physicsBody = nil
    position.y = platform.frame.maxY + (size.height/2) + 1
    makePB()
  }
  
  func passThroughPlatform() {
    
  }
}


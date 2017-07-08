    //
    //  JumpUnderPlatform.swift

    import SpriteKit

    // Do all the fancy stuff you want here...
    class JumpUnderPlatform: SKSpriteNode {
      
      var pb: SKPhysicsBody { return self.physicsBody! } // If you see this on a crash, then WHY DOES JUP NOT HAVE A PB??
      
      required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
      
    }

import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    
    var batter = SKSpriteNode()
    var pitcher = SKSpriteNode()
    var ball = SKSpriteNode()
    var shootbtn = SKSpriteNode()
    var maru = SKSpriteNode()
    var bat = SKSpriteNode()
    
    var last:CFTimeInterval!
    
    let ballCategory:       UInt32 = 0x1 << 0
    let maruCategory:       UInt32 = 0x1 << 1
    let pitcherCategory:    UInt32 = 0x1 << 2
    let batterCategory:     UInt32 = 0x1 << 3
    let groundCategory:     UInt32 = 0x1 << 4
    

    override func didMoveToView(view: SKView) {

        self.physicsWorld.gravity = CGVectorMake(0.0, -2.0)
        self.physicsWorld.contactDelegate = self
    
        

        //batter

        //batterTexture.filteringMode = SKTextureFilteringMode.Nearest
    
        //batter = SKSpriteNode(texture: batterTexture1)
        

        
//        batter.setScale(1.0)
//        batter.position = CGPointMake(self.frame.size.width * 0.6, self.frame.size.height * 0.6 )
//
//        batter.physicsBody = SKPhysicsBody(circleOfRadius: batter.size.height/2.0)
//        batter.physicsBody?.dynamic = true
//        batter.physicsBody?.allowsRotation = false
//
////        batter.physicsBody?.categoryBitMask = batterCategory
////        batter.physicsBody?.contactTestBitMask = ballCategory
        
  //      self.addChild(batter)
        

        
        

        
        
        //pitcher
        var pitcherTexture = SKTexture(imageNamed: "pitcher")
        pitcherTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        pitcher = SKSpriteNode(texture: pitcherTexture)
        pitcher.setScale(1.0)
        pitcher.position = CGPointMake(self.frame.size.width * 0.05, self.frame.size.height * 0.6 )
        
        pitcher.physicsBody = SKPhysicsBody(circleOfRadius: pitcher.size.height/2.0)
        pitcher.physicsBody?.dynamic = true
        pitcher.physicsBody?.allowsRotation = false
        pitcher.physicsBody?.friction = 1.0
        pitcher.physicsBody?.mass = 1000000000.0
        
        pitcher.physicsBody?.categoryBitMask = pitcherCategory

        
        self.addChild(pitcher)
        
        //Ground
        
        var groundTexture = SKTexture(imageNamed: "ground")
        
        var ground = SKSpriteNode(texture: groundTexture)
        ground.setScale(1.0)
        ground.position = CGPointMake(self.size.width/2, ground.size.height/2)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(groundTexture.size().width, groundTexture.size().height))
        ground.physicsBody?.dynamic = false
        
        ground.physicsBody?.categoryBitMask = groundCategory
        
        self.addChild(ground)
        
        
        //shootbtn
        var ShootbtnTexture = SKTexture(imageNamed: "shoot")
        
        var shootbtn = SKSpriteNode(texture: ShootbtnTexture)
        shootbtn.setScale(1.0)
        shootbtn.position = CGPointMake(self.size.width/2 - 100, 150)
        shootbtn.name = "shoot"
        
        self.addChild(shootbtn)
        
        //battingbtn
        var battingbtnTexture = SKTexture(imageNamed: "batting")
        
        var battingbtn = SKSpriteNode(texture: battingbtnTexture)
        battingbtn.setScale(1.0)
        battingbtn.position = CGPointMake(self.size.width/2 + 100, 150)
        battingbtn.name = "maru"
        
        maru.physicsBody?.categoryBitMask = maruCategory
        maru.physicsBody?.collisionBitMask = ballCategory
        
        self.addChild(battingbtn)

    
    }
    
    func shoot() {
        
        //self.runAction(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        var BallTexture = SKTexture(imageNamed: "ball")
        ball = SKSpriteNode(texture: BallTexture)
        ball.position = CGPointMake(self.pitcher.position.x + 50, self.pitcher.position.y )

        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height/2.0)
        
        ball.physicsBody?.mass = 100.0
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.dynamic = true
        


        self .addChild(ball)
    
        ball.physicsBody?.applyImpulse(CGVectorMake(150000, 10000))
        ball.physicsBody?.restitution = 1.5
        
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = maruCategory

    }
    
    
    
    func hit() {
        
        //self.runAction(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        

        
        var maruTexture = SKTexture(imageNamed: "maru")
        maru = SKSpriteNode(texture: maruTexture)
        maru.position = CGPointMake(self.size.width/2 + 400, self.pitcher.position.y - 5 )

        
        maru.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(maruTexture.size().width, maruTexture.size().height))
        
        
        maru.physicsBody?.dynamic = false
        maru.physicsBody?.allowsRotation = false
        
        let pi:CGFloat = 3.1415926
        maru.runAction(SKAction.rotateByAngle(pi * 1.0, duration: 0.05))

        
//        maru.physicsBody = SKPhysicsBody(circleOfRadius: maru.size.height/2.0)
//        maru.physicsBody?.dynamic = false

        self .addChild(maru)
        
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if nodeAtPoint(location).name == "shoot" {
          //      println("shoot")
                shoot()
            }
        
        }
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            
            if nodeAtPoint(location).name == "maru" {
                      println("maru")
                hit()
            }
            
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        if !(last != nil) {
            last = currentTime
        }
        
        // 1秒おきに行う処理をかく。
        if last + 1 <= currentTime {
            
            self.shoot()
            
            last = currentTime
        }


    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        maru.removeFromParent()
        
      
        
    }
    

    
    func dakyu(){
        println("dakyu")
        ball.runAction(SKAction .moveTo(CGPointMake(100,600), duration:0.5))
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact!) {
        
        var firstBody, secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask & ballCategory != 0 &&
            secondBody.categoryBitMask & maruCategory != 0 {
                secondBody.node?.removeFromParent()
                println("shoot")
                    //self.runAction(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
                dakyu()
                
        }
        
    }
    

    
    
    
}

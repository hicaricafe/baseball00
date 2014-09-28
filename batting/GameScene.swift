import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    
    var batter = SKSpriteNode()
    var pitcher = SKSpriteNode()
    var ball = SKSpriteNode()
    var maru = SKSpriteNode()
    
    var last:CFTimeInterval!
    
    let ballCategory:       UInt32 = 0x1 << 0
    let maruCategory:       UInt32 = 0x1 << 1
    let pitcherCategory:    UInt32 = 0x1 << 2


    override func didMoveToView(view: SKView) {

        self.physicsWorld.gravity = CGVectorMake(0.0, -2.0)
        self.physicsWorld.contactDelegate = self
    
        
        //pitcher
        var pitcherTexture = SKTexture(imageNamed: "pitcher")
        pitcherTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        pitcher = SKSpriteNode(texture: pitcherTexture)
        pitcher.setScale(1.0)
        pitcher.position = CGPointMake(self.frame.size.width * 0.05, self.frame.size.height * 0.5 )
        
        pitcher.physicsBody = SKPhysicsBody(circleOfRadius: pitcher.size.height/2.0)
        pitcher.physicsBody?.dynamic = false
        pitcher.physicsBody?.allowsRotation = false
        pitcher.physicsBody?.friction = 1.0
        pitcher.physicsBody?.mass = 1000000000.0
        
        pitcher.physicsBody?.categoryBitMask = pitcherCategory

        
        self.addChild(pitcher)
        

        
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
    
        
        var BallTexture = SKTexture(imageNamed: "ball")
        ball = SKSpriteNode(texture: BallTexture)
        ball.position = CGPointMake(self.pitcher.position.x + 50, self.pitcher.position.y )

        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height/2.0)
        ball.physicsBody?.mass = 100.0
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.dynamic = true
        self .addChild(ball)

        ball.physicsBody?.applyImpulse(CGVectorMake(150000, 0))
        ball.physicsBody?.restitution = 1.5
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = maruCategory
    }
    
    func hit() {

        var maruTexture = SKTexture(imageNamed: "maru")
        maru = SKSpriteNode(texture: maruTexture)
        maru.position = CGPointMake(self.size.width/2 + 400, self.pitcher.position.y  )
        maru.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(maruTexture.size().width, maruTexture.size().height))
        maru.physicsBody?.dynamic = false
        maru.physicsBody?.allowsRotation = false

        self .addChild(maru)
        
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if nodeAtPoint(location).name == "shoot" {
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
        
        if last + 1 <= currentTime {
            
            self.shoot()
            
            last = currentTime
        }


    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        maru.removeFromParent()
        
      
        
    }

    func dakyu(){
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
                dakyu()
                
        }
        
    }
}

//
//  SpaceShip.swift
//  Gravicaine
//


import SpriteKit
import GameplayKit

class SpaceShip: SKSpriteNode {

    private static let bulletSound: SKAction = SKAction.playSoundFileNamed("laser.mp3", waitForCompletion: false)
    private static let bulletTexture: SKTexture = SKTexture(imageNamed: "player_bullet")
    private var fireEmitter: SKEmitterNode? = nil
    
    
    
    init() {
        let texture = SKTexture(imageNamed: "playerShip")
        let size = CGSize(width: texture.size().width * 0.6, height: texture.size().height * 0.6)
        
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.name = "player"
        self.zPosition = 2
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = PhysicsCategories.Player
        self.physicsBody!.collisionBitMask = PhysicsCategories.None
        self.physicsBody!.contactTestBitMask = PhysicsCategories.Barrier
        self.physicsBody!.contactTestBitMask = PhysicsCategories.Asteroid
        
        if let emitter = SKEmitterNode(fileNamed: "ship-fire") {
            fireEmitter = emitter
            fireEmitter?.position = CGPoint(x: self.position.x, y: self.position.y - 40.0)
            fireEmitter?.targetNode = self
            self.addChild(fireEmitter!)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fireBullet(destinationY: CGFloat)  {
  
        let bullet = SKSpriteNode(texture: SpaceShip.bulletTexture)
        bullet.size = CGSize(width: 25, height: 50)
        //bullet.setScale(GameScene.scale)
        bullet.position = self.position
        bullet.zPosition = self.zPosition - 0.1
        bullet.alpha = 0.0
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.scene?.addChild(bullet)
        
        // two actions
        let moveBullet = SKAction.moveTo(y: destinationY + bullet.size.height, duration: 1)
        let appearBullet = SKAction.fadeAlpha(to: 1.0, duration: 0.15)
        let bulletAnimation = SKAction.group([moveBullet, appearBullet])
        let deleteBullet = SKAction.removeFromParent()
        
        // sequence of actions
        let bulletSequence = SKAction.sequence([SpaceShip.bulletSound, bulletAnimation, deleteBullet])
        bullet.run(bulletSequence)
        
    }
    

    
}

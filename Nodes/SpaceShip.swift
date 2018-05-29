//
//  SpaceShip.swift
//  Gravicaine
//
//  Created by Stephen Ball on 23/05/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpaceShip: SKSpriteNode {

    private static let bulletSound: SKAction = SKAction.playSoundFileNamed("laser.mp3", waitForCompletion: false)
    private static let bulletTexture: SKTexture = SKTexture(imageNamed: "player_bullet")
    private let leftThruster:SKSpriteNode = SKSpriteNode(imageNamed: "r_thruster_small")
    private let rightThruster:SKSpriteNode = SKSpriteNode(imageNamed: "l_thruster_small")
    private var fireEmitter: SKEmitterNode? = nil
    private var shieldNode: ShieldNode = ShieldNode()
 
    
    
    
    init() {
        let texture = SKTexture(imageNamed: "playerShip")
        let size = CGSize(width: texture.size().width, height: texture.size().height)
        
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.name = "player"
        self.zPosition = 2
        self.physicsBody = SKPhysicsBody(rectangleOf: texture.size())
        self.physicsBody!.affectedByGravity = true
        self.physicsBody!.categoryBitMask = PhysicsCategories.Player
        self.physicsBody!.collisionBitMask = PhysicsCategories.None
        self.physicsBody!.contactTestBitMask = PhysicsCategories.Barrier
        
        if let emitter = SKEmitterNode(fileNamed: "ship-fire") {
            fireEmitter = emitter
            fireEmitter?.position = CGPoint(x: 0.0, y: -(self.size.height/2) + 15.0)
            fireEmitter?.targetNode = self
            self.addChild(fireEmitter!)
        }
        shieldNode.animate()


        
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
    
    func thrustLeft(){
        
        if !self.children.contains(leftThruster){
        leftThruster.size = CGSize(width: 30, height: 20)
        leftThruster.alpha = 0.0
        leftThruster.position = CGPoint(x: (self.scene?.position.x)! + 50, y: (self.scene?.position.y)!)
        self.addChild(leftThruster)
        
        //thrust actions
        let appearThruster = SKAction.fadeAlpha(to: 1.0, duration: 0.15)
        let thrustBurn = SKAction.wait(forDuration: 0.25)
        let disappearThruster = SKAction.fadeAlpha(to: 0.0, duration: 0.15)
        let deleteThruster = SKAction.removeFromParent()
        
        //thrust sequence
        let thrustSequence = SKAction.sequence([appearThruster,thrustBurn, disappearThruster ,deleteThruster])
        leftThruster.run(thrustSequence)
        }
        

        
    }
    
    func thrustRight(){
        
        if !self.children.contains(rightThruster){
        rightThruster.size = CGSize(width: 30, height: 20)
        rightThruster.alpha = 0.0
        rightThruster.position = CGPoint(x: (self.scene?.position.x)! - 50, y: (self.scene?.position.y)!)
        self.addChild(rightThruster)
        
        //thrust actions
        let appearThruster = SKAction.fadeAlpha(to: 1.0, duration: 0.15)
        let thrustBurn = SKAction.wait(forDuration: 0.25)
        let disappearThruster = SKAction.fadeAlpha(to: 0.0, duration: 0.15)
        let deleteThruster = SKAction.removeFromParent()
        
        //thrust sequence
        let thrustSequence = SKAction.sequence([appearThruster,thrustBurn, disappearThruster ,deleteThruster])
        rightThruster.run(thrustSequence)
        }

    }
    
    func setShield(){
        
        if !self.children.contains(shieldNode){
            
            shieldNode = ShieldNode()
            shieldNode.animate()
            shieldNode.position = CGPoint(x: (self.scene?.position.x)!, y: (self.scene?.position.y)! - 70)
            self.addChild(shieldNode)
            
            
            
        }
        
    }
    
    func removeShield(){
        
        if self.children.contains(shieldNode){
            let reddenShield = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.5)
            let disappearShield = SKAction.fadeAlpha(to: 0, duration: 2.5)
            let deleteShield = SKAction.removeFromParent()
            let removeShieldSequence = SKAction.sequence([reddenShield,disappearShield,deleteShield])
            
            shieldNode.run(removeShieldSequence)
        
        }
        
    }


    
}

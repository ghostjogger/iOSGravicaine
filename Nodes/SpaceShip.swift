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
    private var shieldNode: BlueShieldNode = BlueShieldNode(scale: 1.0)
    private var scale = CGFloat(0.0)
    var power: Double

    
    init(scale: CGFloat) {
        let texture = SKTexture(imageNamed: "playerShip")
        self.scale = scale
        let size = CGSize(width: texture.size().width * self.scale, height: texture.size().height * self.scale)
        self.shieldNode = BlueShieldNode(scale: self.scale)
        self.power = playerPower
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.name = "player"
        self.zPosition = 2
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:  size.width * 0.9,
                                                             height: size.height * 0.9))
        self.physicsBody!.affectedByGravity = true
        self.physicsBody!.categoryBitMask = PhysicsCategories.Player
        self.physicsBody!.collisionBitMask = PhysicsCategories.None
        self.physicsBody!.contactTestBitMask = PhysicsCategories.Barrier
        
        if let emitter = SKEmitterNode(fileNamed: "ship-fire") {
            fireEmitter = emitter
            fireEmitter?.position = CGPoint(x: 0.0, y: -((self.size.height/2) + (10.0 * self.scale)))
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
        leftThruster.size = CGSize(width: 30 * scale, height: 20 * scale)
        leftThruster.position = CGPoint(x: (self.scene?.position.x)! + (50 * scale), y: (self.scene?.position.y)!)
        self.addChild(leftThruster)
        
        //thrust actions
        let appearThruster = SKAction.fadeAlpha(to: 1.0, duration: 0.05)
        let thrustBurn = SKAction.wait(forDuration: 0.15)
        let disappearThruster = SKAction.fadeAlpha(to: 0.0, duration: 0.05)
        let deleteThruster = SKAction.removeFromParent()

        //thrust sequence
        let thrustSequence = SKAction.sequence([appearThruster,thrustBurn, disappearThruster ,deleteThruster])
        leftThruster.run(thrustSequence)
        }
        

        
    }
    
    func thrustLeftEnded(){
        
        if self.children.contains(leftThruster){
            leftThruster.removeFromParent()
        }
        
    }
    
    func thrustRight(){
        
        if !self.children.contains(rightThruster){
        rightThruster.size = CGSize(width: 30 * scale, height: 20 * scale)
        rightThruster.position = CGPoint(x: (self.scene?.position.x)! - (50 * scale), y: (self.scene?.position.y)!)
        self.addChild(rightThruster)
        
        //thrust actions
        let appearThruster = SKAction.fadeAlpha(to: 1.0, duration: 0.05)
        let thrustBurn = SKAction.wait(forDuration: 0.15)
        let disappearThruster = SKAction.fadeAlpha(to: 0.0, duration: 0.05)
        let deleteThruster = SKAction.removeFromParent()

        //thrust sequence
        let thrustSequence = SKAction.sequence([appearThruster,thrustBurn, disappearThruster ,deleteThruster])
        rightThruster.run(thrustSequence)
        }

    }
    
    func thrustRightEnded(){
        
        if self.children.contains(rightThruster){
            rightThruster.removeFromParent()
        }
        
    }
    
    func setShield(){
        
        if !self.children.contains(shieldNode){
            shieldNode = BlueShieldNode(scale: self.scale)
            shieldNode.animate()
            shieldNode.position = CGPoint(x: (self.scene?.position.x)!, y: (self.scene?.position.y)!)
            self.addChild(shieldNode)
        }
        else{
            shieldNode.removeAllActions()
            shieldNode.removeFromParent()
            shieldNode = BlueShieldNode(scale: self.scale)
            shieldNode.animate()
            shieldNode.position = CGPoint(x: (self.scene?.position.x)!, y: (self.scene?.position.y)!)
            self.addChild(shieldNode)
        }
        
    }
    
    func removeShield(){
        
        if self.children.contains(shieldNode){
            let reddenShield = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.25)
            let disappearShield = SKAction.fadeAlpha(to: 0, duration: 0.25)
            let deleteShield = SKAction.removeFromParent()
            let removeShieldSequence = SKAction.sequence([reddenShield,disappearShield,deleteShield])
            
            shieldNode.run(removeShieldSequence)
        
        }
        
    }


    
}

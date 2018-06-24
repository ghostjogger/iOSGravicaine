//
//  GameScene+Laser.swift
//  Gravicaine
//
//  Created by Stephen Ball on 24/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit

extension GameScene{
    
    func spawnLaserBattery(){
        
        if !gameOverTransitioning{
            
            var leftPlatform = BombNode(scale: self.scaleFactor)
            leftPlatform.position = CGPoint(x: self.frame.width * 0.05, y: self.frame.maxY + 150)
            leftPlatform.zPosition = 200
            
            var rightPlatform = BombNode(scale: self.scaleFactor)
            rightPlatform.position = CGPoint(x: self.frame.width * 0.95, y: self.frame.maxY + 150)
            rightPlatform.zPosition = 200
            
            var laser = LaserBeamNode(scale: self.scaleFactor)
            laser.size.width = self.frame.width * 0.4
            laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
            laser.physicsBody!.affectedByGravity = false
            laser.physicsBody!.categoryBitMask = PhysicsCategories.Asteroid
            laser.physicsBody!.collisionBitMask = PhysicsCategories.None
            laser.physicsBody!.contactTestBitMask = PhysicsCategories.Player
            laser.position = CGPoint(x: self.frame.width/2, y: self.frame.maxY + 150)
            laser.zPosition = 200
            
            
            let size = CGSize(width: self.frame.width, height: 10.0)
            let scoreNode = GapNode(size: size)
            scoreNode.position = CGPoint(x: self.frame.midX, y: self.frame.maxY + 200)
            
            DispatchQueue.global().async {
                
                
                DispatchQueue.main.async(execute: {
                    
                    self.addChild(leftPlatform)
                    leftPlatform.animate()
                    leftPlatform.move(from: leftPlatform.position,
                                      to: CGPoint(x: leftPlatform.position.x, y: self.frame.minY - 50),
                                      control: 1,
                                      cpoint: 1,
                                      run: {
                                        
                    })
                    
                    self.addChild(rightPlatform)
                    rightPlatform.animate()
                    rightPlatform.move(from: rightPlatform.position,
                                       to: CGPoint(x: rightPlatform.position.x, y: self.frame.minY - 50),
                                       control: 1,
                                       cpoint: 1,
                                       run: {
                                        
                    })
                    
                    self.addChild(laser)
                    laser.animate()
                    laser.move(from: laser.position,
                               to: CGPoint(x: laser.position.x, y: self.frame.minY - 50),
                               control: 1,
                               cpoint: 1,
                               run: {
                                
                    })
                    
                    
                    self.addChild(scoreNode)
                    scoreNode.move(from: scoreNode.position, to: CGPoint(x: scoreNode.position.x, y: self.frame.minY + 200), control: 1, cpoint: 1, run: {
                        
                    })
                })
                
                
            }
            
            
        }
        
        
    }
    
    
    
    
}
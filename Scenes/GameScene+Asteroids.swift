//
//  GameScene+Asteroids.swift
//  Gravicaine
//
//  Created by Stephen Ball on 24/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit

extension GameScene{
    
    
    func spawnAsteroidPair(){
        
        if !gameOverTransitioning{
            var redAsteroids = [RedAsteroidNode]()
            var greyAsteroids = [GreyAsteroidNode]()
            
            let size = CGSize(width: self.frame.width, height: 10.0)
            let scoreNode = GapNode(size: size, speed: self.verticalScale)
            
            let yStart = self.frame.maxY + CGFloat(75)
            let minX = CGFloat(self.frame.minX + CGFloat(30))
            let maxX = CGFloat(self.frame.maxX - CGFloat(30))
            DispatchQueue.global().async {
                for _ in 1...3 {
                    
                    let ra = RedAsteroidNode(scale: self.scaleFactor, speed: self.verticalScale)
                    ra.position = CGPoint(x: random(min: minX, max: maxX), y: yStart)
                    redAsteroids.append(ra)
                    let ga = GreyAsteroidNode(scale: self.scaleFactor, speed: self.verticalScale)
                    ga.position = CGPoint(x: random(min: minX, max: maxX), y: yStart)
                    greyAsteroids.append(ga)
                }
                scoreNode.position = CGPoint(x: self.frame.midX, y: yStart + 120)
                
                DispatchQueue.main.async(execute: {
                    
                    let playerX = self.player.position.x
                    
                    for node in redAsteroids{
                        
                        self.addChild(node)
                        node.animate()
                        node.move(from: node.position,
                                  to: CGPoint(x: random(min: playerX - 50, max: playerX + 50), y: self.frame.minY),
                                  control: 1,
                                  cpoint: 1,
                                  run: {
                                    
                        })
                        
                    }
                    
                    for node in greyAsteroids{
                        
                        self.addChild(node)
                        node.animate()
                        node.move(from: node.position,
                                  to: CGPoint(x: random(min: playerX - 50, max: playerX + 50), y: self.frame.minY),
                                  control: 1,
                                  cpoint: 1,
                                  run: {
                                    
                        })
                        
                    }
                    
                    self.addChild(scoreNode)
                    scoreNode.move(from: scoreNode.position,
                                   to: CGPoint(x: self.frame.midX, y: self.frame.minY + 120),
                                   control: 1,
                                   cpoint: 1,
                                   run: {
                                    
                    })
                    
                    
                })
            }
        }
    }
    
    func spawnAsteroidBelt(){
        
        if !gameOverTransitioning{
            
            var greyAsteroids = [GreyAsteroidNode]()
            
            let size = CGSize(width: self.frame.width, height: 10.0)
            let scoreNode = GapNode(size: size, speed: self.verticalScale)
            
            let yStart = self.frame.maxY + CGFloat(75)
            
            DispatchQueue.global().async {
                
                let ga1 = GreyAsteroidNode(scale: self.scaleFactor, speed: self.verticalScale)
                ga1.position = CGPoint(x: self.frame.width * 0.1, y: yStart)
                greyAsteroids.append(ga1)
                let ga2 = GreyAsteroidNode(scale: self.scaleFactor, speed: self.verticalScale)
                ga2.position = CGPoint(x: self.frame.width * 0.5, y: yStart)
                greyAsteroids.append(ga2)
                let ga3 = GreyAsteroidNode(scale: self.scaleFactor, speed: self.verticalScale)
                ga3.position = CGPoint(x: self.frame.width * 0.9, y: yStart)
                greyAsteroids.append(ga3)
                
                scoreNode.position = CGPoint(x: self.frame.midX, y: yStart + 120)
                
                DispatchQueue.main.async(execute: {
                    
                    
                    for node in greyAsteroids{
                        
                        self.addChild(node)
                        node.animate()
                        node.move(from: node.position,
                                  to: CGPoint(x: node.position.x, y: self.frame.minY),
                                  control: 1,
                                  cpoint: 1,
                                  run: {
                                    
                        })
                        
                    }
                    
                    self.addChild(scoreNode)
                    scoreNode.move(from: scoreNode.position,
                                   to: CGPoint(x: self.frame.midX, y: self.frame.minY + 120),
                                   control: 1,
                                   cpoint: 1,
                                   run: {
                                    
                    })
                })
            }
        }
        
    }
    
    func spawnAsteroidBeltRightCurve(){
        
        if !gameOverTransitioning{
            
            var greyAsteroids = [RedAsteroidNode]()
            
            let size = CGSize(width: self.frame.width, height: 10.0)
            let scoreNode = GapNode(size: size, speed: self.verticalScale)
            
            let yStart = self.frame.maxY + CGFloat(75)
            
            DispatchQueue.global().async {
                
                let ga1 = RedAsteroidNode(scale: self.scaleFactor, speed: self.verticalScale)
                ga1.move = .Curvy
                ga1.position = CGPoint(x: self.frame.width * 0.1, y: yStart)
                greyAsteroids.append(ga1)
                let ga2 = RedAsteroidNode(scale: self.scaleFactor, speed: self.verticalScale)
                ga2.move = .Curvy
                ga2.position = CGPoint(x: self.frame.width * 0.5, y: yStart)
                greyAsteroids.append(ga2)
                let ga3 = RedAsteroidNode(scale: self.scaleFactor, speed: self.verticalScale)
                ga3.move = .Curvy
                ga3.position = CGPoint(x: self.frame.width * 0.9, y: yStart)
                greyAsteroids.append(ga3)
                
                scoreNode.position = CGPoint(x: self.frame.midX, y: yStart + 120)
                
                DispatchQueue.main.async(execute: {
                    
                    
                    for node in greyAsteroids{
                        
                        self.addChild(node)
                        node.animate()
                        node.move(from: node.position,
                                  to: CGPoint(x: node.position.x, y: self.frame.minY),
                                  control: 1,
                                  cpoint: 4,
                                  run: {
                                    
                        })
                        
                    }
                    
                    self.addChild(scoreNode)
                    scoreNode.move(from: scoreNode.position,
                                   to: CGPoint(x: self.frame.midX, y: self.frame.minY + 120),
                                   control: 1,
                                   cpoint: 1,
                                   run: {
                                    
                    })
                })
            }
        }
        
    }
    
    func spawnAsteroidBeltLeftCurve(){
        
        if !gameOverTransitioning{
            
            var greyAsteroids = [RedAsteroidNode]()
            
            let size = CGSize(width: self.frame.width, height: 10.0)
            let scoreNode = GapNode(size: size, speed: self.verticalScale)
            
            let yStart = self.frame.maxY + CGFloat(75)
            
            DispatchQueue.global().async {
                
                let ga1 = RedAsteroidNode(scale: self.scaleFactor, speed: self.verticalScale)
                ga1.move = .Curvy
                ga1.position = CGPoint(x: self.frame.width * 0.1, y: yStart)
                greyAsteroids.append(ga1)
                let ga2 = RedAsteroidNode(scale: self.scaleFactor, speed: self.verticalScale)
                ga2.move = .Curvy
                ga2.position = CGPoint(x: self.frame.width * 0.5, y: yStart)
                greyAsteroids.append(ga2)
                let ga3 = RedAsteroidNode(scale: self.scaleFactor, speed: self.verticalScale)
                ga3.move = .Curvy
                ga3.position = CGPoint(x: self.frame.width * 0.9, y: yStart)
                greyAsteroids.append(ga3)
                
                scoreNode.position = CGPoint(x: self.frame.midX, y: yStart + 120)
                
                DispatchQueue.main.async(execute: {
                    
                    
                    for node in greyAsteroids{
                        
                        self.addChild(node)
                        node.animate()
                        node.move(from: node.position,
                                  to: CGPoint(x: node.position.x, y: self.frame.minY),
                                  control: -1,
                                  cpoint: 4,
                                  run: {
                                    
                        })
                        
                    }
                    
                    self.addChild(scoreNode)
                    scoreNode.move(from: scoreNode.position,
                                   to: CGPoint(x: self.frame.midX, y: self.frame.minY + 120),
                                   control: 1,
                                   cpoint: 1,
                                   run: {
                                    
                    })
                })
            }
        }
        
    }
    
    
    
    
    
}

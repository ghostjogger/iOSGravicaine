//
//  GameScene+Mines.swift
//  Gravicaine
//
//  Created by Stephen Ball on 24/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit

extension GameScene{
    
  
    func spawnMineField(isLeftAligned: Bool){
        
        if !gameOverTransitioning{
            
            let yStart = self.frame.maxY + CGFloat(barrierHeight)
            
            var mines = [MineNode]()
            let size = CGSize(width: self.frame.width, height: 10.0)
            let scoreNode = GapNode(size: size, speed: self.verticalScale)
            
            DispatchQueue.global().async {
                
                
                if isLeftAligned{
                    // left aligned mines
                    let mine1 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine1.zPosition = 200
                    mine1.position = CGPoint(x: self.frame.width * 0.1, y: yStart)
                    mines.append(mine1)
                    
                    
                    let mine2 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine2.zPosition = 200
                    mine2.position = CGPoint(x: self.frame.width * 0.4, y: yStart)
                    mines.append(mine2)
                    
                    let mine3 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine3.zPosition = 200
                    mine3.position = CGPoint(x: self.frame.width * 0.7, y: yStart)
                    mines.append(mine3)
                }
                else{
                    
                    //right aligned mines
                    let mine1 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine1.zPosition = 200
                    mine1.position = CGPoint(x: self.frame.width * 0.3, y: yStart)
                    mines.append(mine1)
                    
                    
                    let mine2 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine2.zPosition = 200
                    mine2.position = CGPoint(x: self.frame.width * 0.6, y: yStart)
                    mines.append(mine2)
                    
                    let mine3 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine3.zPosition = 200
                    mine3.position = CGPoint(x: self.frame.width * 0.9, y: yStart)
                    mines.append(mine3)
                    
                }
                
                scoreNode.position = CGPoint(x: self.frame.midX, y: yStart + 100)
                
                DispatchQueue.main.async(execute: {
                    
                    for mine in mines{
                        
                        mine.move = .Straight
                        self.addChild(mine)
                        mine.animate()
                        mine.move(from: mine.position, to: CGPoint(x: mine.position.x, y: self.frame.minY), control: 1, cpoint: 1, run: {
                            
                        })
                    }
                    
                    self.addChild(scoreNode)
                    scoreNode.move(from: scoreNode.position, to: CGPoint(x: scoreNode.position.x, y: self.frame.minY + 100), control: 1, cpoint: 1, run: {
                        
                    })
                })
            }
        }
    }
    
    func spawnMineFieldOscillateLeft(isLeftAligned: Bool){
        
        if !gameOverTransitioning{
            
            let yStart = self.frame.maxY + CGFloat(barrierHeight)
            
            var mines = [MineNode]()
            let size = CGSize(width: self.frame.width, height: 10.0)
            let scoreNode = GapNode(size: size, speed: self.verticalScale)
            
            DispatchQueue.global().async {
                
                
                if isLeftAligned{
                    // left aligned mines
                    let mine1 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine1.zPosition = 200
                    mine1.position = CGPoint(x: self.frame.width * 0.1, y: yStart)
                    mines.append(mine1)
                    
                    
                    let mine2 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine2.zPosition = 200
                    mine2.position = CGPoint(x: self.frame.width * 0.4, y: yStart)
                    mines.append(mine2)
                    
                    let mine3 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine3.zPosition = 200
                    mine3.position = CGPoint(x: self.frame.width * 0.7, y: yStart)
                    mines.append(mine3)
                }
                else{
                    
                    //right aligned mines
                    let mine1 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine1.zPosition = 200
                    mine1.position = CGPoint(x: self.frame.width * 0.3, y: yStart)
                    mines.append(mine1)
                    
                    
                    let mine2 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine2.zPosition = 200
                    mine2.position = CGPoint(x: self.frame.width * 0.6, y: yStart)
                    mines.append(mine2)
                    
                    let mine3 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine3.zPosition = 200
                    mine3.position = CGPoint(x: self.frame.width * 0.9, y: yStart)
                    mines.append(mine3)
                    
                }
                
                scoreNode.position = CGPoint(x: self.frame.midX, y: yStart + 100)
                
                DispatchQueue.main.async(execute: {
                    
                    for mine in mines{
                        
                        mine.move = .Straight
                        self.addChild(mine)
                        mine.animate()
                        mine.move(from: mine.position, to: CGPoint(x: mine.position.x, y: self.frame.minY), control: 1, cpoint: 1, run: {
                            
                        })
                        
                        mine.oscillate(toX1: mine.position.x - self.frame.width * 0.2,
                                       toX2: mine.position.x + self.frame.width * 0.2,
                                       toX3: mine.position.x - self.frame.width * 0.2)
                    }
                    
                    self.addChild(scoreNode)
                    scoreNode.move(from: scoreNode.position, to: CGPoint(x: scoreNode.position.x, y: self.frame.minY + 100), control: 1, cpoint: 1, run: {
                        
                    })
                })
            }
        }
    }
    
    func spawnMineFieldOscillateRight(isLeftAligned: Bool){
        
        if !gameOverTransitioning{
            
            let yStart = self.frame.maxY + CGFloat(barrierHeight)
            
            var mines = [MineNode]()
            let size = CGSize(width: self.frame.width, height: 10.0)
            let scoreNode = GapNode(size: size, speed: self.verticalScale)
            
            DispatchQueue.global().async {
                
                
                if isLeftAligned{
                    // left aligned mines
                    let mine1 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine1.zPosition = 200
                    mine1.position = CGPoint(x: self.frame.width * 0.1, y: yStart)
                    mines.append(mine1)
                    
                    
                    let mine2 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine2.zPosition = 200
                    mine2.position = CGPoint(x: self.frame.width * 0.4, y: yStart)
                    mines.append(mine2)
                    
                    let mine3 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine3.zPosition = 200
                    mine3.position = CGPoint(x: self.frame.width * 0.7, y: yStart)
                    mines.append(mine3)
                }
                else{
                    
                    //right aligned mines
                    let mine1 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine1.zPosition = 200
                    mine1.position = CGPoint(x: self.frame.width * 0.3, y: yStart)
                    mines.append(mine1)
                    
                    
                    let mine2 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine2.zPosition = 200
                    mine2.position = CGPoint(x: self.frame.width * 0.6, y: yStart)
                    mines.append(mine2)
                    
                    let mine3 = MineNode(scale: self.scaleFactor, speed: self.verticalScale)
                    mine3.zPosition = 200
                    mine3.position = CGPoint(x: self.frame.width * 0.9, y: yStart)
                    mines.append(mine3)
                    
                }
                
                scoreNode.position = CGPoint(x: self.frame.midX, y: yStart + 100)
                
                DispatchQueue.main.async(execute: {
                    
                    for mine in mines{
                        
                        mine.move = .Straight
                        self.addChild(mine)
                        mine.animate()
                        mine.move(from: mine.position, to: CGPoint(x: mine.position.x, y: self.frame.minY), control: 1, cpoint: 1, run: {
                            
                        })
                        
                        mine.oscillate(toX1: mine.position.x + self.frame.width * 0.2,
                                       toX2: mine.position.x - self.frame.width * 0.2,
                                       toX3: mine.position.x + self.frame.width * 0.2)
                    }
                    
                    self.addChild(scoreNode)
                    scoreNode.move(from: scoreNode.position, to: CGPoint(x: scoreNode.position.x, y: self.frame.minY + 100), control: 1, cpoint: 1, run: {
                        
                    })
                })
            }
        }
    }
    
    
    
    
    
}

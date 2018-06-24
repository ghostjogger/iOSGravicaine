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
            
            var mines = [MineNode]()
            let size = CGSize(width: self.frame.width, height: 10.0)
            let scoreNode = GapNode(size: size)
            
            DispatchQueue.global().async {
                
                
                if isLeftAligned{
                    // left aligned mines
                    let mine1 = MineNode(scale: self.scaleFactor)
                    mine1.zPosition = 200
                    mine1.position = CGPoint(x: self.frame.width * 0.1, y: self.frame.maxY + mine1.size.height)
                    mines.append(mine1)
                    
                    
                    let mine2 = MineNode(scale: self.scaleFactor)
                    mine2.zPosition = 200
                    mine2.position = CGPoint(x: self.frame.width * 0.4, y: self.frame.maxY + mine1.size.height)
                    mines.append(mine2)
                    
                    let mine3 = MineNode(scale: self.scaleFactor)
                    mine3.zPosition = 200
                    mine3.position = CGPoint(x: self.frame.width * 0.7, y: self.frame.maxY + mine1.size.height)
                    mines.append(mine3)
                }
                else{
                    
                    //right aligned mines
                    let mine1 = MineNode(scale: self.scaleFactor)
                    mine1.zPosition = 200
                    mine1.position = CGPoint(x: self.frame.width * 0.3, y: self.frame.maxY + mine1.size.height)
                    mines.append(mine1)
                    
                    
                    let mine2 = MineNode(scale: self.scaleFactor)
                    mine2.zPosition = 200
                    mine2.position = CGPoint(x: self.frame.width * 0.6, y: self.frame.maxY + mine1.size.height)
                    mines.append(mine2)
                    
                    let mine3 = MineNode(scale: self.scaleFactor)
                    mine3.zPosition = 200
                    mine3.position = CGPoint(x: self.frame.width * 0.9, y: self.frame.maxY + mine1.size.height)
                    mines.append(mine3)
                    
                }
                
                scoreNode.position = CGPoint(x: self.frame.midX, y: self.frame.maxY + 200)
                
                DispatchQueue.main.async(execute: {
                    
                    for mine in mines{
                        
                        mine.move = .Straight
                        self.addChild(mine)
                        mine.animate()
                        mine.move(from: mine.position, to: CGPoint(x: mine.position.x, y: self.frame.minY), control: 1, cpoint: 1, run: {
                            
                        })
                    }
                    
                    self.addChild(scoreNode)
                    scoreNode.move(from: scoreNode.position, to: CGPoint(x: scoreNode.position.x, y: self.frame.minY + 200), control: 1, cpoint: 1, run: {
                        
                    })
                })
            }
        }
    }
    
    
    
    
    
    
}

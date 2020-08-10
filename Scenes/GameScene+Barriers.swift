//
//  GameScene+Barriers.swift
//  Gravicaine
//
//  Created by Stephen Ball on 24/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit

extension GameScene{
    
    func spawnNormalBarrier(count: Int){
        
        if !gameOverTransitioning && barrierCount <= barriers.count - 1{
            
            DispatchQueue.global().async {
                
                
                //setup left barrier
                
                let leftBarrier = BarrierNode(scale: self.scaleFactor, name: "Barrier2LBig", speed: self.verticalScale)
                leftBarrier.move = .Straight
                let leftOffset = ((leftBarrier.size.width/10) * CGFloat(count))
                leftBarrier.position = CGPoint(
                    x: (self.frame.minX - leftBarrier.size.width/2) + leftOffset,
                    y: self.size.height + CGFloat(barrierHeight))
                
                //setup right barrier
                
                let rightBarrier = BarrierNode(scale: self.scaleFactor, name: "Barrier2RBig", speed: self.verticalScale)
                rightBarrier.move = .Straight
                rightBarrier.position = (CGPoint(x: leftBarrier.position.x
                    + leftBarrier.size.width + (CGFloat(barrierGap) * self.scaleFactor),
                                                 y: self.size.height + CGFloat(barrierHeight)))
                
                //setup score gap
                
                let size = CGSize(width: (CGFloat(barrierGap) * self.scaleFactor), height: leftBarrier.size.height)
                let barrierSpaceNode = GapNode( size: size, speed: self.verticalScale)
                barrierSpaceNode.move = .Straight
                barrierSpaceNode.position = CGPoint(x: leftBarrier.position.x + leftBarrier.size.width/2 + size.width/2, y: self.size.height + (CGFloat(barrierHeight) * 1.70) )
                
                DispatchQueue.main.async(execute: {
                    self.addChild(leftBarrier)
                    self.addChild(rightBarrier)
                    self.addChild(barrierSpaceNode)
                    leftBarrier.move(from: CGPoint(x: leftBarrier.position.x, y: leftBarrier.position.y), to: CGPoint(x: leftBarrier.position.x, y: CGFloat(-barrierHeight)), control: 1, cpoint: self.barrierCpoints[self.barrierCount],  run: {
                        
                    })
                    rightBarrier.move(from: CGPoint(x: rightBarrier.position.x, y: rightBarrier.position.y), to: CGPoint(x: rightBarrier.position.x, y: CGFloat(-barrierHeight)), control: 1, cpoint: self.barrierCpoints[self.barrierCount], run: {
                        
                    })
                    barrierSpaceNode.move(from: CGPoint(x: barrierSpaceNode.position.x, y: barrierSpaceNode.position.y), to: CGPoint(x: barrierSpaceNode.position.x, y: CGFloat(0)), control: 1, cpoint: self.barrierCpoints[self.barrierCount], run: {
                        
                    })
                    
                })
            }
        }
        
    }
    
    func spawnMovingBarrier(count: Int){
        
        if !gameOverTransitioning && barrierCount <= barriers.count - 1{
            
            var left:Bool
            var control:Int
            
            if count < 5{
                left = false
                control = 1
            }
            else{
                left = true
                control = -1
            }
            
            DispatchQueue.global().async {
                
                //setup left barrier
                
                let leftBarrier = BarrierNode(scale: self.scaleFactor, name: "BarrierLongL", speed: self.verticalScale)
                let leftOffset = ((leftBarrier.size.width/20) * CGFloat(count))
                leftBarrier.move = .Diagonal
                leftBarrier.position = CGPoint(
                    x: (self.frame.minX - leftBarrier.size.width/2) + leftOffset,
                    y: self.size.height + CGFloat(barrierHeight))
                
                //setup right barrier
                
                let rightBarrier = BarrierNode(scale: self.scaleFactor, name: "BarrierLongR", speed: self.verticalScale)
                rightBarrier.move = .Diagonal
                rightBarrier.position = (CGPoint(x: leftBarrier.position.x
                    + leftBarrier.size.width + (CGFloat(barrierGap) * self.scaleFactor),
                                                 y: self.size.height + CGFloat(barrierHeight)))
                
                //setup score gap
                
                let size = CGSize(width: (CGFloat(barrierGap) * self.scaleFactor), height: leftBarrier.size.height)
                let barrierSpaceNode = GapNode( size: size, speed: self.verticalScale)
                barrierSpaceNode.move = .Diagonal
                barrierSpaceNode.position = CGPoint(x: leftBarrier.position.x + leftBarrier.size.width/2 + size.width/2, y:self.size.height + (CGFloat(barrierHeight) * 1.7))
                
                //setup x movements
                let cpointX = self.barrierCpoints[self.barrierCount]
                
                //leftbarrier x movement
                var leftBarrierXdestination :CGFloat
                
                if left{
                    leftBarrierXdestination = leftBarrier.position.x - CGFloat(barrierMovementX * cpointX)
                }
                else{
                    leftBarrierXdestination = leftBarrier.position.x + CGFloat(barrierMovementX * cpointX)
                }
                
                
                //rightbarrier x movement
                var rightBarrierXdestination :CGFloat
                
                if left{
                    rightBarrierXdestination = rightBarrier.position.x - CGFloat(barrierMovementX * cpointX)
                }
                else{
                    rightBarrierXdestination = rightBarrier.position.x + CGFloat(barrierMovementX * cpointX)
                }
                
                
                
                //barrier gap x movement
                var barrierGapXdestination: CGFloat
                if left{
                    barrierGapXdestination = barrierSpaceNode.position.x - CGFloat(barrierMovementX * cpointX)
                }
                else{
                    barrierGapXdestination = barrierSpaceNode.position.x + CGFloat(barrierMovementX * cpointX)
                }
                
                
                
                DispatchQueue.main.async(execute: {
                    
                    self.addChild(leftBarrier)
                    self.addChild(rightBarrier)
                    self.addChild(barrierSpaceNode)
                    leftBarrier.move(from: CGPoint(x: leftBarrier.position.x, y: leftBarrier.position.y), to: CGPoint(x: leftBarrierXdestination, y: CGFloat(-barrierHeight)), control: control, cpoint: self.barrierCpoints[self.barrierCount], run: {
                        
                    })
                    rightBarrier.move(from: CGPoint(x: rightBarrier.position.x, y: rightBarrier.position.y), to: CGPoint(x: rightBarrierXdestination, y: CGFloat(-barrierHeight)), control:control, cpoint: self.barrierCpoints[self.barrierCount],  run: {
                        
                    })
                    barrierSpaceNode.move(from: CGPoint(x: barrierSpaceNode.position.x, y: barrierSpaceNode.position.y), to: CGPoint(x: barrierGapXdestination, y: CGFloat(0)), control: control,  cpoint: self.barrierCpoints[self.barrierCount], run: {
                        
                    })
                    
                    
                })
            }
        }
    }
    
    
    func spawnCurvyMovingBarrier(count: Int){
        
        if !gameOverTransitioning && barrierCount <= barriers.count - 1{
            
            var control:Int
            
            if count < 5{
                control = 1
            }
            else{
                control = -1
            }
            
            DispatchQueue.global().async {
                
                
                //setup left barrier
                
                let leftBarrier = BarrierNode(scale: self.scaleFactor, name: "Barrier2LBig", speed: self.verticalScale)
                leftBarrier.move = .Curvy
                let leftOffset = ((leftBarrier.size.width/10) * CGFloat(count))
                leftBarrier.position = CGPoint(
                    x: (self.frame.minX - leftBarrier.size.width/2) + leftOffset,
                    y: self.size.height + CGFloat(barrierHeight))
                
                //setup right barrier
                
                let rightBarrier = BarrierNode(scale: self.scaleFactor, name: "Barrier2RBig", speed: self.verticalScale)
                rightBarrier.move = .Curvy
                rightBarrier.position = (CGPoint(x: leftBarrier.position.x
                    + leftBarrier.size.width + (CGFloat(barrierGap) * self.scaleFactor),
                                                 y: self.size.height + CGFloat(barrierHeight)))
                
                
                //setup score gap
                
                let size = CGSize(width: (CGFloat(barrierGap) * self.scaleFactor), height: leftBarrier.size.height)
                let barrierSpaceNode = GapNode( size: size, speed: self.verticalScale)
                barrierSpaceNode.move = .Curvy
                barrierSpaceNode.position = CGPoint(x: leftBarrier.position.x + leftBarrier.size.width/2 + size.width/2, y: self.size.height +  (CGFloat(barrierHeight) * 1.7))
                
                
                DispatchQueue.main.async(execute: {
                    self.addChild(leftBarrier)
                    self.addChild(rightBarrier)
                    self.addChild(barrierSpaceNode)
                    leftBarrier.move(from: CGPoint(x: leftBarrier.position.x, y: leftBarrier.position.y), to: CGPoint(x: leftBarrier.position.x, y: CGFloat(-barrierHeight)), control: control, cpoint: self.barrierCpoints[self.barrierCount],  run: {
                        
                    })
                    rightBarrier.move(from: CGPoint(x: rightBarrier.position.x, y: rightBarrier.position.y), to: CGPoint(x: rightBarrier.position.x, y: CGFloat(-barrierHeight)), control: control,cpoint: self.barrierCpoints[self.barrierCount],run: {
                        
                    })
                    barrierSpaceNode.move(from: CGPoint(x: barrierSpaceNode.position.x, y: barrierSpaceNode.position.y), to: CGPoint(x: barrierSpaceNode.position.x, y: CGFloat(0)),control: control, cpoint: self.barrierCpoints[self.barrierCount],run: {
                        
                    })
                    
                })
            }
        }
    }
    
    func spawnVerticalGapBarrierLeftLower(count: Int){
        
        if !gameOverTransitioning && barrierCount <= barriers.count - 1{
            
            DispatchQueue.global().async {
                
                
                //setup left barrier
                
                let leftBarrier = BarrierNode(scale: self.scaleFactor, name: "BarrierLongL", speed: self.verticalScale)
                leftBarrier.move = .Straight
                let leftOffset = ((leftBarrier.size.width/20) * CGFloat(count))
                leftBarrier.position = CGPoint(
                    x: (self.frame.minX - leftBarrier.size.width/2) + leftOffset,
                    y: self.size.height + CGFloat(barrierHeight))
                
                //setup right barrier
                
                let rightBarrier = BarrierNode(scale: self.scaleFactor, name: "BarrierLongR", speed: self.verticalScale)
                rightBarrier.move = .Straight
                rightBarrier.position = (CGPoint(x: leftBarrier.position.x
                    + leftBarrier.size.width - (CGFloat(barrierHOverlap) * self.scaleFactor) ,
                                                 y: self.size.height + CGFloat(barrierHeight) + (CGFloat(barrierVerticalSpacing) * self.verticalScale)))
                
                //setup score gap
                
                let size = CGSize(width: self.size.width, height: 20)
                let barrierSpaceNode = GapNode( size: size, speed: self.verticalScale)
                barrierSpaceNode.move = .Straight
                barrierSpaceNode.position = CGPoint(x: self.size.width/2, y: rightBarrier.position.y + rightBarrier.size.height/2 + barrierSpaceNode.size.height/2 )
                
                DispatchQueue.main.async(execute: {
                    self.addChild(leftBarrier)
                    self.addChild(rightBarrier)
                    self.addChild(barrierSpaceNode)
                    leftBarrier.move(from: CGPoint(x: leftBarrier.position.x, y: leftBarrier.position.y), to: CGPoint(x: leftBarrier.position.x, y: CGFloat(-barrierHeight) - CGFloat(barrierVerticalSpacing)), control: 1, cpoint: self.barrierCpoints[self.barrierCount],  run: {
                        
                    })
                    rightBarrier.move(from: CGPoint(x: rightBarrier.position.x, y: rightBarrier.position.y), to: CGPoint(x: rightBarrier.position.x, y: CGFloat(-barrierHeight)), control: 1, cpoint: self.barrierCpoints[self.barrierCount], run: {
                        
                    })
                    barrierSpaceNode.move(from: CGPoint(x: barrierSpaceNode.position.x, y: barrierSpaceNode.position.y), to: CGPoint(x: barrierSpaceNode.position.x, y: CGFloat(barrierSpaceNode.size.height/2)), control: 1, cpoint: self.barrierCpoints[self.barrierCount], run: {
                        
                    })
                    
                })
            }
        }
        
        
    }
    
    func spawnVerticalGapBarrierRightLower(count: Int){
        
        if !gameOverTransitioning && barrierCount <= barriers.count - 1{
            
            DispatchQueue.global().async {
                
                
                //setup left barrier
                
                let leftBarrier = BarrierNode(scale: self.scaleFactor, name: "BarrierLongL", speed: self.verticalScale)
                leftBarrier.move = .Straight
                let leftOffset = ((leftBarrier.size.width/20) * CGFloat(count))
                leftBarrier.position = CGPoint(
                    x: (self.frame.minX - leftBarrier.size.width/2) + leftOffset,
                    y: self.size.height + CGFloat(barrierHeight) + (CGFloat(barrierVerticalSpacing) * self.verticalScale))
                
                //setup right barrier
                
                let rightBarrier = BarrierNode(scale: self.scaleFactor, name: "BarrierLongR", speed: self.verticalScale)
                rightBarrier.move = .Straight
                rightBarrier.position = (CGPoint(x: leftBarrier.position.x
                    + leftBarrier.size.width - (CGFloat(barrierHOverlap) * self.scaleFactor),
                                                 y: self.size.height + CGFloat(barrierHeight)))
                
                //setup score gap
                
                let size = CGSize(width: self.size.width, height: 20)
                let barrierSpaceNode = GapNode( size: size, speed: self.verticalScale)
                barrierSpaceNode.move = .Straight
                barrierSpaceNode.position = CGPoint(x: self.size.width/2, y: leftBarrier.position.y + leftBarrier.size.height/2 + barrierSpaceNode.size.height/2 )
                
                DispatchQueue.main.async(execute: {
                    self.addChild(leftBarrier)
                    self.addChild(rightBarrier)
                    self.addChild(barrierSpaceNode)
                    leftBarrier.move(from: CGPoint(x: leftBarrier.position.x, y: leftBarrier.position.y), to: CGPoint(x: leftBarrier.position.x, y: CGFloat(-barrierHeight)), control: 1, cpoint: self.barrierCpoints[self.barrierCount],  run: {
                        
                    })
                    rightBarrier.move(from: CGPoint(x: rightBarrier.position.x, y: rightBarrier.position.y), to: CGPoint(x: rightBarrier.position.x, y: CGFloat(-barrierHeight) - CGFloat(barrierVerticalSpacing)), control: 1, cpoint: self.barrierCpoints[self.barrierCount], run: {
                        
                    })
                    barrierSpaceNode.move(from: CGPoint(x: barrierSpaceNode.position.x, y: barrierSpaceNode.position.y), to: CGPoint(x: barrierSpaceNode.position.x, y: CGFloat(barrierSpaceNode.size.height/2)), control: 1, cpoint: self.barrierCpoints[self.barrierCount], run: {
                        
                    })
                    
                })
            }
        }
        
        
    }
    
    
    
    
    
    
    
}

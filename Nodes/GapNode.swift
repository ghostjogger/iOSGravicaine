//
//  GapNode.swift
//  Gravicaine
//
//  Created by Stephen Ball on 12/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//
import SpriteKit
import GameplayKit

enum GapMove {
    case Straight
    case Diagonal
    case Curvy
}

class GapNode:SKSpriteNode {
    
    var barrierSpeed: CGFloat = 550.0 // (speed is x px per second)
    var move: GapMove = .Straight
    
    
    init( size: CGSize) {

        super.init(texture: nil, color: UIColor.blue, size: size)
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = PhysicsCategories.BarrierGap
        self.physicsBody!.collisionBitMask = PhysicsCategories.None
        self.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.name = "barrierGap"
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: move management
    
    private func straightMove(from: CGPoint, to: CGPoint) -> SKAction {
        
        let deltaX = to.x - from.x
        let deltaY = to.y - from.y
        
        let distance = sqrt(pow(deltaX, 2.0) + pow(deltaY, 2.0))
        let duration = distance / barrierSpeed
        
        return SKAction.move(to: to, duration: TimeInterval(duration))
    }
    
    private func curvyMove(from: CGPoint, to: CGPoint, control: Int, cpoint: Int) -> SKAction {
        
        let deltaX = from.x + CGFloat((100 * cpoint) * control)
        let deltaY = abs((from.y - to.y) / 2)
        
        
        let controlPoint = CGPoint(x: CGFloat(deltaX), y: deltaY)
        
        
        let bezierPath: UIBezierPath = UIBezierPath()
        bezierPath.move(to: from)
        bezierPath.addQuadCurve(to: to, controlPoint: controlPoint)
        
        return SKAction.follow(bezierPath.cgPath, asOffset: false, orientToPath: false, speed: barrierSpeed)
    }
    
    func move(from: CGPoint, to: CGPoint, control: Int, cpoint: Int , run: @escaping () -> Void = {}) {
        
        // set position
        self.position = from
        
        var moveAction: SKAction? = nil;
        
        switch move {
        case .Straight:
            moveAction = self.straightMove(from: from, to: to)
            break
        case .Diagonal:
            moveAction = self.straightMove(from: from, to: to)
            break
        case .Curvy:
            moveAction = self.curvyMove(from: from, to: to, control: control, cpoint: cpoint)
            break
        }
        
        //let
        let removeAction = SKAction.removeFromParent()
        let runAction = SKAction.run(run)
        let sequence = SKAction.sequence([moveAction!, removeAction, runAction])
        self.run(sequence)
        
    }
    

    
    
    
}

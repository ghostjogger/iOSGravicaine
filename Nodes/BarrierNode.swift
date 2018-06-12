//
//  barrierNode.swift
//  Gravicaine
//
//  Created by stephen ball on 10/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit
import GameplayKit

enum BarrierMove {
    case Straight
    case Diagonal
    case Curvy
}

class BarrierNode:SKSpriteNode {
    
    var barrierSpeed: CGFloat = 1000.0 // (speed is x px per second)
    var move: BarrierMove = .Straight

    
    init(scale: CGFloat, name: String) {
        let texture = SKTexture(imageNamed: name)
        let size = CGSize(width: texture.size().width * scale, height: texture.size().height * scale)
        super.init(texture: texture, color: UIColor.clear, size: size)

        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = PhysicsCategories.Barrier
        self.physicsBody!.collisionBitMask = PhysicsCategories.None
        self.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.name = "barrier"
        
        
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
    
    private func curvyMove(from: CGPoint, to: CGPoint) -> SKAction {
        
        var deltaX = to.x - from.x
        var deltaY = to.y - from.y
        if arc4random() % 2 == 1 {
            deltaX = -deltaX
            deltaY = -deltaY
        }
        
        let controlPoint0 = CGPoint(x: from.x + deltaX * 0.5, y: from.y)
        let controlPoint1 = CGPoint(x: to.x, y: to.y - deltaY  * 0.5)
        
        let bezierPath: UIBezierPath = UIBezierPath()
        bezierPath.move(to: from)
        bezierPath.addCurve(to: to, controlPoint1: controlPoint0, controlPoint2: controlPoint1)
        
        return SKAction.follow(bezierPath.cgPath, asOffset: false, orientToPath: true, speed: barrierSpeed)
    }
    
    func move(from: CGPoint, to: CGPoint, run: @escaping () -> Void = {}) {
        
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
            moveAction = self.curvyMove(from: from, to: to)
            break
        }
        
        //let
        let removeAction = SKAction.removeFromParent()
        let runAction = SKAction.run(run)
        let sequence = SKAction.sequence([moveAction!, removeAction, runAction])
        self.run(sequence)
        
    }
    
    
    
}

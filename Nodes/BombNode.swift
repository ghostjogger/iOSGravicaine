//
//  BombNode.swift
//  Gravicaine
//
//  Created by stephen ball on 17/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//


import SpriteKit
import GameplayKit

enum BombMove {
    case Straight
    case Curvy
}

class BombNode: SKSpriteNode {
    
    
    var bombSpeed: CGFloat = 550.0 // (speed is x px per second)
    var move: MineMove = .Straight
    
    private var animationFrames: [SKTexture] = []
    private let animatedAtlas = SKTextureAtlas(named: "bombs")
    
    // MARK: init
    
    init(scale: CGFloat, speed: CGFloat) {
        
        let texture = SKTexture(imageNamed: "bomb1")
        let size = CGSize(width: (texture.size().width * 0.7) * scale, height: (texture.size().height * 0.7) * scale)
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.bombSpeed = CGFloat(obstacleVerticalSpeed) * speed
        
        
        //setup animation
        let numImages = animatedAtlas.textureNames.count
        for i in 1...numImages {
            let shieldTextureName = "bomb\(i)"
            animationFrames.append(animatedAtlas.textureNamed(shieldTextureName))
        }
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = PhysicsCategories.Asteroid
        self.physicsBody!.collisionBitMask = PhysicsCategories.None
        self.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: move management
    
    private func straightMove(from: CGPoint, to: CGPoint) -> SKAction {
        
        let deltaX = to.x - from.x
        let deltaY = to.y - from.y
        
        let distance = sqrt(pow(deltaX, 2.0) + pow(deltaY, 2.0))
        let duration = distance / bombSpeed
        
        return SKAction.move(to: to, duration: TimeInterval(duration))
    }
    
    private func curvyMove(from: CGPoint, to: CGPoint, control: Int, cpoint: Int) -> SKAction {
        
        let deltaX = from.x + CGFloat((100 * cpoint) * control)
        let deltaY = abs((from.y - to.y) / 2)
        
        
        
        
        let controlPoint = CGPoint(x: CGFloat(deltaX), y: deltaY)
        
        
        let bezierPath: UIBezierPath = UIBezierPath()
        bezierPath.move(to: from)
        bezierPath.addQuadCurve(to: to, controlPoint: controlPoint)
        
        return SKAction.follow(bezierPath.cgPath, asOffset: false, orientToPath: false, speed: bombSpeed)
    }
    
    func move(from: CGPoint, to: CGPoint, control: Int, cpoint: Int, run: @escaping () -> Void = {}) {
        
        // set position
        self.position = from
        
        var moveAction: SKAction? = nil;
        
        switch move {
        case .Straight:
            moveAction = self.straightMove(from: from, to: to)
            // rotate depending on the angle
            let deltaX = to.x - from.x
            let deltaY = to.y - from.y
            let angle =  atan(deltaX/deltaY)
            self.zRotation = CGFloat(Double.pi) - angle
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
    
    func animate(){
        let animateAction = SKAction.animate(with: animationFrames, timePerFrame: 0.2, resize: false, restore: false)
        let animation = SKAction.repeatForever(animateAction)
        self.run(animation)
    }
    
}

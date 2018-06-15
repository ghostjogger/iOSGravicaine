//
//  RedAsteroidNode.swift
//  Gravicaine
//
//  Created by stephen ball on 15/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//


import SpriteKit
import GameplayKit

enum RedAsteroidMove {
    case Straight
    case Curvy
}

class RedAsteroidNode: SKSpriteNode {
    
    
    var RedAsteroidSpeed: CGFloat = 550.0 // (speed is x px per second)
    var move: RedAsteroidMove = .Straight
    
    private var animationFrames: [SKTexture] = []
    private let animatedAtlas = SKTextureAtlas(named: "asteroid1")
    
    // MARK: init
    
    init(scale: CGFloat) {
        
        let texture = SKTexture(imageNamed: "a1")
        let size = CGSize(width: texture.size().width * scale, height: texture.size().height * scale)
        super.init(texture: texture, color: UIColor.clear, size: size)

        
        //setup animation
        let numImages = animatedAtlas.textureNames.count
        for i in 1...numImages {
            let shieldTextureName = "a\(i)"
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
        let duration = distance / RedAsteroidSpeed
        
        return SKAction.move(to: to, duration: TimeInterval(duration))
    }
    
    private func curvyMove(from: CGPoint, to: CGPoint, control: Int, cpoint: Int) -> SKAction {
        
        let deltaX = from.x + CGFloat((100 * cpoint) * control)
        let deltaY = abs((from.y - to.y) / 2)
        
        
        let controlPoint = CGPoint(x: CGFloat(deltaX), y: deltaY)
        
        
        let bezierPath: UIBezierPath = UIBezierPath()
        bezierPath.move(to: from)
        bezierPath.addQuadCurve(to: to, controlPoint: controlPoint)
        
        return SKAction.follow(bezierPath.cgPath, asOffset: false, orientToPath: false, speed: RedAsteroidSpeed)
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
        let animateAction = SKAction.animate(with: animationFrames, timePerFrame: 0.05, resize: false, restore: true)
        let animation = SKAction.repeatForever(animateAction)
        self.run(animation)
    }
    
}




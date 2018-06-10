//
//  barrierNode.swift
//  Gravicaine
//
//  Created by stephen ball on 10/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit
import GameplayKit

class BarrierNode:SKSpriteNode {

    
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
    
    
    
    
    
}

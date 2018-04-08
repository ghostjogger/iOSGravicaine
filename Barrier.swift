//
//  Barrier.swift
//  Gravicaine
//
//  Created by Stephen Ball on 08/04/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit
import GameplayKit

class Barrier {
    
    static var Barriers = [SKSpriteNode]()
    static let widthFraction = 1536/6
    static let barrierHeight = 75
    
    init() {
        for i in 1...5{
            
            var node = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: i * Barrier.widthFraction, height: Barrier.barrierHeight))
            node.zPosition = 10
            Barrier.Barriers.append(node)
            
        }
    }
    
    
}

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
    static let barrierCountToFinish = 300
    static var barrierStoredCodes = [Int]()
    static let barrierFrequency: TimeInterval = 10.0
    static let widthFraction = 1536/6
    static let barrierHeight = 150
    

    
    
    init() {
        
        // setup barrier nodes from 1 segment width to 4
        // segments
        for i in 1...4{
            var node = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: i * Barrier.widthFraction, height: Barrier.barrierHeight))
            node.zPosition = 10
            node.name = "barrier"
            Barrier.Barriers.append(node)
        }
        
        //setup random ints  0 to 4 inc.
        for i in 1...Barrier.barrierCountToFinish{
            var c = Int(random(min: 0, max: 4.0))
            Barrier.barrierStoredCodes.append(c)
        }
    }
    
    
}

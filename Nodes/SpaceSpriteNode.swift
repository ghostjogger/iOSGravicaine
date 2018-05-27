//
//  SpaceSpriteNode.swift
//  Gravicaine
//
//  Created by Stephen Ball on 23/05/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit

enum SpaceSpriteNodeType {
    case Unkown
    case Planet
}

class SpaceSpriteNode: SKSpriteNode {
    var speedMultiplier: TimeInterval = 1.0
    var removeOnSceneExit: Bool = true
    var type: SpaceSpriteNodeType = SpaceSpriteNodeType.Unkown
}

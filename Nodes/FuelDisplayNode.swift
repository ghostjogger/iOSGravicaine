//
//  FuelDisplayNode.swift
//  Gravicaine
//
//  Created by Stephen Ball on 19/05/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit

class FuelDisplayNode: SKSpriteNode{
    
    
    let crop: SKCropNode = SKCropNode()
    let mask: SKSpriteNode = SKSpriteNode(color: UIColor.blue, size: CGSize.zero)
    let sprite: SKSpriteNode = SKSpriteNode(imageNamed: "fuel")
    
    static private let MaskSizeActionName = "FuelMaskSizeActionName"
    
    init() {
        
        super.init(texture: nil, color: UIColor.red.withAlphaComponent(0.25), size: sprite.size)
        
        self.anchorPoint = CGPoint.zero
        
        sprite.anchorPoint = CGPoint.zero
        sprite.position = CGPoint.zero
        
        crop.addChild(sprite)
        self.addChild(crop)
        
        mask.size = sprite.size
        mask.anchorPoint = CGPoint.zero
        crop.maskNode = mask

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}

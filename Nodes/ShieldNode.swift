//
//  ShieldNode.swift
//  Gravicaine
//
//  Created by stephen ball on 28/05/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit
import GameplayKit

class ShieldNode: SKSpriteNode{
    
    private var shieldAnimationFrames: [SKTexture] = []
    private let shieldAnimatedAtlas = SKTextureAtlas(named: "greenShield")
    private var shieldFrames: [SKTexture] = []
    
    init(scale: CGFloat) {
        let texture = SKTexture(imageNamed: "greenShield1")
        let size = CGSize(width: texture.size().width * scale, height: texture.size().height * scale)
        
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.name = "shield"
        self.zPosition = 3

        
        //setup shield animation
        let numImages = shieldAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let shieldTextureName = "greenShield\(i)"
            shieldFrames.append(shieldAnimatedAtlas.textureNamed(shieldTextureName))
        }
        shieldAnimationFrames = shieldFrames

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate(){
        let animateShieldAction = SKAction.animate(with: shieldAnimationFrames, timePerFrame: 0.02, resize: false, restore: false)
        let shieldAnimation = SKAction.repeatForever(animateShieldAction)
        self.run(shieldAnimation)
    }
    
    func stopAnimating(){
        self.removeAllActions()
        
        
    }
    
    
}

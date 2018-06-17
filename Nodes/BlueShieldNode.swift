//
//  BlueShieldNode.swift
//  Gravicaine
//
//  Created by Stephen Ball on 17/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit
import GameplayKit

class BlueShieldNode: SKSpriteNode{
    
    private var shieldAnimationFrames: [SKTexture] = []
    private let shieldAnimatedAtlas = SKTextureAtlas(named: "blueShield")
    private var shieldFrames: [SKTexture] = []
    
    init(scale: CGFloat) {
        let texture = SKTexture(imageNamed: "newshield1")
        let size = CGSize(width: texture.size().width * scale, height: texture.size().height * scale)
        
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.name = "shield"
        self.zPosition = 3
        
        
        //setup shield animation
        let numImages = shieldAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let shieldTextureName = "newshield\(i)"
            shieldFrames.append(shieldAnimatedAtlas.textureNamed(shieldTextureName))
        }
        shieldAnimationFrames = shieldFrames
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate(){
        let animateShieldAction = SKAction.animate(with: shieldAnimationFrames, timePerFrame: 0.06, resize: false, restore: false)
        let shieldAnimation = SKAction.repeatForever(animateShieldAction)
        self.run(shieldAnimation)
    }
    
    func stopAnimating(){
        self.removeAllActions()
        
        
    }
    
    
}

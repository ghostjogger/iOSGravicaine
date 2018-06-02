//
//  SKNodeExplosion.swift
//  Gravicaine
//
//  Created by Stephen Ball on 30/05/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//
import SpriteKit

extension SKNode {
    
    func explode(frames: [SKTexture], completion: @escaping (()->Void) = {}) {
        
        struct SKNodeExplosion {
            static let explosionSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
        }
        
        let animateExplosionAction = SKAction.animate(with: frames, timePerFrame: 0.05, resize: false, restore: false)
        let playerExplosionSequence = SKAction.sequence([ animateExplosionAction])
        self.removeAllActions()
        self.run(playerExplosionSequence, completion: {
            self.removeFromParent()
            completion()
        })
        
//        let boom = SKSpriteNode(imageNamed: "explosion")
//        boom.setScale(0.0)
//        boom.zPosition = self.zPosition + 0.1
//        boom.position = self.position
//        self.scene?.addChild(boom)
        
//        if removeFromParent {
//            self.removeFromParent()
//        } else {
//            self.isHidden = true
//        }
        
//        let boomAppear = SKAction.scale(to: GameScene.scale, duration: 0.2)
//        let boomFade = SKAction.fadeAlpha(to: 0.0, duration: 0.3)
//        let boomAction = SKAction.group([SKNodeExplosion.explosionSound, boomAppear, boomFade])
//        let removeBoom = SKAction.removeFromParent()
//
//        boom.run(SKAction.sequence([boomAction, removeBoom])) {
//            completion()
//        }
        
    }
    
}

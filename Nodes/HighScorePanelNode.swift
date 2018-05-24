//
//  HighScorePanelNode.swift
//  Gravicaine
//
//  Created by Stephen Ball on 23/05/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//


import Foundation
import SpriteKit

class HighScorePanelNode: SKSpriteNode {
    

    private static let FadeInTranslationY: CGFloat = 80.0
    
    let label: SKLabelNode = SKLabelNode()
    let scoreLabel: SKLabelNode = SKLabelNode()
    let labelVerticalSeparation = 25
    
    init(size: CGSize) {

        
        scoreLabel.fontSize = 52.0
        scoreLabel.fontName = FontName
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.text = "Congratulations New HIGH SCORE!!"
        
        label.fontSize = 80.0
        label.fontName = FontName
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "Enter your name below:"
        
        var pos = CGPoint(x: size.width / 2, y: size.height * 0.66)
        scoreLabel.position = pos
        pos.y -= scoreLabel.frame.size.height + CGFloat(labelVerticalSeparation)
        label.position = pos
        
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        self.addChild(scoreLabel)
        self.addChild(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animate(alpha: CGFloat, yTranslation: CGFloat, completion: @escaping ()->() = {}) {
        
        let fadeIn = SKAction.fadeAlpha(to: alpha, duration: 0.2)
        let moveUpScore = SKAction.moveTo(y: scoreLabel.position.y + yTranslation, duration: 0.2)
        let groupScore = SKAction.group([fadeIn, moveUpScore])
        
        scoreLabel.run(groupScore)
        
        let moveUpLabel = SKAction.moveTo(y: label.position.y + yTranslation, duration: 0.2)
        let groupLabel = SKAction.group([fadeIn, moveUpLabel])
        let waitLabel = SKAction.wait(forDuration: 0.1)
        
        label.run(SKAction.sequence([waitLabel, groupLabel])) {
            completion()
        }
        
    }
    
    func fadeIn(completion: @escaping ()->() = {}) {
        
        scoreLabel.alpha = 0.0
        scoreLabel.position.y -= HighScorePanelNode.FadeInTranslationY
        
        label.alpha = 0.0
        label.position.y -= HighScorePanelNode.FadeInTranslationY
        
        self.animate(alpha: 1.0, yTranslation: HighScorePanelNode.FadeInTranslationY, completion: completion)
        
    }
    
    func fadeOut(completion: @escaping ()->() = {}) {
        
        self.animate(alpha: 0.0, yTranslation: HighScorePanelNode.FadeInTranslationY) {
            self.label.position.y -= HighScorePanelNode.FadeInTranslationY
            completion()
        }
        
    }
    
}

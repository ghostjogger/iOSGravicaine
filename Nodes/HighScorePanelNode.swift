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
    
    let gameOverLabel: SKLabelNode = SKLabelNode()
    let label: SKLabelNode = SKLabelNode()
    let highScoreLabel: SKLabelNode = SKLabelNode()
    let congratsLabel: SKLabelNode = SKLabelNode()
    let scoreLabel: SKLabelNode = SKLabelNode()
    let nameLabel: SKLabelNode = SKLabelNode()
    let score: Int
    let labelVerticalSeparation = 25
    
    init(size: CGSize, score: Int) {
        
        self.score = score
        
        congratsLabel.fontSize = 52.0
        congratsLabel.fontName = FontName
        congratsLabel.horizontalAlignmentMode = .center
        congratsLabel.verticalAlignmentMode = .center
        congratsLabel.text = "CONGRATULATIONS - NEW HIGH SCORE!!"
        
        scoreLabel.fontSize = 52.0
        scoreLabel.fontName = FontName
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.text = "\(self.score)"
        
        nameLabel.fontSize = 52.0
        nameLabel.fontName = FontName
        nameLabel.horizontalAlignmentMode = .center
        nameLabel.verticalAlignmentMode = .center
        nameLabel.text = "PLEASE ENTER YOUR NAME:"
        
        
        
//        gameOverLabel.fontSize = 80.0
//        gameOverLabel.fontName = FontName
//        gameOverLabel.horizontalAlignmentMode = .center
//        gameOverLabel.verticalAlignmentMode = .center
//        gameOverLabel.text = "Game Over!"
        
//        label.fontSize = 80.0
//        label.fontName = FontName
//        label.horizontalAlignmentMode = .center
//        label.verticalAlignmentMode = .center
//        label.text = "TAP TO PLAY AGAIN"
        
        var pos = CGPoint(x: size.width / 2, y: size.height * 0.66)
        congratsLabel.position = pos
        pos.y -= scoreLabel.frame.size.height + CGFloat(labelVerticalSeparation)
        scoreLabel.position = pos
        pos.y -= scoreLabel.frame.size.height + CGFloat(labelVerticalSeparation)
        nameLabel.position = pos

        
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        self.addChild(congratsLabel)
        self.addChild(scoreLabel)
        self.addChild(nameLabel)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animate(alpha: CGFloat, yTranslation: CGFloat, completion: @escaping ()->() = {}) {
        
        let fadeIn = SKAction.fadeAlpha(to: alpha, duration: 0.2)
        let moveUpScore = SKAction.moveTo(y: scoreLabel.position.y + yTranslation, duration: 0.2)
        let groupScore = SKAction.group([fadeIn, moveUpScore])
        
        scoreLabel.run(groupScore)
        
        let moveUpLabel = SKAction.moveTo(y: nameLabel.position.y + yTranslation, duration: 0.2)
        let groupLabel = SKAction.group([fadeIn, moveUpLabel])
        let waitLabel = SKAction.wait(forDuration: 0.1)
        
        nameLabel.run(SKAction.sequence([waitLabel, groupLabel])) {
            completion()
        }
        
    }
    
    func fadeIn(completion: @escaping ()->() = {}) {
        
//        congratsLabel.alpha = 0.0
//        congratsLabel.position.y -= HighScorePanelNode.FadeInTranslationY
        
        scoreLabel.alpha = 0.0
        scoreLabel.position.y -= HighScorePanelNode.FadeInTranslationY
        
//        nameLabel.alpha = 0.0
//        nameLabel.position.y -= HighScorePanelNode.FadeInTranslationY
        
        self.animate(alpha: 1.0, yTranslation: HighScorePanelNode.FadeInTranslationY, completion: completion)
        
    }
    
    func fadeOut(completion: @escaping ()->() = {}) {
        
        self.animate(alpha: 0.0, yTranslation: HighScorePanelNode.FadeInTranslationY) {
            self.congratsLabel.position.y -= HighScorePanelNode.FadeInTranslationY
            completion()
        }
        
    }
    
    
}

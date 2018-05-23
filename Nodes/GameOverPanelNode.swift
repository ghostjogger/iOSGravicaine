//
//  GameOverPanelNode.swift
//  Gravicaine
//
//  Created by stephen ball on 16/04/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverPanelNode: SKSpriteNode {
    
    
    private static let FadeInTranslationY: CGFloat = 80.0
    
    let gameOverLabel: SKLabelNode = SKLabelNode()
    let label: SKLabelNode = SKLabelNode()
    let highScoreLabel: SKLabelNode = SKLabelNode()
    let scoreLabel: SKLabelNode = SKLabelNode()
    let score: Int
    let labelVerticalSeparation = 25
    
    init(size: CGSize, score: Int) {
        
        self.score = score
        let highScore = UserDefaults.standard.integer(forKey: HighScoreKey)
        var highScoreName = UserDefaults.standard.string(forKey: HighScoreName)
        
        if highScoreName == nil {
            highScoreName = ""
        }
        
        scoreLabel.fontSize = 52.0
        scoreLabel.fontName = FontName
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.text = "Your Score : \(self.score)"
        
        highScoreLabel.fontSize = 52.0
        highScoreLabel.fontName = FontName
        highScoreLabel.horizontalAlignmentMode = .center
        highScoreLabel.verticalAlignmentMode = .center
        highScoreLabel.text = "HIGH SCORE by \(highScoreName!) is \(highScore)"
        
        gameOverLabel.fontSize = 80.0
        gameOverLabel.fontName = FontName
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.verticalAlignmentMode = .center
        gameOverLabel.text = "Game Over!"
        
        label.fontSize = 80.0
        label.fontName = FontName
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "TAP TO PLAY AGAIN"
        
        var pos = CGPoint(x: size.width / 2, y: size.height * 0.66)
        gameOverLabel.position = pos
        pos.y -= scoreLabel.frame.size.height + CGFloat(labelVerticalSeparation)
        scoreLabel.position = pos
        pos.y -= scoreLabel.frame.size.height + CGFloat(labelVerticalSeparation)
        highScoreLabel.position = pos
        pos.y -= scoreLabel.frame.size.height + CGFloat(labelVerticalSeparation)
        label.position = pos
        
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        self.addChild(gameOverLabel)
        self.addChild(scoreLabel)
        self.addChild(highScoreLabel)
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
        scoreLabel.position.y -= GameOverPanelNode.FadeInTranslationY
        
        label.alpha = 0.0
        label.position.y -= GameOverPanelNode.FadeInTranslationY
        
        self.animate(alpha: 1.0, yTranslation: GameOverPanelNode.FadeInTranslationY, completion: completion)
        
    }
    
    func fadeOut(completion: @escaping ()->() = {}) {
        
        self.animate(alpha: 0.0, yTranslation: GameOverPanelNode.FadeInTranslationY) {
            self.label.position.y -= GameOverPanelNode.FadeInTranslationY
            completion()
        }
        
    }
    
    
}

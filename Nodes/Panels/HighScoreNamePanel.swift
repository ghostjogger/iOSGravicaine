//
//  HighScoreNamePanel.swift
//  Gravicaine
//
//  Created by stephen ball on 29/05/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import Foundation
import SpriteKit

class HighScoreNamePanel: SKSpriteNode {
    
    
    private static let FadeInTranslationY: CGFloat = 80.0
    
    let background = SKSpriteNode(imageNamed: "panelBackground")
    let gameOverLabel: SKLabelNode = SKLabelNode()
    let label: SKLabelNode = SKLabelNode()
    let highScoreLabel: SKLabelNode = SKLabelNode()
    let scoreLabel: SKLabelNode = SKLabelNode()
    let labelVerticalSeparation = 30
    
    init(size: CGSize) {
        
        let highScore = UserDefaults.standard.integer(forKey: HighScoreKey)
        let highScoreName = UserDefaults.standard.string(forKey: HighScoreName)
        
        let scale = size.width/CGFloat(maxDeviceScreenWidth)
        
        scoreLabel.fontSize = 70.0 * scale
        scoreLabel.fontName = FontName
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.text = "High Score:"
        
        highScoreLabel.fontSize = 60.0 * scale
        highScoreLabel.fontName = FontName
        highScoreLabel.horizontalAlignmentMode = .center
        highScoreLabel.verticalAlignmentMode = .center
        if highScoreName != nil
        {
            highScoreLabel.text = "\(highScoreName!)"
        }
        else
        {
            highScoreLabel.text = ""
        }
        
        gameOverLabel.fontSize = 70.0 * scale
        gameOverLabel.fontName = FontName
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.verticalAlignmentMode = .center
        if highScore != 0
        {
            gameOverLabel.text = "\(highScore)"
        }
        else
        {
            gameOverLabel.text = ""
        }
        
        label.fontSize = 80.0 * scale
        label.fontName = FontName
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = ""
        
        background.size = CGSize(width: background.size.width * scale,
                                 height: background.size.height * scale)
        var pos = CGPoint(x: size.width / 2, y: size.height * 0.25)
        background.position = pos
        
        pos = CGPoint(x: size.width / 2, y: size.height * 0.30)
        scoreLabel.position = pos
        pos.y -= scoreLabel.frame.size.height + (CGFloat(labelVerticalSeparation) * scale)
        highScoreLabel.position = pos
        pos.y -= scoreLabel.frame.size.height + (CGFloat(labelVerticalSeparation) * scale)
        gameOverLabel.position = pos
        pos.y -= scoreLabel.frame.size.height + (CGFloat(labelVerticalSeparation) * scale)
        label.position = pos
        
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        self.addChild(background)
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
        scoreLabel.position.y -= HighScoreNamePanel.FadeInTranslationY
        
        label.alpha = 0.0
        label.position.y -= HighScoreNamePanel.FadeInTranslationY
        
        self.animate(alpha: 1.0, yTranslation: HighScoreNamePanel.FadeInTranslationY, completion: completion)
        
    }
    
    func fadeOut(completion: @escaping ()->() = {}) {
        
        self.animate(alpha: 0.0, yTranslation: HighScoreNamePanel.FadeInTranslationY) {
            self.label.position.y -= HighScoreNamePanel.FadeInTranslationY
            completion()
        }
        
    }
    
    
}


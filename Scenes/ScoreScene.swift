//
//  ScoreScene.swift
//  Gravicaine
//
//  Created by Stephen Ball on 20/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//
import SpriteKit
import GameplayKit

class ScoreScene: SKScene{
    
    let backgroundImage = SKSpriteNode(imageNamed: "panelBackground")
    let titleLabel = SKLabelNode(text: "Highest Score:")
    var highNameLabel = SKLabelNode(text: "")
    var highScoreLabel = SKLabelNode(text: "")
    
    let backLabel = SKSpriteNode(imageNamed: "back")
    
    var titleScaleFactor = 1.0
    var scale:CGFloat = 1.0
    
    var score:Int
    var highScoreName: String?
    
    override init(size: CGSize) {
        
        score = UserDefaults.standard.integer(forKey: HighScoreKey)
        highScoreName = UserDefaults.standard.string(forKey: HighScoreName)
        
        highNameLabel.text = highScoreName
        highScoreLabel.text = "\(score)"
        

        
        super.init(size: size)
        
        titleScaleFactor = (Double(self.frame.width) / Double(maxDeviceScreenWidth)) * 0.85
        scale = CGFloat(self.frame.width / CGFloat(maxDeviceScreenWidth))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        
        backgroundImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backgroundImage.size = self.size
        backgroundImage.zPosition = 0
        self.addChild(backgroundImage)
        
        titleLabel.fontName = FontName
        titleLabel.fontSize = 60 * scale
        titleLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.9)
        self.addChild(titleLabel)
        
        highNameLabel.fontName = FontName
        highNameLabel.fontSize = 55 * scale
        highNameLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.75)
        
        highScoreLabel.fontName = FontName
        highScoreLabel.fontSize = 70 * scale
        highScoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.65)
        
        if self.score > 0{
            self.addChild(highNameLabel)
            self.addChild(highScoreLabel)
        }
        

        
        backLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.1)
        backLabel.zPosition = 20
        backLabel.size = CGSize(width: backLabel.size.width * self.scale,
                                height: backLabel.size.height * self.scale)
        self.addChild(backLabel)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if backLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition:myTransition)
                
            }
            
        }
    }
    
}



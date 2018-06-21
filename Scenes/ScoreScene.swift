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
    let titleImage = SKSpriteNode(imageNamed: "gravicaineTitle")
    
    let backLabel = SKSpriteNode(imageNamed: "back")
    
    var titleScaleFactor = 1.0
    var scale:CGFloat = 1.0
    
    
    override init(size: CGSize) {
        
        

        
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
        
        
        titleImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.90)
        titleImage.zPosition = 10
        titleImage.setScale(CGFloat(titleScaleFactor))
        //self.addChild(titleImage)
        
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



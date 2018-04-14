//
//  MainMenuScene.swift
//  Gravicaine
//
//  Created by Stephen Ball on 07/04/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit
import GameplayKit



class MainMenuScene: SKScene{
    
    let startLabel = SKLabelNode(text: "Start")
    let signatureLabel = SKLabelNode(text: "Stephen Ball's")
    let backgroundImage = SKSpriteNode(imageNamed: "titleBackground")
    let titleImage = SKSpriteNode(imageNamed: "gravicaineTitle")
    let ship = SpaceShip()
    
    //protonStar animation variables
    
    private var protonStarFrames: [SKTexture] = []
    let protonStarAnimatedAtlas = SKTextureAtlas(named: "protonStar")
    var protonFrames: [SKTexture] = []
    
    //galaxy animation variables
    
    private var galaxyFrames: [SKTexture] = []
    let galaxyAnimatedAtlas = SKTextureAtlas(named: "galaxy")
    var galFrames: [SKTexture] = []
    
    

    override init(size:CGSize) {
        
        //setup protonStar animation
        var numImages = protonStarAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let textureName = "protonStar\(i)"
            protonFrames.append(protonStarAnimatedAtlas.textureNamed(textureName))
        }
        protonStarFrames = protonFrames
        
        //setup galaxy animation
        numImages = galaxyAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let textureName = "galaxy\(i)"
            galFrames.append(galaxyAnimatedAtlas.textureNamed(textureName))
        }
        galaxyFrames = galFrames
        
        super.init(size: size)
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        backgroundImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        backgroundImage.zPosition = 0
        self.addChild(backgroundImage)
        
        
        titleImage.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.85)
        titleImage.zPosition = 1
        titleImage.setScale(0.9)
        self.addChild(titleImage)
        
        ship.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.3)
        ship.zPosition = 2
        self.addChild(ship)

        
        startLabel.fontName = "Jellee-Roman"
        startLabel.fontColor = UIColor.white
        startLabel.fontSize = 100
        startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.1)
        self.addChild(startLabel)
        
        signatureLabel.fontName = "Jellee-Roman"
        signatureLabel.fontColor = UIColor.white
        signatureLabel.fontSize = 80
        signatureLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.9)
        self.addChild(signatureLabel)
        

        
    }
    
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if startLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition:myTransition)
            }
            
        }
 
    }
    
    
}

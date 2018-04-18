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
    
    //star animation variables
    
    private var protonStarFrames: [SKTexture] = []
    let protonStarAnimatedAtlas = SKTextureAtlas(named: "star")
    var protonFrames: [SKTexture] = []
    

    override init(size:CGSize) {
        
        //setup star animation
        var numImages = protonStarAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let textureName = "star\(i)"
            protonFrames.append(protonStarAnimatedAtlas.textureNamed(textureName))
        }
        protonStarFrames = protonFrames
        
 
        
        super.init(size: size)

    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var lastUpdateTime:TimeInterval = 0
    var deltaFrameTime:TimeInterval = 0
    var animationTimer:TimeInterval = 0
    let animationTimeInterval = 0.2
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0
        {
            lastUpdateTime = currentTime
        }
        else
        {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
            animationTimer += deltaFrameTime
        }
        
        if animationTimer > animationTimeInterval{
            spawnAnimation()
            animationTimer = 0
        }
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
    
    func spawnAnimation(){

            let node = SKSpriteNode(texture: protonFrames[0])
            node.setScale(0.8)
            let action = SKAction.animate(with: protonFrames, timePerFrame: 0.2, resize: false, restore: false)
            let deleteAction = SKAction.removeFromParent()
            let sequence = SKAction.sequence([action,deleteAction])
            node.zPosition = 10
            node.position = CGPoint(x: random(min: (self.size.width/2) - 500, max: (self.size.width/2) + 500),
                                    y: random(min: (self.size.width/2) - 400, max: (self.size.width/2) + 700))
            self.addChild(node)
            node.run(sequence)
     
    }
    
    
}

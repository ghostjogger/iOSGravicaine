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
    
    let startLabel = SKSpriteNode(imageNamed: "playButton")
    let optionLabel = SKSpriteNode(imageNamed: "optionButton")
    let creditLabel = SKSpriteNode(imageNamed: "creditButton")
    let signatureLabel = SKLabelNode(text: "Stephen Ball's")
    let backgroundImage = SKSpriteNode(imageNamed: "titleBackground")
    let titleImage = SKSpriteNode(imageNamed: "gravicaineTitle")
    
    let highScoreLabel = SKLabelNode(text: "High Score")
    let highScoreNameLabel = SKLabelNode(text: "")
    let highScoreScoreLabel = SKLabelNode(text: "")
    
    var titleTextures = [SKTexture]()
    
    let titleSound = SKAction.playSoundFileNamed("sound43.wav", waitForCompletion: false)
    let titleEndSound = SKAction.playSoundFileNamed("sound62.wav", waitForCompletion: false)
    var titleScaleFactor = 1.0
    
    var scale:CGFloat = 1.0
    
    private var highScorePanel: HighScoreNamePanel? = nil
    
    //star animation variables
    
    private var protonStarFrames: [SKTexture] = []
    let protonStarAnimatedAtlas = SKTextureAtlas(named: "star")
    var protonFrames: [SKTexture] = []

    override init(size:CGSize) {
        
        //setup star animation
        let numImages = protonStarAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let textureName = "star\(i)"
            protonFrames.append(protonStarAnimatedAtlas.textureNamed(textureName))
        }
        protonStarFrames = protonFrames
      
        super.init(size: size)
        
        titleScaleFactor = (Double(self.frame.width) / Double(maxDeviceScreenWidth)) * 0.85
        scale = CGFloat(self.frame.width / CGFloat(maxDeviceScreenWidth))

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
        
        backgroundImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backgroundImage.size = self.size
        backgroundImage.zPosition = 0
        self.addChild(backgroundImage)
        
        optionLabel.position = CGPoint(x: self.frame.width * 0.2, y: self.frame.height * 0.05)
        optionLabel.size = CGSize(width: optionLabel.size.width * scale, height: optionLabel.size.height * scale )
        self.addChild(optionLabel)

        startLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.05)
        startLabel.size = CGSize(width: startLabel.size.width * scale, height: startLabel.size.height * scale )
        self.addChild(startLabel)
        
        creditLabel.position = CGPoint(x: self.frame.width * 0.8, y: self.frame.height * 0.05)
        creditLabel.size = CGSize(width: creditLabel.size.width * scale, height: creditLabel.size.height * scale )
        self.addChild(creditLabel)

        
        titleImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.85)
        titleImage.zPosition = 10
        titleImage.setScale(5.0)
        addChild(titleImage)
        let titleAction = SKAction.scale(to: CGFloat(titleScaleFactor), duration: 1.4)
        let titleSequence = SKAction.sequence([titleSound,titleAction,titleEndSound])
        titleImage.run(titleSequence){
            
            if UserDefaults.standard.string(forKey: HighScoreName) != nil{
                
                self.highScorePanel?.removeFromParent()
                self.highScorePanel = HighScoreNamePanel(size: self.size)
                self.highScorePanel?.zPosition = 50
                self.addChild(self.highScorePanel!)
                self.highScorePanel?.fadeIn()
                
            }
            
        }

        
        

        
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
            
            else if optionLabel.contains(pointOfTouch){
                
                
            }
                
            else if creditLabel.contains(pointOfTouch){
                
                
                
            }
            
        }
 
    }
    
    func spawnAnimation(){

            let node = SKSpriteNode(texture: protonFrames[0])
            node.setScale(0.8)
            let action = SKAction.animate(with: protonFrames, timePerFrame: 0.1, resize: false, restore: false)
            let deleteAction = SKAction.removeFromParent()
            let sequence = SKAction.sequence([action,deleteAction])
            node.zPosition = 5
            node.position = CGPoint(x: random(min: (self.frame.midX) - self.frame.width/2, max: (self.frame.midX) + self.frame.width/2),
                                    y: random(min: (self.frame.midY) - self.frame.height, max: (self.frame.midY)) + self.frame.height/2)

            self.addChild(node)
            node.run(sequence)
     
    }
    
    
}

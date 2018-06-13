//
//  MainMenuScene.swift
//  Gravicaine
//
//  Created by Stephen Ball on 07/04/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit
import GameplayKit
import SwiftEntryKit



class MainMenuScene: SKScene{
    
    let startLabel = SKSpriteNode(imageNamed: "play")
    let optionLabel = SKSpriteNode(imageNamed: "options")
    let scoresLabel = SKSpriteNode(imageNamed: "score")
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
    
    var score:Int
    var highScoreName: String?
    
    //score panel setup
    var scoreattributes: EKAttributes
    var scoremessage: EKSimpleMessage
    var scorenotificationMessage: EKNotificationMessage
    var scorenotificationView: EKNotificationMessageView
    
    //options panel setup

    
    var optionBackground = SKSpriteNode(imageNamed: "panelBackground")
    var musicLabel = SKLabelNode(text: "Game Music")
    var music: Bool
    var musicNode: SKSpriteNode = SKSpriteNode()

    
    
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
        
        //setup initial option values here
        if !UserDefaults.standard.bool(forKey: "firstTimeRun"){
            UserDefaults.standard.set(true, forKey: "firstTimeRun")
            UserDefaults.standard.set(true, forKey: "music")
            UserDefaults.standard.set("", forKey: HighScoreName)
        }
        
        score = UserDefaults.standard.integer(forKey: HighScoreKey)
        music = UserDefaults.standard.bool(forKey: "music")
        highScoreName = UserDefaults.standard.string(forKey: HighScoreName)

        
        // score panel
        scoreattributes = EKAttributes.centerFloat
        scoreattributes.displayDuration = 3.0
        scoreattributes.entryInteraction = .dismiss
        scoreattributes.entryBackground = .image(image: UIImage(named: "panelBackground")!)
        scoreattributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        scoreattributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        scoremessage = EKSimpleMessage(image: EKProperty.ImageContent(imageName: "gravicaineIcon32"),
                                  title: EKProperty.LabelContent(text: "Highest Score",
                                                                 style: EKProperty.Label(font: UIFont(name: FontName, size: 20.0)!, color: UIColor.white, alignment: NSTextAlignment.center)),
                                  description: EKProperty.LabelContent(text: "\(highScoreName!) \n\n   \(score)",
                                    style: EKProperty.Label(font: UIFont(name: FontName, size: 15.0)!, color: UIColor.white, alignment: NSTextAlignment.center)))
        
        scorenotificationMessage = EKNotificationMessage(simpleMessage: scoremessage)
        scorenotificationView = EKNotificationMessageView(with: scorenotificationMessage)

        
        musicLabel.fontSize = 40.0 * scale
        musicLabel.fontName = FontName
        //musicLabel.horizontalAlignmentMode = .center
        //musicLabel.verticalAlignmentMode = .top
       

        

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
        
        optionBackground.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2
        )
        optionBackground.size = CGSize(width: 1000 * scale, height: 1300 * scale)
        optionBackground.zPosition = 100
        
        if music{
            musicNode = SKSpriteNode(imageNamed: "on")
            musicNode.size = CGSize(width: musicNode.size.width * scale,
                                    height: musicNode.size.height * scale)
        }
        else{
            musicNode = SKSpriteNode(imageNamed: "off")
            musicNode.size = CGSize(width: musicNode.size.width * scale,
                                    height: musicNode.size.height * scale)
        }
        
        optionLabel.position = CGPoint(x: self.frame.width * 0.2, y: self.frame.height * 0.05)
        optionLabel.size = CGSize(width: optionLabel.size.width * scale, height: optionLabel.size.height * scale )
        self.addChild(optionLabel)
        
        startLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.05)
        startLabel.size = CGSize(width: startLabel.size.width * scale, height: startLabel.size.height * scale )
        self.addChild(startLabel)
        
        scoresLabel.position = CGPoint(x: self.frame.width * 0.8, y: self.frame.height * 0.05)
        scoresLabel.size = CGSize(width: scoresLabel.size.width * scale, height: scoresLabel.size.height * scale )
        self.addChild(scoresLabel)

 
        titleImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.90)
        titleImage.zPosition = 10
        titleImage.setScale(5.0)
        addChild(titleImage)
        let titleAction = SKAction.scale(to: CGFloat(titleScaleFactor), duration: 1.4)
        let titleSequence = SKAction.sequence([titleSound, titleAction,titleEndSound])
        titleImage.run(titleSequence){
     
 
            
        }
      
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if self.children.contains(musicNode){
                if musicNode.contains(pointOfTouch){
                    toggleMusic()
                }
 
            }
            
            if startLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                SwiftEntryKit.dismiss()
                self.view!.presentScene(sceneToMoveTo, transition:myTransition)
            }
                
                
            else if optionLabel.contains(pointOfTouch){

                if !self.children.contains(optionBackground){
                    musicLabel.position = CGPoint(x: optionBackground.position.x,
                                                   y: optionBackground.position.y + CGFloat(musicY) * scale)

                    musicLabel.zPosition = 200
                    self.addChild(musicLabel)

                    
                    self.addChild(optionBackground)
                    
                    musicNode.zPosition = 200
                    musicNode.position = CGPoint(x: optionBackground.position.x,
                                                 y: optionBackground.position.y + CGFloat(musicY - 90) * scale)
                    self.addChild(musicNode)

                    
                    
                    SwiftEntryKit.dismiss()
                }
                else{
                   
                    optionBackground.removeFromParent()
                    musicLabel.removeFromParent()
                    musicNode.removeFromParent()

                }
                
                
            }
                
            else if scoresLabel.contains(pointOfTouch){
                
                if score != 0 && !self.children.contains(optionBackground){
                    SwiftEntryKit.display(entry: self.scorenotificationView, using: self.scoreattributes)
                }
               
            }
                
            
        }
    }
    
    func toggleMusic(){
        
        music = !music
        UserDefaults.standard.set(music, forKey: "music")
        
        if music{
            
            musicNode.removeFromParent()
            musicNode = SKSpriteNode(imageNamed: "on")
            musicNode.zPosition = 200
            musicNode.size = CGSize(width: musicNode.size.width * scale,
                                    height: musicNode.size.height * scale)
            musicNode.position = CGPoint(x: optionBackground.position.x,
                                         y: optionBackground.position.y + CGFloat(musicY - 90) * scale)
            self.addChild(musicNode)
            
        }
        else{
            musicNode.removeFromParent()
            musicNode = SKSpriteNode(imageNamed: "off")
            musicNode.zPosition = 200
            musicNode.size = CGSize(width: musicNode.size.width * scale,
                                    height: musicNode.size.height * scale)
            musicNode.position = CGPoint(x: optionBackground.position.x,
                                         y: optionBackground.position.y + CGFloat(musicY - 90) * scale)
            self.addChild(musicNode)
            
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

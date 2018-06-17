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
    var transLabel = SKLabelNode(text: "Grav Transition Marker")
    var music: Bool
    var trans: Bool
    var musicNode: SKSpriteNode = SKSpriteNode()
    var transNode: SKSpriteNode = SKSpriteNode()
    

    
    
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
            UserDefaults.standard.set(true, forKey: "trans")
            UserDefaults.standard.set("", forKey: HighScoreName)
        }
        
        score = UserDefaults.standard.integer(forKey: HighScoreKey)
        music = UserDefaults.standard.bool(forKey: "music")
        trans = UserDefaults.standard.bool(forKey: "trans")
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

        transLabel.fontSize = 40.0 * scale
        transLabel.fontName = FontName
       

        

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
        
        optionBackground.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.58
        )
        optionBackground.size = CGSize(width: self.frame.width * 0.8, height: self.frame.height * 0.5)
        optionBackground.zPosition = 200
        
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
        
        if trans{
            transNode = SKSpriteNode(imageNamed: "on")
            transNode.size = CGSize(width: transNode.size.width * scale,
                                    height: transNode.size.height * scale)
        }
        else{
            transNode = SKSpriteNode(imageNamed: "off")
            transNode.size = CGSize(width: transNode.size.width * scale,
                                    height: transNode.size.height * scale)
        }
        

        let mine = MineNode(scale: scale)
        mine.zPosition = 200
        mine.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(mine)
        mine.animate()
        
        let bomb1 = BombNode(scale: scale)
        bomb1.zPosition = 200
        bomb1.position = CGPoint(x: self.frame.width * 0.25, y: self.frame.height * 0.6)
        self.addChild(bomb1)
        bomb1.animate()
        
        let beam = LaserBeamNode(scale: scale)
        beam.zPosition = 200
        beam.position = CGPoint(x: bomb1.position.x + (bomb1.size.width/2 + beam.size.width/2),
                                y: self.frame.height * 0.6)
        self.addChild(beam)
        beam.animate()
        
        let beam1 = LaserBeamNode(scale: scale)
        beam1.zPosition = 200
        beam1.position = CGPoint(x: beam.position.x + beam.size.width,
                                y: self.frame.height * 0.6)
        self.addChild(beam1)
        beam1.animate()
        
        let beam2 = LaserBeamNode(scale: scale)
        beam2.zPosition = 200
        beam2.position = CGPoint(x: beam1.position.x + beam.size.width,
                                 y: self.frame.height * 0.6)
        self.addChild(beam2)
        beam2.animate()
        
        let bomb2 = BombNode(scale: scale)
        bomb2.zPosition = 200
        bomb2.position = CGPoint(x: beam2.position.x + (beam.size.width/2 + bomb2.size.width/2),
            y: self.frame.height * 0.6)
        self.addChild(bomb2)
        bomb2.animate()
        
        

 
        titleImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.90)
        titleImage.zPosition = 10
        titleImage.setScale(5.0)
        addChild(titleImage)
        let titleAction = SKAction.scale(to: CGFloat(titleScaleFactor), duration: 1.4)
        let titleSequence = SKAction.sequence([titleSound, titleAction,titleEndSound])
        titleImage.run(titleSequence){
     
 
            let laser = GreenShieldNode(scale: self.scale)
            laser.zPosition = 100
            laser.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.2)
            self.addChild(laser)
            laser.animate()
            
            let laser1 = BlueShieldNode(scale: self.scale)
            laser1.zPosition = 100
            laser1.position = CGPoint(x: self.frame.width * 0.15, y: self.frame.height * 0.2)
            self.addChild(laser1)
            laser1.animate()
            
            let laser2 = BlueShieldNode(scale: self.scale)
            laser2.zPosition = 100
            laser2.position = CGPoint(x: self.frame.width * 0.85, y: self.frame.height * 0.2)
            self.addChild(laser2)
            laser2.animate()
            
            
            self.optionLabel.position = CGPoint(x: self.frame.width * 0.15, y: self.frame.height * 0.2)
            self.optionLabel.size = CGSize(width: self.optionLabel.size.width * self.scale, height: self.optionLabel.size.height * self.scale )
            self.addChild(self.optionLabel)
            
            self.startLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.2)
            self.startLabel.size = CGSize(width: self.startLabel.size.width * self.scale, height: self.startLabel.size.height * self.scale )
            self.addChild(self.startLabel)
            
            self.scoresLabel.position = CGPoint(x: self.frame.width * 0.85, y: self.frame.height * 0.2)
            self.scoresLabel.size = CGSize(width: self.scoresLabel.size.width * self.scale, height: self.scoresLabel.size.height * self.scale )
            self.addChild(self.scoresLabel)
            
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
            
            if self.children.contains(transNode){
                if transNode.contains(pointOfTouch){
                    toggleTrans()
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
                                                   y: self.frame.height * 0.75)

                    musicLabel.zPosition = 250
                    self.addChild(musicLabel)
                    
                    transLabel.position = CGPoint(x: optionBackground.position.x,
                                                  y: self.frame.height * 0.6)
                    transLabel.zPosition = 250
                    self.addChild(transLabel)

                    
                    self.addChild(optionBackground)
                    
                    musicNode.zPosition = 200
                    musicNode.position = CGPoint(x: optionBackground.position.x,
                                                 y: self.frame.height * 0.70)
                    self.addChild(musicNode)
                    
                    transNode.zPosition = 200
                    transNode.position = CGPoint(x: optionBackground.position.x,
                                                 y: self.frame.height * 0.55)
                    self.addChild(transNode)

                    
                    
                    SwiftEntryKit.dismiss()
                }
                else{
                   
                    optionBackground.removeFromParent()
                    musicLabel.removeFromParent()
                    musicNode.removeFromParent()
                    transLabel.removeFromParent()
                    transNode.removeFromParent()

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
                                         y: self.frame.height * 0.70)
            self.addChild(musicNode)
            
        }
        else{
            musicNode.removeFromParent()
            musicNode = SKSpriteNode(imageNamed: "off")
            musicNode.zPosition = 200
            musicNode.size = CGSize(width: musicNode.size.width * scale,
                                    height: musicNode.size.height * scale)
            musicNode.position = CGPoint(x: optionBackground.position.x,
                                         y: self.frame.height * 0.70)
            self.addChild(musicNode)
            
        }
        
        
    }
    
    func toggleTrans(){
        
        trans = !trans
        UserDefaults.standard.set(trans, forKey: "trans")
        
        if trans{
            
            transNode.removeFromParent()
            transNode = SKSpriteNode(imageNamed: "on")
            transNode.zPosition = 200
            transNode.size = CGSize(width: transNode.size.width * scale,
                                    height: transNode.size.height * scale)
            transNode.position = CGPoint(x: optionBackground.position.x,
                                         y: self.frame.height * 0.55)
            self.addChild(transNode)
            
        }
        else{
            transNode.removeFromParent()
            transNode = SKSpriteNode(imageNamed: "off")
            transNode.zPosition = 200
            transNode.size = CGSize(width: transNode.size.width * scale,
                                    height: transNode.size.height * scale)
            transNode.position = CGPoint(x: optionBackground.position.x,
                                         y: self.frame.height * 0.55)
            self.addChild(transNode)
            
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

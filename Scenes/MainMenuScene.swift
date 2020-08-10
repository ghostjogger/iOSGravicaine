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
    let creditLabel = SKSpriteNode(imageNamed: "credits")
    let backgroundImage = SKSpriteNode(imageNamed: "titleBackground")
    let titleImage = SKSpriteNode(imageNamed: "gravicaineTitle")

    var titleScaleFactor = 1.0
    var scale:CGFloat = 1.0

    //score panel setup
    var scoreattributes: EKAttributes
    var scoremessage: EKSimpleMessage
    var scorenotificationMessage: EKNotificationMessage
    var scorenotificationView: EKNotificationMessageView
    
    //credit panel setup
    var creditattributes: EKAttributes
    var creditmessage: EKSimpleMessage
    var creditnotificationMessage: EKNotificationMessage
    var creditnotificationView: EKNotificationMessageView

    //star animation variables
    
    private var protonStarFrames: [SKTexture] = []
    let protonStarAnimatedAtlas = SKTextureAtlas(named: "star")
    var protonFrames: [SKTexture] = []
    
    var score:Int
    var highScoreName: String?
    
    var musicLabel = SKLabelNode(text: "Game Music")
    var transLabel = SKLabelNode(text: "Grav Transition Marker")
    var music: Bool
    var trans: Bool
    var musicNode: SKSpriteNode = SKSpriteNode()
    var transNode: SKSpriteNode = SKSpriteNode()
    
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
        highScoreName = UserDefaults.standard.string(forKey: HighScoreName)
        music = UserDefaults.standard.bool(forKey: "music")
        trans = UserDefaults.standard.bool(forKey: "trans")
        
        musicLabel.fontSize = 30.0 * scale
        musicLabel.fontName = FontName
        
        transLabel.fontSize = 30.0 * scale
        transLabel.fontName = FontName
        
        // highest score pop-up
        scoreattributes = EKAttributes.centerFloat
        scoreattributes.displayDuration = 3.0
        scoreattributes.entryInteraction = .dismiss
        scoreattributes.entryBackground = .image(image: UIImage(named: "panelBackground")!)
        scoreattributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        scoreattributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        
        if UserDefaults.standard.string(forKey: GlobalScoreName) == nil {
            scoremessage = EKSimpleMessage(image: EKProperty.ImageContent(imageName: "gravicaineIcon32"),
                                           title: EKProperty.LabelContent(text: "Highest Score:",
                                                                          style: EKProperty.Label(font: UIFont(name: FontName, size: 20.0)!, color: UIColor.white, alignment: NSTextAlignment.center)),
                                           description: EKProperty.LabelContent(text: "\n \(highScoreName!) \n \n  \(score)",
                                            style: EKProperty.Label(font: UIFont(name: FontName, size: 15.0)!, color: UIColor.white, alignment: NSTextAlignment.center)))
        }
        
        else{
            let name = UserDefaults.standard.string(forKey: GlobalScoreName)
            scoremessage = EKSimpleMessage(image: EKProperty.ImageContent(imageName: "gravicaineIcon32"),
                                           title: EKProperty.LabelContent(text: "Highest Score:",
                                                                          style: EKProperty.Label(font: UIFont(name: FontName, size: 20.0)!, color: UIColor.white, alignment: NSTextAlignment.center)),
                                           description: EKProperty.LabelContent(text: "\n \(name!) \n \n  999",
                                            style: EKProperty.Label(font: UIFont(name: FontName, size: 15.0)!, color: UIColor.red, alignment: NSTextAlignment.center)))
            
        }
        
        scorenotificationMessage = EKNotificationMessage(simpleMessage: scoremessage)
        scorenotificationView = EKNotificationMessageView(with: scorenotificationMessage)
        
        // credits pop-up
        creditattributes = EKAttributes.centerFloat
        creditattributes.displayDuration = 5.0
        creditattributes.entryInteraction = .dismiss
        creditattributes.entryBackground = .image(image: UIImage(named: "panelBackground")!)
        creditattributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        creditattributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        creditmessage = EKSimpleMessage(image: EKProperty.ImageContent(imageName: "gravicaineIcon32"),
                                       title: EKProperty.LabelContent(text: "Credits:",
                                                                      style: EKProperty.Label(font: UIFont(name: FontName, size: 20.0)!, color: UIColor.white, alignment: NSTextAlignment.center)),
                                       description: EKProperty.LabelContent(text: "Skorpio (sci-fi effects) CC-BY 3.0, Gobusto CC-BY 3.0,\n Telaron CC-BY 3.0",
                                        style: EKProperty.Label(font: UIFont(name: FontName, size: 12.0)!, color: UIColor.white, alignment: NSTextAlignment.center)))
        
        creditnotificationMessage = EKNotificationMessage(simpleMessage: creditmessage)
        creditnotificationView = EKNotificationMessageView(with: creditnotificationMessage)

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

   
        titleImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.90)
        titleImage.zPosition = 10
        titleImage.setScale(CGFloat(titleScaleFactor))
        addChild(titleImage)
        
        let laser = GreenShieldNode(scale: self.scale)
        laser.zPosition = 100
        laser.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.2)
        self.addChild(laser)
        laser.animate()
        
        self.startLabel.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.2)
        self.startLabel.size = CGSize(width: self.startLabel.size.width * self.scale, height: self.startLabel.size.height * self.scale )
        self.addChild(self.startLabel)
        

        self.creditLabel.position = CGPoint(x: self.frame.width * 0.15, y: self.frame.height * 0.20)
        self.creditLabel.size = CGSize(width: self.creditLabel.size.width * self.scale, height: self.creditLabel.size.height * self.scale )
        self.addChild(self.creditLabel)
        
        self.scoresLabel.position = CGPoint(x: self.frame.width * 0.85, y: self.frame.height * 0.20)
        self.scoresLabel.size = CGSize(width: self.scoresLabel.size.width * self.scale, height: self.scoresLabel.size.height * self.scale )
        self.addChild(self.scoresLabel)
        
        musicLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.75)
        self.addChild(musicLabel)
        
        //transLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.6)
        //self.addChild(transLabel)
        
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
        
        musicNode.zPosition = 200
        musicNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.70)
        self.addChild(musicNode)
        
        //transNode.zPosition = 200
        //transNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.55)
        //self.addChild(transNode)
        
        
        self.addChild(menuBackgroundSound)
        menuBackgroundSound.run(SKAction.changeVolume(to: 5, duration: 0.1))
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if startLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                SwiftEntryKit.dismiss()
                let action = SKAction.changeVolume(to: 0, duration: 0.5)
                let removeAction = SKAction.removeFromParent()
                let sequence = SKAction.sequence([action,removeAction])
                menuBackgroundSound.run(sequence) {
                    self.view!.presentScene(sceneToMoveTo, transition:myTransition)
                }
            }
            

            
            if scoresLabel.contains(pointOfTouch){
                
                if score > 0{
                    SwiftEntryKit.dismiss()
                    SwiftEntryKit.display(entry: scorenotificationView, using: scoreattributes)
                }
                
            }
            
            if creditLabel.contains(pointOfTouch){
                
                SwiftEntryKit.dismiss()
                SwiftEntryKit.display(entry: creditnotificationView, using: creditattributes)

            }
            
            if musicNode.contains(pointOfTouch){
                toggleMusic()
            }
            
            if transNode.contains(pointOfTouch){
                toggleTrans()
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
    
    func toggleMusic(){
        
        music = !music
        UserDefaults.standard.set(music, forKey: "music")
        
        if music{
            
            musicNode.removeFromParent()
            musicNode = SKSpriteNode(imageNamed: "on")
            musicNode.zPosition = 200
            musicNode.size = CGSize(width: musicNode.size.width * scale,
                                    height: musicNode.size.height * scale)
            musicNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.70)
            self.addChild(musicNode)
            
        }
        else{
            musicNode.removeFromParent()
            musicNode = SKSpriteNode(imageNamed: "off")
            musicNode.zPosition = 200
            musicNode.size = CGSize(width: musicNode.size.width * scale,
                                    height: musicNode.size.height * scale)
            musicNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.70)
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
            transNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.55)
            self.addChild(transNode)
            
        }
        else{
            transNode.removeFromParent()
            transNode = SKSpriteNode(imageNamed: "off")
            transNode.zPosition = 200
            transNode.size = CGSize(width: transNode.size.width * scale,
                                    height: transNode.size.height * scale)
            transNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.55)
            self.addChild(transNode)
            
        }
        
        
    }
    
    
    
}

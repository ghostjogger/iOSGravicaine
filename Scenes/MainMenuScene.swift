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

    //credit panel setup
    var scoreattributes: EKAttributes
    var scoremessage: EKSimpleMessage
    var scorenotificationMessage: EKNotificationMessage
    var scorenotificationView: EKNotificationMessageView

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

        
        // credits pop-up
        scoreattributes = EKAttributes.centerFloat
        scoreattributes.displayDuration = .infinity
        scoreattributes.entryInteraction = .dismiss
        scoreattributes.entryBackground = .image(image: UIImage(named: "panelBackground")!)
        scoreattributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        scoreattributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        scoremessage = EKSimpleMessage(image: EKProperty.ImageContent(imageName: "gravicaineIcon32"),
                                       title: EKProperty.LabelContent(text: "Credits:",
                                                                      style: EKProperty.Label(font: UIFont(name: FontName, size: 20.0)!, color: UIColor.white, alignment: NSTextAlignment.center)),
                                       description: EKProperty.LabelContent(text: "Stephen \n\n  Ball \n\n Is \n\n The Greatest",
                                        style: EKProperty.Label(font: UIFont(name: FontName, size: 15.0)!, color: UIColor.white, alignment: NSTextAlignment.center)))
        
        scorenotificationMessage = EKNotificationMessage(simpleMessage: scoremessage)
        scorenotificationView = EKNotificationMessageView(with: scorenotificationMessage)

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
        laser.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.2)
        self.addChild(laser)
        laser.animate()
        
        self.startLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.2)
        self.startLabel.size = CGSize(width: self.startLabel.size.width * self.scale, height: self.startLabel.size.height * self.scale )
        self.addChild(self.startLabel)
        
        self.optionLabel.position = CGPoint(x: self.frame.width * 0.15, y: self.frame.height * 0.8)
        self.optionLabel.size = CGSize(width: self.optionLabel.size.width * self.scale, height: self.optionLabel.size.height * self.scale )
        self.addChild(self.optionLabel)
        
        self.creditLabel.position = CGPoint(x: self.frame.width * 0.50, y: self.frame.height * 0.8)
        self.creditLabel.size = CGSize(width: self.creditLabel.size.width * self.scale, height: self.creditLabel.size.height * self.scale )
        self.addChild(self.creditLabel)
        
        self.scoresLabel.position = CGPoint(x: self.frame.width * 0.85, y: self.frame.height * 0.8)
        self.scoresLabel.size = CGSize(width: self.scoresLabel.size.width * self.scale, height: self.scoresLabel.size.height * self.scale )
        self.addChild(self.scoresLabel)
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if startLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                SwiftEntryKit.dismiss()
                self.view!.presentScene(sceneToMoveTo, transition:myTransition)
            }
            
            if optionLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = OptionScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 0.5)
                SwiftEntryKit.dismiss()
                self.view!.presentScene(sceneToMoveTo, transition:myTransition)
  
            }
            
            if scoresLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = ScoreScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.5)
                SwiftEntryKit.dismiss()
                self.view!.presentScene(sceneToMoveTo, transition:myTransition)
                
            }
            
            if creditLabel.contains(pointOfTouch){
                
                SwiftEntryKit.display(entry: scorenotificationView, using: scoreattributes)
                
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

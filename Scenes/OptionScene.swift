//
//  OptionScene.swift
//  Gravicaine
//
//  Created by stephen ball on 20/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//
import SpriteKit
import GameplayKit

class OptionScene: SKScene{
    
    let backgroundImage = SKSpriteNode(imageNamed: "panelBackground")
    let titleImage = SKSpriteNode(imageNamed: "gravicaineTitle")
    
    let backLabel = SKSpriteNode(imageNamed: "back")
    
    var titleScaleFactor = 1.0
    var scale:CGFloat = 1.0
    
    var score:Int
    var highScoreName: String?
    
    var musicLabel = SKLabelNode(text: "Game Music")
    var transLabel = SKLabelNode(text: "Grav Transition Marker")
    var music: Bool
    var trans: Bool
    var musicNode: SKSpriteNode = SKSpriteNode()
    var transNode: SKSpriteNode = SKSpriteNode()
    
    
    override init(size: CGSize) {
        
        score = UserDefaults.standard.integer(forKey: HighScoreKey)
        music = UserDefaults.standard.bool(forKey: "music")
        trans = UserDefaults.standard.bool(forKey: "trans")
        highScoreName = UserDefaults.standard.string(forKey: HighScoreName)
        
        
        musicLabel.fontSize = 30.0 * scale
        musicLabel.fontName = FontName
        
        transLabel.fontSize = 30.0 * scale
        transLabel.fontName = FontName
        
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
        
        musicLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.8)
        self.addChild(musicLabel)
        
        transLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.6)
        self.addChild(transLabel)
        
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
        musicNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.75)
        self.addChild(musicNode)
        
        transNode.zPosition = 200
        transNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.55)
        self.addChild(transNode)
        
        self.addChild(menuBackgroundSound)
        menuBackgroundSound.run(SKAction.changeVolume(to: 5, duration: 0.1))
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if backLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 0.5)
                let action = SKAction.changeVolume(to: 0, duration: 1.0)
                let removeAction = SKAction.removeFromParent()
                let sequence = SKAction.sequence([action,removeAction])
                menuBackgroundSound.run(sequence) {
                    self.view!.presentScene(sceneToMoveTo, transition:myTransition)
                }
                
            }
            
            if musicNode.contains(pointOfTouch){
                toggleMusic()
            }
            
            if transNode.contains(pointOfTouch){
                toggleTrans()
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
                    musicNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.75)
            self.addChild(musicNode)
            
        }
        else{
            musicNode.removeFromParent()
            musicNode = SKSpriteNode(imageNamed: "off")
            musicNode.zPosition = 200
            musicNode.size = CGSize(width: musicNode.size.width * scale,
                                    height: musicNode.size.height * scale)
                    musicNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.75)
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


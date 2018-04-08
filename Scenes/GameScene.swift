//
//  GameScene.swift
//  Gravicaine
//
//  Created by Stephen Ball on 04/04/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameState {
    case none
    case waiting
    case inGame
    case gameOver
}

class GameScene: SKScene {
    

    let startLabel = SKLabelNode(text: "Main Menu")
    let player = SpaceShip()
    let gameArea: CGRect
    
    override init(size:CGSize) {
        
        //setup screen area
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        
        for i in 0...1{
            
            let background = SKSpriteNode(imageNamed: "starBackground")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2,
                                          y: self.size.height * CGFloat(i))
            background.zPosition = 0
            background.name = "background"
            self.addChild(background)
            
        }
        
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.1)
        self.addChild(player)
        
        startLabel.fontName = "Jellee-Roman"
        startLabel.fontColor = UIColor.white
        startLabel.fontSize = 100
        startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.9)
        self.addChild(startLabel)
        
       
    }
    
    var lastUpdateTime:TimeInterval = 0
    var deltaFrameTime:TimeInterval = 0
    var speedToMove:CGFloat = 200.0
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0
        {
            lastUpdateTime = currentTime
        }
        else
        {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = speedToMove * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "background") {
            (node, stop) in
            
            node.position.y -= amountToMoveBackground
            
            if node.position.y < -self.size.height{
                node.position.y += self.size.height * 2
            }
            
           
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{

            let pointOfTouch = touch.location(in: self)

            if startLabel.contains(pointOfTouch){

                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition:myTransition)
            }

        }
        
        player.fireBullet(destinationY: self.size.height)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {


        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let previous = touch.previousLocation(in: self)
            let amountDraggedX = pointOfTouch.x - previous.x
            
            player.position.x += amountDraggedX
            
            if player.position.x > gameArea.maxX - player.size.width/2
            {
                player.position.x = gameArea.maxX - player.size.width/2
            }

            if player.position.x < gameArea.minX + player.size.width/2
            {
                player.position.x = gameArea.minX + player.size.width/2
            }
            

            
        }
        
    }
 
    
}
    
    

    

    
 
    
    



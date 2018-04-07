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
    
    let backgroundImage = SKSpriteNode(imageNamed: "titleBackground")
    let titleImage = SKSpriteNode(imageNamed: "gravicaineTitle")
    let ship = SKSpriteNode(imageNamed: "playerShip")
    let emitter = SKEmitterNode(fileNamed: "ship-fire")
    
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
        
        emitter?.position = CGPoint(x: ship.position.x, y: ship.position.y - 71.0)
        emitter?.targetNode = ship
        self.addChild(emitter!)
    }
    
    
}

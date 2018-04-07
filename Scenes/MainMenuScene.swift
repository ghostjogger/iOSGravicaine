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
    
    let titleImage = SKSpriteNode(imageNamed: "gravicaineTitle")
    
    override func didMove(to view: SKView) {
        print("hello")
        titleImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        titleImage.zPosition = 0
        self.addChild(titleImage)
    }
    
    
}

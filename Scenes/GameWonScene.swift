//
//  GameWonScene.swift
//  Gravicaine
//
//  Created by stephen ball on 25/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit

class GameWonScene: SKScene {
    
    let backgroundImage = SKSpriteNode(imageNamed: "starBackground")
    let titleImage = SKSpriteNode(imageNamed: "gravicaineTitle")
    
    let cNode = SKSpriteNode(imageNamed: "c")
    let oNode = SKSpriteNode(imageNamed: "o")
    let nNode = SKSpriteNode(imageNamed: "n")
    let gNode = SKSpriteNode(imageNamed: "g")
    let rNode = SKSpriteNode(imageNamed: "r")
    let aNode = SKSpriteNode(imageNamed: "a")
    let tNode = SKSpriteNode(imageNamed: "t")
    let uNode = SKSpriteNode(imageNamed: "u")
    let lNode = SKSpriteNode(imageNamed: "l")
    let aNode2 = SKSpriteNode(imageNamed: "a")
    let tNode2 = SKSpriteNode(imageNamed: "t")
    let iNode = SKSpriteNode(imageNamed: "i")
    let oNode2 = SKSpriteNode(imageNamed: "o")
    let nNode2 = SKSpriteNode(imageNamed: "n")
    let sNode = SKSpriteNode(imageNamed: "s")
    let excNode = SKSpriteNode(imageNamed: "!")
    
    var titleScaleFactor = 1.0
    var scale:CGFloat = 1.0
    
    //star animation variables
    
    private var protonStarFrames: [SKTexture] = []
    let protonStarAnimatedAtlas = SKTextureAtlas(named: "star")
    var protonFrames: [SKTexture] = []
    
    override init(size: CGSize) {
        
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
        
        
        titleImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.90)
        titleImage.zPosition = 10
        titleImage.setScale(CGFloat(titleScaleFactor))
        addChild(titleImage)
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

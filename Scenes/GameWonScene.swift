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
        


        cNode.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        cNode.setScale(CGFloat(titleScaleFactor))
        self.addChild(cNode)
        oNode.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        oNode.setScale(CGFloat(titleScaleFactor))
        self.addChild(oNode)
        nNode.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        nNode.setScale(CGFloat(titleScaleFactor))
        self.addChild(nNode)
        gNode.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        gNode.setScale(CGFloat(titleScaleFactor))
        self.addChild(gNode)
        rNode.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        rNode.setScale(CGFloat(titleScaleFactor))
        self.addChild(rNode)
        aNode.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        aNode.setScale(CGFloat(titleScaleFactor))
        self.addChild(aNode)
        tNode.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        tNode.setScale(CGFloat(titleScaleFactor))
        self.addChild(tNode)
        uNode.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        uNode.setScale(CGFloat(titleScaleFactor))
        self.addChild(uNode)
        lNode.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        lNode.setScale(CGFloat(titleScaleFactor))
        self.addChild(lNode)
        aNode2.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        aNode2.setScale(CGFloat(titleScaleFactor))
        self.addChild(aNode2)
        tNode2.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        tNode2.setScale(CGFloat(titleScaleFactor))
        self.addChild(tNode2)
        iNode.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        iNode.setScale(CGFloat(titleScaleFactor))
        self.addChild(iNode)
        oNode2.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        oNode2.setScale(CGFloat(titleScaleFactor))
        self.addChild(oNode2)
        nNode2.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        nNode2.setScale(CGFloat(titleScaleFactor))
        self.addChild(nNode2)
        sNode.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        sNode.setScale(CGFloat(titleScaleFactor))
        self.addChild(sNode)
        excNode.position = CGPoint(x: random(min: self.frame.minX + 20, max: self.frame.maxX - 20), y: self.frame.minY - 100)
        excNode.setScale(CGFloat(titleScaleFactor))
        self.addChild(excNode)
        
        
        let waitAction = SKAction.wait(forDuration: 0.5)
        let thudSound = SKAction.playSoundFileNamed("sound62.wav", waitForCompletion: false)
        let moveSpeed: TimeInterval = 1.4
        let cHeight: CGFloat = 0.75
        
        
        let move1 = SKAction.move(to: CGPoint(x: self.frame.width * 0.1, y: self.frame.height * cHeight), duration: moveSpeed)
        let move2 = SKAction.move(to: CGPoint(x: self.frame.width * 0.153, y: self.frame.height * cHeight), duration: moveSpeed)
        let move3 = SKAction.move(to: CGPoint(x: self.frame.width * 0.206, y: self.frame.height * cHeight), duration: moveSpeed)
        let move4 = SKAction.move(to: CGPoint(x: self.frame.width * 0.259, y: self.frame.height * cHeight), duration: moveSpeed)
        let move5 = SKAction.move(to: CGPoint(x: self.frame.width * 0.312, y: self.frame.height * cHeight), duration: moveSpeed)
        let move6 = SKAction.move(to: CGPoint(x: self.frame.width * 0.365, y: self.frame.height * cHeight), duration: moveSpeed)
        let move7 = SKAction.move(to: CGPoint(x: self.frame.width * 0.418, y: self.frame.height * cHeight), duration: moveSpeed)
        let move8 = SKAction.move(to: CGPoint(x: self.frame.width * 0.471, y: self.frame.height * cHeight), duration: moveSpeed)
        let move9 = SKAction.move(to: CGPoint(x: self.frame.width * 0.524, y: self.frame.height * cHeight), duration: moveSpeed)
        let move10 = SKAction.move(to: CGPoint(x: self.frame.width * 0.577, y: self.frame.height * cHeight), duration: moveSpeed)
        let move11 = SKAction.move(to: CGPoint(x: self.frame.width * 0.63, y: self.frame.height * cHeight), duration: moveSpeed)
        let move12 = SKAction.move(to: CGPoint(x: self.frame.width * 0.683, y: self.frame.height * cHeight), duration: moveSpeed)
        let move13 = SKAction.move(to: CGPoint(x: self.frame.width * 0.736, y: self.frame.height * cHeight), duration: moveSpeed)
        let move14 = SKAction.move(to: CGPoint(x: self.frame.width * 0.789, y: self.frame.height * cHeight), duration: moveSpeed)
        let move15 = SKAction.move(to: CGPoint(x: self.frame.width * 0.842, y: self.frame.height * cHeight), duration: moveSpeed)
        let move16 = SKAction.move(to: CGPoint(x: self.frame.width * 0.9, y: self.frame.height * cHeight), duration: moveSpeed)
        
        cNode.run(SKAction.sequence([waitAction,playerZoomSound,move1,thudSound]))
        oNode.run(SKAction.sequence([waitAction,move2,thudSound]))
        nNode.run(SKAction.sequence([waitAction,move3,thudSound]))
        gNode.run(SKAction.sequence([waitAction,move4,thudSound]))
        rNode.run(SKAction.sequence([waitAction,move5,thudSound]))
        aNode.run(SKAction.sequence([waitAction,move6,thudSound]))
        tNode.run(SKAction.sequence([waitAction,move7,thudSound]))
        uNode.run(SKAction.sequence([waitAction,move8,thudSound]))
        lNode.run(SKAction.sequence([waitAction,move9,thudSound]))
        aNode2.run(SKAction.sequence([waitAction,move10,thudSound]))
        tNode2.run(SKAction.sequence([waitAction,move11,thudSound]))
        iNode.run(SKAction.sequence([waitAction,move12,thudSound]))
        oNode2.run(SKAction.sequence([waitAction,move13,thudSound]))
        nNode2.run(SKAction.sequence([waitAction,move14,thudSound]))
        sNode.run(SKAction.sequence([waitAction,move15,thudSound]))
        excNode.run(SKAction.sequence([waitAction,move16,thudSound]))
        
        
        
        
        
        
        
        
        
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

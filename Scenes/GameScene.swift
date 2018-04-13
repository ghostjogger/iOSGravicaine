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

class GameScene: SKScene, GameLogicDelegate {
    

    let startLabel = SKLabelNode(text: "Main Menu")
    let player = SpaceShip()
    let gameArea: CGRect
    var barrierwidthFraction = 0
    var barrierHeight = 150
    
    // game data
    
    private let gameLogic: GameLogic = GameLogic()
    private var gameState: GameState = .none {
        didSet {
            switch gameState {
            case .waiting:
                self.setWaitingGameState()
                break
            case .inGame:
                self.setInGameState()
                break
            case .gameOver:
                self.setGameOverState()
                break
            default: break
            }
        }
        
    }
    
    //player explosion animation variables
    
    private var playerExplosionFrames: [SKTexture] = []
    let explosionAnimatedAtlas = SKTextureAtlas(named: "playerExplosion")
    var explosionFrames: [SKTexture] = []
    
   
    
    // MARK: - game state
    
    private func setWaitingGameState() {
        

        
    }
    
    private func setInGameState() {
        

        gameLogic.gameDidStart()

        
    }
    
    private func setGameOverState() {

    }
    
    override init(size:CGSize) {
        
        //setup screen area
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        barrierwidthFraction = Int(gameArea.width / 6)
        
        
        super.init(size: size)
        
        
        gameLogic.delegate = self
        
        //setup player explosion animation
        let numImages = explosionAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let explosionTextureName = "explosion\(i)"
            explosionFrames.append(explosionAnimatedAtlas.textureNamed(explosionTextureName))
        }
        playerExplosionFrames = explosionFrames


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func didMove(to view: SKView) {
        

        self.physicsWorld.contactDelegate = gameLogic
        
        //set up 2 star backgrounds to scroll
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
 
        //set up player ship
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.1)
        self.addChild(player)

        
        //set up return to main menu button
        startLabel.fontName = "Jellee-Roman"
        startLabel.fontColor = UIColor.white
        startLabel.fontSize = 100
        startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.9)
        self.addChild(startLabel)
        
        self.gameState = .inGame
        
        
       
    }
    
    var lastUpdateTime:TimeInterval = 0
    var deltaFrameTime:TimeInterval = 0
    var speedToMove:CGFloat = 100.0
    
    
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
    
    func shouldSpawnBarrier(){
        
        DispatchQueue.global().async {
            
            // two actions
            let moveBarrier = SKAction.moveTo(y: -150, duration: 3.0)
            let appearBarrier = SKAction.fadeAlpha(to: 1.0, duration: 0.15)
            let barrierAnimation = SKAction.group([moveBarrier, appearBarrier])
            let deleteBarrier = SKAction.removeFromParent()
            
            // sequence of actions
            let barrierSequence = SKAction.sequence([ barrierAnimation, deleteBarrier])
            
            let i = Int(random(min: 0, max: 4.0))
            
           
            
            var leftBarrier = SKSpriteNode()
            var rightBarrier =  SKSpriteNode()
            
            switch i {
                
            case 0 :
                
                leftBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width:  256, height:self.barrierHeight))
                leftBarrier.anchorPoint = CGPoint(x: 0, y: 0)
                leftBarrier.position = (CGPoint(x: 0, y: self.size.height + 150))
                rightBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: 1024, height:self.barrierHeight))
                rightBarrier.anchorPoint = CGPoint(x: 0, y: 0)
                rightBarrier.position = CGPoint(x: 512, y: self.size.height + 150)
                
            case 1 :
                
                leftBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width:  512, height:self.barrierHeight))
                leftBarrier.anchorPoint = CGPoint(x: 0, y: 0)
                leftBarrier.position = (CGPoint(x: 0, y: self.size.height + 150))
                rightBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: 768, height:self.barrierHeight))
                rightBarrier.anchorPoint = CGPoint(x: 0, y: 0)
                rightBarrier.position = CGPoint(x: 768, y: self.size.height + 150)
            case 2 :
                
                leftBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width:  768, height:self.barrierHeight))
                leftBarrier.anchorPoint = CGPoint(x: 0, y: 0)
                leftBarrier.position = (CGPoint(x: 0, y: self.size.height + 150))
                rightBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: 512, height:self.barrierHeight))
                rightBarrier.anchorPoint = CGPoint(x: 0, y: 0)
                rightBarrier.position = CGPoint(x: 1024, y: self.size.height + 150)
            case 3 :
                
                leftBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width:  1024, height:self.barrierHeight))
                leftBarrier.anchorPoint = CGPoint(x: 0, y: 0)
                leftBarrier.position = (CGPoint(x: 0, y: self.size.height + 150))
                rightBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: 256, height:self.barrierHeight))
                rightBarrier.anchorPoint = CGPoint(x: 0, y: 0)
                rightBarrier.position = CGPoint(x: 1280, y: self.size.height + 150)
                
                
                
            default: break
                
            }
            
            leftBarrier.physicsBody = SKPhysicsBody(rectangleOf: leftBarrier.size)
            leftBarrier.physicsBody!.affectedByGravity = false
            leftBarrier.physicsBody!.categoryBitMask = PhysicsCategories.Barrier
            leftBarrier.physicsBody!.collisionBitMask = PhysicsCategories.None
            leftBarrier.physicsBody!.contactTestBitMask = PhysicsCategories.Player
            
            
            
            rightBarrier.physicsBody = SKPhysicsBody(rectangleOf: rightBarrier.size)
            rightBarrier.physicsBody!.affectedByGravity = false
            rightBarrier.physicsBody!.categoryBitMask = PhysicsCategories.Barrier
            rightBarrier.physicsBody!.collisionBitMask = PhysicsCategories.None
            rightBarrier.physicsBody!.contactTestBitMask = PhysicsCategories.Player
            
            DispatchQueue.main.async(execute: {
                self.addChild(leftBarrier)
                self.addChild(rightBarrier)
                leftBarrier.run(barrierSequence)
                rightBarrier.run(barrierSequence)
            })
        }
        
        
    }
    
    func barrierTouchesPlayer(){
        
   
        player.removeAllChildren()
        player.run(SKAction.repeat(SKAction.animate(with: playerExplosionFrames, timePerFrame: 0.12, resize: false, restore: true), count: 1), withKey: "playerExplosion")
        
    }

    
}
    
    

    

    
 
    
    



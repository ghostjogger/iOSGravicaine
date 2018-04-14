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

extension SKAction {
    
    
    class func hudLabelFadeAction(duration d: TimeInterval = 0.9, fadeDuration fd: TimeInterval = 0.3) -> SKAction {
        let waitDuration = d - 2 * fd;
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: fd)
        let wait = SKAction.wait(forDuration: waitDuration)
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: fd)
        return SKAction.sequence([fadeIn, wait, fadeOut])
    }
    
    class func hudLabelMoveAction(movingLabel: SKLabelNode!, destinationNode: SKNode!, duration: TimeInterval = 0.9) -> SKAction {
        var pos = movingLabel.position
        pos.y = destinationNode.position.y -
            destinationNode.frame.size.height * 0.5 -
            movingLabel.frame.size.height * 0.5
        return SKAction.moveTo(y: pos.y, duration: duration)
    }
    
    class func hudLabelBumpAction(duration: TimeInterval = 0.3) -> SKAction {
        let scale = SKAction.scale(to: 1.4, duration: duration / 2)
        let unscale = SKAction.scale(to: 1.0, duration: duration / 2)
        return SKAction.sequence([scale, unscale])
    }
    
}

class GameScene: SKScene, GameLogicDelegate {
    
    static let backgroundNodeNameObject = "background-node-0"

    
    let startLabel = SKLabelNode(text: "Main Menu")
    let player = SpaceShip()
    let gameArea: CGRect
    var barrierwidthFraction = 0
    var barrierHeight = 300
    
    // planets
    
    private var planetsNodes: [SpaceSpriteNode] = {
        var nodes = [SpaceSpriteNode]()
        for textureIndex in 0...6 {
            let texture = SKTexture(imageNamed: "planet-big-\(textureIndex)")
            let planet = SpaceSpriteNode(texture: texture)
            planet.name = GameScene.backgroundNodeNameObject
            planet.type = SpaceSpriteNodeType.Planet
            nodes.append(planet)
        }
        return nodes
    }()
    
    // ui nodes
    
    private var startPanel: StartPanelNode? = nil
    private let scoreLabel: SKLabelNode?

    
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
        
        // label
        scoreLabel = SKLabelNode()
        scoreLabel?.fontSize = 65.0
        scoreLabel?.fontName = FontName
        scoreLabel?.horizontalAlignmentMode = .left
        scoreLabel?.verticalAlignmentMode = .top
        
        
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
        startLabel.fontName = FontName
        startLabel.fontColor = UIColor.white
        startLabel.fontSize = 100
        startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.9)
        self.addChild(startLabel)
        
        // score label prep work
        
        scoreLabel?.zPosition = 100
        scoreLabel?.position = CGPoint(x: 200, y: self.size.height - 22.0)
        scoreLabel?.text = gameLogic.scoreText()
        self.addChild(scoreLabel!)
        
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
    
    // MARK: - game logic delegate
    
    func scoreDidChange(_ newScore: Int, text: String!) {
        
        if newScore == 0 {
            scoreLabel?.text = text
            return
        }
        
        guard let score: SKLabelNode = scoreLabel else {
            return
        }
        
        score.text = text
        score.run(SKAction.hudLabelBumpAction())
        
        
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
            
           
            //setup left barrier
            let leftBarrier = SKSpriteNode(color: UIColor.white, size: CGSize(width:  256 + (i * 256), height:self.barrierHeight))
            leftBarrier.position = (CGPoint(x: leftBarrier.size.width/2 , y: self.size.height + CGFloat(self.barrierHeight)))
            leftBarrier.physicsBody = SKPhysicsBody(rectangleOf: leftBarrier.size)
            leftBarrier.physicsBody!.affectedByGravity = false
            leftBarrier.physicsBody!.categoryBitMask = PhysicsCategories.Barrier
            leftBarrier.physicsBody!.collisionBitMask = PhysicsCategories.None
            leftBarrier.physicsBody!.contactTestBitMask = PhysicsCategories.Player
            

            
            //setup right barrier
            let rightBarrier =  SKSpriteNode(color: UIColor.white, size: CGSize(width:  1024 - (i * 256), height:self.barrierHeight))
            rightBarrier.position = (CGPoint(x: self.size.width - (rightBarrier.size.width/2) , y: self.size.height + CGFloat(self.barrierHeight)))
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
    

    func shouldSpawnPlanet(){
        
        DispatchQueue.global().async {
            // two actions
            let movePlanet = SKAction.moveTo(y: -150, duration: 2.0)
            let appearPlanet = SKAction.fadeAlpha(to: 1.0, duration: 0.15)
            let planetAnimation = SKAction.group([movePlanet, appearPlanet])
            let deletePlanet = SKAction.removeFromParent()
            
            // sequence of actions
            let planetSequence = SKAction.sequence([ planetAnimation, deletePlanet])
            
            let planetIndex = Int(arc4random()) % self.planetsNodes.count
            let planet = self.planetsNodes[planetIndex]
            planet.setScale(random(min: 0.3, max: 0.5))
            
            let randomY = random(min: 600.0, max: 1000.0)
            planet.position.y = self.size.height + randomY
            planet.position.x = random(min: 10.0, max: self.size.width - 10.0)
            planet.zPosition = 5
            
            DispatchQueue.main.async(execute: {
                self.addChild(planet)
                planet.run(planetSequence)
            })
            
            
            
        }
    }

    
}
    
    

    

    
 
    
    



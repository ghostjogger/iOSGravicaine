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
    //world
    let gravity = 0.2

    
    // player
    
    private var player: SpaceShip
    private let playerBaseY: CGFloat = 0.1


    
    private var gameOverTransitioning = false
    
    
    let gameArea: CGRect
    var barrierwidthFraction = 0
    var barrierHeight = 300

    
    // ui nodes
    
    private var startPanel: StartPanelNode? = nil
    private var gameOverPanel: GameOverPanelNode? = nil
    private let scoreLabel: SKLabelNode?
    
    // control nodes
    private var leftMove: SKLabelNode?
    private var rightMove: SKLabelNode?
    

    
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
    private let playerExplosionSound: SKAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    let explosionAnimatedAtlas = SKTextureAtlas(named: "playerExplosion")
    var explosionFrames: [SKTexture] = []
    
   
    
    // MARK: - game state
    
    private func setWaitingGameState() {
        
        
        player.position = CGPoint(x: self.size.width/2, y:  0 - self.size.height)
        startPanel?.removeFromParent()
        startPanel = StartPanelNode(size: self.size)
        startPanel?.zPosition = 50
        self.addChild(startPanel!)
        startPanel?.fadeIn()

        
    }
    
    private func setInGameState() {
        
        self.enumerateChildNodes(withName: "barrier") {
            (node, stop) in
            
           
            node.removeFromParent()
            
            
        }

        gameLogic.gameDidStart()

        startPanel?.fadeOut() {
            self.startPanel?.removeFromParent()
            self.startPanel = nil
        }
        
        // player appear
        player.position = CGPoint(x: self.size.width/2, y: -player.size.height)
        self.player.isHidden = false
        let playerAppear = SKAction.moveTo(y: self.size.height * self.playerBaseY, duration: 0.3)
        self.player.run(playerAppear)
        
    }
    
    private func setGameOverState() {

        gameLogic.gameDidStop()

        
        gameOverPanel?.removeFromParent()
        gameOverPanel = GameOverPanelNode(size: self.size, score: gameLogic.score )
        gameOverPanel?.zPosition = 50
        self.addChild(gameOverPanel!)
        gameOverPanel?.fadeIn()
        
        gameOverTransitioning = false
        

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
        
        // control nodes
        leftMove = SKLabelNode()
        leftMove?.text = "◀︎"
        leftMove?.fontSize = 120.0
        leftMove?.horizontalAlignmentMode = .left
        leftMove?.verticalAlignmentMode = .bottom
        
        
        
        rightMove = SKLabelNode()
        rightMove?.text = "▶︎"
        rightMove?.fontSize = 120.0
        rightMove?.horizontalAlignmentMode = .right
        rightMove?.verticalAlignmentMode = .bottom
        
        
        
        player = SpaceShip()
        
        
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
        //player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.1)
        self.gameState = .waiting
        self.addChild(player)


        
        // score label prep work
        
        scoreLabel?.zPosition = 100
        scoreLabel?.position = CGPoint(x: 200, y: self.size.height - 22.0)
        scoreLabel?.text = gameLogic.scoreText()
        self.addChild(scoreLabel!)
        
        //move label prep
        leftMove?.zPosition = 150
        leftMove?.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.05)
        rightMove?.zPosition = 150
        rightMove?.position = CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.05)
        
        self.addChild(leftMove!)
        self.addChild(rightMove!)
        
        
        
        if GodMode {
            player.physicsBody?.categoryBitMask = PhysicsCategories.None
        }
        
       
    }
    
    var lastUpdateTime:TimeInterval = 0
    var deltaFrameTime:TimeInterval = 0
    var speedToMove:CGFloat = 100.0
    
    
    override func update(_ currentTime: TimeInterval) {
        

        

        
        if self.gameState == .inGame && !gameOverTransitioning{
        if lastUpdateTime == 0
        {
            lastUpdateTime = currentTime
        }
        else
        {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
    
            if player.position.x > gameArea.maxX - player.size.width/2
            {
                player.position.x = gameArea.maxX - player.size.width/2
                //player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            }
            
            if player.position.x < gameArea.minX + player.size.width/2
            {
                player.position.x = gameArea.minX + player.size.width/2
               // player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
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
    }
    
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{

            let pointOfTouch = touch.location(in: self)
            
            print("\(pointOfTouch.x)")
            print("\(pointOfTouch.y)")

            if pointOfTouch.x < self.size.width / 2{
                player.physicsBody?.applyImpulse(CGVector(dx: -100, dy: 0))
            }
            else if pointOfTouch.x >= self.size.width / 2{
                player.physicsBody?.applyImpulse(CGVector(dx: 100, dy: 0))
            }


        }
        if gameOverTransitioning {
            return
        }
        
        if gameState == .waiting  {
            self.gameState = .inGame
            return
        }
        
        if gameState == .gameOver {
            
            let sceneToMoveTo = GameScene(size: self.size)
            sceneToMoveTo.scaleMode = self.scaleMode
            let myTransition = SKTransition.fade(withDuration: 1.0)
            self.view!.presentScene(sceneToMoveTo, transition:myTransition)
        }
//
//        if self.gameState == .inGame{
//        player.fireBullet(destinationY: self.size.height)
//        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if gameOverTransitioning {
            return
        }
        
        if gameState == .waiting || gameState == .gameOver {
            return
        }

        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let previous = touch.previousLocation(in: self)
            let amountDraggedX = pointOfTouch.x - previous.x
            
            player.position.x += amountDraggedX



            
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
        
        if !gameOverTransitioning {
            
          
        DispatchQueue.global().async {
            
            // two actions
            let moveBarrier = SKAction.moveTo(y: CGFloat(-self.barrierHeight), duration: 3.0)
            let appearBarrier = SKAction.fadeAlpha(to: 1.0, duration: 0.15)
            let barrierAnimation = SKAction.group([moveBarrier, appearBarrier])
            let deleteBarrier = SKAction.removeFromParent()
            
            // sequence of actions
            let barrierSequence = SKAction.sequence([ barrierAnimation, deleteBarrier])
            
            let i = Int(random(min: 0, max: 7.0))
            
           
            //setup left barrier
            let leftBarrier = SKSpriteNode(color: UIColor.lightGray, size: CGSize(width:  256 + (i * 128), height:self.barrierHeight))
            leftBarrier.position = (CGPoint(x: leftBarrier.size.width/2 , y: self.size.height + CGFloat(self.barrierHeight)))
            leftBarrier.physicsBody = SKPhysicsBody(rectangleOf: leftBarrier.size)
            leftBarrier.physicsBody!.affectedByGravity = false
            leftBarrier.physicsBody!.categoryBitMask = PhysicsCategories.Barrier
            leftBarrier.physicsBody!.collisionBitMask = PhysicsCategories.None
            leftBarrier.physicsBody!.contactTestBitMask = PhysicsCategories.Player
            leftBarrier.name = "barrier"
            

            
            //setup right barrier
            let rightBarrier =  SKSpriteNode(color: UIColor.yellow, size: CGSize(width:  1024 - (i * 128), height:self.barrierHeight))
            rightBarrier.position = (CGPoint(x: self.size.width - (rightBarrier.size.width/2) , y: self.size.height + CGFloat(self.barrierHeight)))
            rightBarrier.physicsBody = SKPhysicsBody(rectangleOf: rightBarrier.size)
            rightBarrier.physicsBody!.affectedByGravity = false
            rightBarrier.physicsBody!.categoryBitMask = PhysicsCategories.Barrier
            rightBarrier.physicsBody!.collisionBitMask = PhysicsCategories.None
            rightBarrier.physicsBody!.contactTestBitMask = PhysicsCategories.Player
            rightBarrier.name = "barrier"
            
            
            
            DispatchQueue.main.async(execute: {
                self.addChild(leftBarrier)
                self.addChild(rightBarrier)
                leftBarrier.run(barrierSequence, completion: {
                    self.gameLogic.passBarrier()
                    })
                rightBarrier.run(barrierSequence, completion: {
                    self.gameLogic.passBarrier()
                })
            })
        }
        
        }
    }
    
    func barrierTouchesPlayer(){
 
        gameOverTransitioning = true
        
        self.enumerateChildNodes(withName: "barrier") {
            (node, stop) in
            
            node.removeAllActions()
            
            
            
        }
        player.removeAllChildren()
        let hideAction = SKAction.hide()
        let waitAction = SKAction.wait(forDuration: 1.0)
        let animateExplosionAction = SKAction.animate(with: playerExplosionFrames, timePerFrame: 0.1, resize: false, restore: false)
        let playerExplosionSequence = SKAction.sequence([playerExplosionSound, animateExplosionAction,hideAction,waitAction])
        player.run(playerExplosionSequence, completion: {
             self.gameState = .gameOver
})
        
       
       
    }
    


    
}
    
    

    

    
 
    
    



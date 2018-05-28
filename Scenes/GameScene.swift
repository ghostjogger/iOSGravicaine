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
        let scale = SKAction.scale(to: 2.0, duration: duration / 2)
        let unscale = SKAction.scale(to: 1.0, duration: duration / 2)
        return SKAction.sequence([scale, unscale])
    }
    
}

class GameScene: SKScene, GameLogicDelegate, UITextFieldDelegate {
   
    static let backgroundNodeNameObject = "background-node-0"

 
    // player
    
    private var player: SpaceShip
    private let playerBaseY: CGFloat = 0.25
    private let impulse = 220
    private let shieldNode: ShieldNode
    private var shieldActive: Bool = false
    private let shieldActivationTime = 10.0
    private var shieldTimer = Timer()

    //fuel
    private var isFuelEmpty = false
    private let fuelTopUp = 10
    private let startFuel = 100
    private var fuelNode: SKSpriteNode = SKSpriteNode()
    private var fuelBackgroundNode: SKSpriteNode = SKSpriteNode()
    private var fuelLabel = SKLabelNode(text: "Fuel")
    
    //gravity
    private let gravity = 1.5
    private var gravityNode: SKSpriteNode = SKSpriteNode()
    private var gravityNodeLabel: SKLabelNode = SKLabelNode(text: "G")
    

    private var gameOverTransitioning = false
    private var wasHighScore = false
    private var highScoreValue = 0
    private var highScoreNameText = ""
    private var highScoreText: UITextField? = nil
    
    let gameArea: CGRect
    
    //barriers
    var barrierwidthFraction = 0
    var barrierHeight = 300
    var leftBarrierNode: SKSpriteNode = SKSpriteNode(imageNamed: "BarrierLBig")
    var rightBarrierNode: SKSpriteNode = SKSpriteNode(imageNamed: "BarrierRBig")
    let barrierColours = [UIColor.blue,UIColor.green,UIColor.cyan,UIColor.yellow, UIColor.red, UIColor.purple,UIColor.lightGray, UIColor.orange]

    
    // ui nodes
    private let exitLabel = SKLabelNode(text: "Quit")
    private var startPanel: StartPanelNode? = nil
    private var gameOverPanel: GameOverPanelNode? = nil
    private var highScorePanel: HighScorePanelNode? = nil
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
    private let playerExplosionSound: SKAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    let explosionAnimatedAtlas = SKTextureAtlas(named: "playerExplosion")
    var explosionFrames: [SKTexture] = []
    
    //powerup sound action
    private var powerUpSound: SKAction = SKAction.playSoundFileNamed("Powerup.wav", waitForCompletion: false)
   
    
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
        
        isFuelEmpty = false
        shieldActive = false
        
        //self.physicsWorld.gravity = CGVector(dx: -gravity, dy: 0)

        startPanel?.fadeOut() {
            self.startPanel?.removeFromParent()
            self.startPanel = nil
        }
        
        // player appear
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        player.position = CGPoint(x: self.size.width/2, y: -player.size.height)
        self.player.isHidden = false
        let playerAppear = SKAction.moveTo(y: self.size.height * self.playerBaseY, duration: 0.3)
        self.player.run(playerAppear)        
    }
    
    private func setGameOverState() {

        gameLogic.gameDidStop()

        if !wasHighScore{
            gameOverPanel?.removeFromParent()
            gameOverPanel = GameOverPanelNode(size: self.size, score: gameLogic.score )
            gameOverPanel?.zPosition = 50
            self.addChild(gameOverPanel!)
            gameOverPanel?.fadeIn()
            gameOverTransitioning = false
        }
        else{
            highScorePanel?.removeFromParent()
            highScorePanel = HighScorePanelNode(size: self.size)
            highScorePanel?.zPosition = 50
            self.addChild(highScorePanel!)
            //fadein
            highScorePanel?.fadeIn()
            highScoreText = UITextField(frame: CGRect(
                x: ((view?.bounds.width)! / 2) - 160,
                y: ((view?.bounds.height)! / 2) - 20,
                width: 320,
                height: 40))
            
            highScoreText?.borderStyle = UITextBorderStyle.roundedRect
            highScoreText?.textColor = SKColor.black
            highScoreText?.placeholder = "Enter your name (max 12 chars)"
            highScoreText?.backgroundColor = SKColor.white

            
            // add the UITextField to the GameScene's view
            view?.addSubview(highScoreText!)
            
            // add the gamescene as the UITextField delegate.
            // delegate funtion called is textFieldShouldReturn:
            highScoreText?.delegate = self
   
        }
        
        
        

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
        scoreLabel?.fontSize = 90.0
        scoreLabel?.fontName = FontName
        scoreLabel?.horizontalAlignmentMode = .center
        scoreLabel?.verticalAlignmentMode = .top
        
        // fuel node
        fuelNode = SKSpriteNode(texture: nil, color: UIColor.green, size: CGSize(width: 500, height: 100))
        fuelBackgroundNode = SKSpriteNode(texture: nil, color: UIColor.red.withAlphaComponent(0.30), size: CGSize(width: 500, height: 100))
        
        //gravity indicators
        gravityNode = SKSpriteNode(texture: nil, color: UIColor.green.withAlphaComponent(0.40), size: CGSize(width: 100, height: 200))
        gravityNodeLabel.fontName = FontName
        gravityNodeLabel.fontSize = 50.0
        gravityNodeLabel.fontColor = UIColor.green
        
        //player init
        player = SpaceShip()
        shieldNode = ShieldNode()
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
    
    // Called by tapping return on the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text! == "" || (textField.text?.count)! > 12{
            return false
        }
        
        highScoreNameText = textField.text!
        
        // Hides the keyboard
        
        textField.resignFirstResponder()
        gameLogic.updateHighScore(name: highScoreNameText, score: highScoreValue)
        highScoreText?.removeFromSuperview()
        highScorePanel?.removeFromParent()
        highScorePanel?.fadeOut()
        gameOverPanel?.removeFromParent()
        gameOverPanel = GameOverPanelNode(size: self.size, score: gameLogic.score )
        gameOverPanel?.zPosition = 50
        self.addChild(gameOverPanel!)
        gameOverPanel?.fadeIn()
        gameOverTransitioning = false
        return true
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
        
        self.gameState = .waiting
        self.addChild(player)
    
        // score label prep work
        
        scoreLabel?.zPosition = 100
        scoreLabel?.position = CGPoint(x: self.size.width/2, y: self.size.height - 22.0)
        scoreLabel?.text = gameLogic.scoreText()
        self.addChild(scoreLabel!)
        

        //fuel label prep
        fuelNode.position = CGPoint(x: self.size.width/2 - fuelNode.size.width/2, y: 100)
        fuelNode.zPosition = 100
        fuelNode.anchorPoint = CGPoint.zero
        self.addChild(fuelNode)
        
        fuelBackgroundNode.position = CGPoint(x: self.size.width/2 - fuelBackgroundNode.size.width/2, y: 100)
        fuelBackgroundNode.zPosition = 50
        fuelBackgroundNode.anchorPoint = CGPoint.zero
        self.addChild(fuelBackgroundNode)

        fuelLabel.fontSize = 42.0
        fuelLabel.fontName = FontName
        fuelLabel.horizontalAlignmentMode = .center
        fuelLabel.verticalAlignmentMode = .center
        fuelLabel.zPosition = 100
        fuelLabel.position = CGPoint(x: self.size.width/2, y: 60)
        self.addChild(fuelLabel)
        
        //gravity nodes
        gravityNode.position.x = -1000
        gravityNode.addChild(gravityNodeLabel)
        self.addChild(gravityNode)
        
        //exit label
        exitLabel.fontSize = 80.0
        exitLabel.fontName = FontName
        exitLabel.horizontalAlignmentMode = .left
        exitLabel.verticalAlignmentMode = .center
        exitLabel.zPosition = 50
        exitLabel.position = CGPoint(x: 200, y: self.size.height - 50.0)
        self.addChild(exitLabel)
        
//        shieldNode.position.x = player.position.y
//        shieldNode.position.y = player.position.y
//        shieldNode.zPosition = 100
//        self.addChild(shieldNode)
//        shieldNode.animate()
        
        
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
            
            if !shieldNode.isHidden{
                shieldNode.position.x = player.position.x
                shieldNode.position.y = player.position.y - 70
            }

            
            if player.position.x < self.size.width/2{
                self.physicsWorld.gravity = CGVector(dx: -gravity, dy: 0)
                gravityNode.position = CGPoint(x: self.size.width/2 - 500, y: 150)
                gravityNode.zPosition = 100
            }
            else{
                self.physicsWorld.gravity = CGVector(dx: gravity, dy: 0)
                gravityNode.position = CGPoint(x: self.size.width/2 + 500, y: 150)
                gravityNode.zPosition = 100
            }

            if player.position.x > gameArea.maxX - player.size.width/2
            {
                player.position.x = gameArea.maxX - player.size.width/2
              
            }
            
            if player.position.x < gameArea.minX + player.size.width/2
            {
                player.position.x = gameArea.minX + player.size.width/2
         
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
            
            if exitLabel.contains(pointOfTouch){
                
                gameLogic.gameDidStop()
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition:myTransition)
            }


            if pointOfTouch.x < self.size.width / 2{
                if self.gameState == .inGame && !isFuelEmpty && !gameOverTransitioning{
                player.physicsBody?.applyImpulse(CGVector(dx: -impulse, dy: 0))
                player.thrustLeft()
                }
            }
            else if pointOfTouch.x >= self.size.width / 2{
                if self.gameState == .inGame && !isFuelEmpty && !gameOverTransitioning{
                player.physicsBody?.applyImpulse(CGVector(dx: impulse, dy: 0))
                player.thrustRight()
                }
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
            
        //say   
        DispatchQueue.global().async {
            
            // two actions
            let moveBarrier = SKAction.moveTo(y: CGFloat(-self.barrierHeight), duration: 3.5)
            let appearBarrier = SKAction.fadeAlpha(to: 1.0, duration: 0.15)
            let barrierAnimation = SKAction.group([moveBarrier, appearBarrier])
            let deleteBarrier = SKAction.removeFromParent()
            
            // sequence of actions
            let barrierSequence = SKAction.sequence([ barrierAnimation, deleteBarrier])

            
           
            //setup left barrier

            let leftBarrier = SKSpriteNode(imageNamed: "BarrierLBig")
            leftBarrier.position = CGPoint(x: random(min: -400, max: 300), y: self.size.height + CGFloat(self.barrierHeight))
            leftBarrier.physicsBody = SKPhysicsBody(rectangleOf: leftBarrier.size)
            leftBarrier.physicsBody!.affectedByGravity = false
            leftBarrier.physicsBody!.categoryBitMask = PhysicsCategories.Barrier
            leftBarrier.physicsBody!.collisionBitMask = PhysicsCategories.None
            leftBarrier.physicsBody!.contactTestBitMask = PhysicsCategories.Player
            leftBarrier.name = "barrier"
            

            
            //setup right barrier

            let rightBarrier = SKSpriteNode(imageNamed: "BarrierRBig")
            rightBarrier.position = (CGPoint(x: leftBarrier.position.x + 608 + 1050, y: self.size.height + CGFloat(self.barrierHeight)))
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
                })
            })
        }
        
        }
    }
    
    func barrierTouchesPlayer(isHighScore: Bool, highScore: Int){
 
        if !shieldActive{
        gameOverTransitioning = true
        wasHighScore = isHighScore
        highScoreValue = highScore
        
        self.enumerateChildNodes(withName: "barrier") {
            (node, stop) in
            
            node.removeAllActions()
  
        }
        self.enumerateChildNodes(withName: "power") {
            (node, stop) in
            
            node.removeAllActions()
            
        }
        self.enumerateChildNodes(withName: "asteroid") {
            (node, stop) in
            
            node.removeAllActions()
            
        }
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
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
    
    func powerUpTouchesPlayer(){
        self.enumerateChildNodes(withName: "power") {
            (node, stop) in
            
            node.removeFromParent()
            
        }

        let powerUpSequence = SKAction.sequence([powerUpSound])
        player.run(powerUpSequence)
        //fuelNode.run(SKAction.hudLabelBumpAction())
        
        if !shieldActive{
            shieldNode.position.x = player.position.x
            shieldNode.position.y = player.position.y - 70
            shieldNode.zPosition = 100
            self.addChild(shieldNode)
            shieldNode.animate()
            shieldActive = true
            shieldTimer = Timer.scheduledTimer(withTimeInterval: shieldActivationTime, repeats: false) { (time) in
                self.shieldNode.stopAnimating()
                self.shieldNode.removeFromParent()
                self.shieldActive = false
            }
        }
        else{
            if shieldTimer.isValid
            {
            shieldTimer.invalidate()
            }
            shieldTimer = Timer.scheduledTimer(withTimeInterval: shieldActivationTime, repeats: false) { (time) in
                self.shieldNode.stopAnimating()
                self.shieldNode.removeFromParent()
                self.shieldActive = false
            }
            
        }
        
        
    }
    
    func fuelEmpty(){
        
        isFuelEmpty = true
    }
    
    func fuelDidChange(fuel:Int){

        if fuel <= 0{
            isFuelEmpty = true
            fuelNode.size.width = 0
        }

        if !gameOverTransitioning && !isFuelEmpty{
            fuelNode.size.width = CGFloat(fuel * 5)
        }
        

    }
    func shouldSpawnPowerUp() {
        if !gameOverTransitioning {
        
        DispatchQueue.global().async {
            
            let power = PowerUpNode()
            power.name = "power"
            var moveType = PowerUpMove.Straight
            moveType = (arc4random() % 2 == 0 ? .Straight : .Curvy)
            
            power.move = moveType
            power.zPosition = 5
            
            let randomXStart = random(min: 10.0, max: self.size.width - 10.0)
            let yStart = self.size.height + 200.0
            
            let randomXEnd = random(min: 10.0, max: self.size.width - 10.0)
            let yEnd: CGFloat = -power.size.height
            
            DispatchQueue.main.async(execute: {
                self.addChild(power)
                power.move(from: CGPoint(x: randomXStart, y: yStart), to: CGPoint(x: randomXEnd, y: yEnd)) {
                    //
                }
            })
            
            }
        }
    }
    
    func shouldSpawnAsteroid() {
        
        if !gameOverTransitioning {
            
            DispatchQueue.global().async {
                
                let asteroid = AsteroidNode()
                asteroid.name = "asteroid"
                var moveType = AsteroidMove.Straight
                moveType = (arc4random() % 2 == 0 ? .Straight : .Curvy)
                
                asteroid.move = moveType
                asteroid.zPosition = 5
                
                let randomXStart = random(min: 10.0, max: self.size.width - 10.0)
                let yStart = self.size.height + 200.0
                
                let randomXEnd = random(min: 10.0, max: self.size.width - 10.0)
                let yEnd: CGFloat = -asteroid.size.height
                
                DispatchQueue.main.async(execute: {
                    self.addChild(asteroid)
                    asteroid.move(from: CGPoint(x: randomXStart, y: yStart), to: CGPoint(x: randomXEnd, y: yEnd)) {
                        //
                    }
                })
                
            }
        }
    }

    


    
}
    
    

    

    
 
    
    



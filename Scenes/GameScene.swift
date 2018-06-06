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
    private var shieldActive: Bool = false
    private var shieldTimer = Timer()
    private var shieldTransitionTimer = Timer()

    //fuel
//    private var isFuelEmpty = false
//    private var fuelNode: SKSpriteNode = SKSpriteNode()
//    private var fuelBackgroundNode: SKSpriteNode = SKSpriteNode()
//    private var fuelLabel = SKLabelNode(text: "Fuel")
    
    //gravity
    private var gravityNode: SKSpriteNode = SKSpriteNode()
    private var gravityNodeLabel: SKLabelNode = SKLabelNode(text: "G")
    

    private var gameOverTransitioning = false
    private var wasHighScore = false
    private var highScoreValue = 0
    private var highScoreNameText = ""
    private var highScoreText: UITextField? = nil
    
    let gameArea: CGRect
    var scaleFactor:CGFloat = 0
    
    //barriers
    var leftBarrierNode: SKSpriteNode = SKSpriteNode(imageNamed: "BarrierLBig")
    var rightBarrierNode: SKSpriteNode = SKSpriteNode(imageNamed: "BarrierRBig")
    var barriers = [Int]()
    var barrierCount = 0
   
    // ui nodes
    private let exitLabel = SKSpriteNode(imageNamed: "exit")
    private let pauseLabel = SKSpriteNode(imageNamed: "pause")
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
        
        //isFuelEmpty = false
        shieldActive = false

        startPanel?.fadeOut() {
            self.startPanel?.removeFromParent()
            self.startPanel = nil
            
        }
        
        // player appear
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.mass = CGFloat(playerMass)
        player.position = CGPoint(x: self.size.width/2, y: -player.size.height)
        self.player.isHidden = false
        let playerAppear = SKAction.moveTo(y: self.size.height * CGFloat(playerBaseY), duration: 0.3)
        self.player.run(playerAppear){
            self.addChild(backgroundSound)
        }

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
            
            //name entry textfield
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

        scaleFactor = size.width / CGFloat(maxDeviceScreenWidth)
        
        // label
        scoreLabel = SKLabelNode()
        scoreLabel?.fontSize = 100.0 * scaleFactor
        scoreLabel?.fontName = FontName
        scoreLabel?.horizontalAlignmentMode = .center
        scoreLabel?.verticalAlignmentMode = .top
        
        // fuel node
//        fuelNode = SKSpriteNode(texture: nil, color: UIColor.green, size: CGSize(width: 500, height: 80))
//        fuelBackgroundNode = SKSpriteNode(texture: nil, color: UIColor.red.withAlphaComponent(0.30), size: CGSize(width: 500, height: 80))
        
        //gravity indicators
        gravityNode = SKSpriteNode(texture: nil, color: UIColor.green.withAlphaComponent(0.40), size: CGSize(width: 75 * scaleFactor, height: 150 * scaleFactor))
        gravityNodeLabel.fontName = FontName
        gravityNodeLabel.fontSize = 50.0 * scaleFactor
        gravityNodeLabel.fontColor = UIColor.green
        
        //player init
        player = SpaceShip(scale: scaleFactor)
        super.init(size: size)
        


        gameLogic.delegate = self
        
        if playerExplosionFrames.count == 0 {
        
            //setup player explosion animation
            var numImages = playerExplosionAnimatedAtlas.textureNames.count
            for i in 1...numImages {
                let explosionTextureName = "explosion\(i)"
                playerExplosionFrames.append(playerExplosionAnimatedAtlas.textureNamed(explosionTextureName))
            }
            
            //setup entity explosion animation
            numImages = entityExplosionAnimatedAtlas.textureNames.count
            for i in 1...numImages {
                let explosionTextureName = "entity\(i)"
                entityExplosionFrames.append(entityExplosionAnimatedAtlas.textureNamed(explosionTextureName))
            }
            
            //setup red explosion animation
            numImages = redExplosionAnimatedAtlas.textureNames.count
            for i in 1...numImages {
                let explosionTextureName = "redExplosion\(i)"
                redExplosionFrames.append(redExplosionAnimatedAtlas.textureNamed(explosionTextureName))
            }
            
            //setup asteroid explosion animation
            numImages = asteroidExplosionAnimatedAtlas.textureNames.count
            for i in 1...numImages {
                let explosionTextureName = "newexplosion\(i)"
                asteroidExplosionFrames.append(asteroidExplosionAnimatedAtlas.textureNamed(explosionTextureName))
            }
        }

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
        
        barrierCount = 0
        barriers = seedRandom(seed: 10, count: 500, low:0, high:9)
        
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
        scoreLabel?.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.95)
        scoreLabel?.text = gameLogic.scoreText()
        self.addChild(scoreLabel!)
        

        //fuel label prep
//        fuelNode.position = CGPoint(x: self.frame.midX - fuelNode.size.width/2, y: self.size.height * 0.05)
//        fuelNode.zPosition = 100
//        fuelNode.anchorPoint = CGPoint.zero
//        self.addChild(fuelNode)
//
//        fuelBackgroundNode.position = CGPoint(x: self.frame.midX - fuelBackgroundNode.size.width/2, y: self.size.height * 0.05)
//        fuelBackgroundNode.zPosition = 50
//        fuelBackgroundNode.anchorPoint = CGPoint.zero
//        self.addChild(fuelBackgroundNode)
//
//        fuelLabel.fontSize = 42.0 * scaleFactor
//        fuelLabel.fontName = FontName
//        fuelLabel.horizontalAlignmentMode = .center
//        fuelLabel.verticalAlignmentMode = .center
//        fuelLabel.zPosition = 100
//        fuelLabel.position = CGPoint(x: self.frame.midX, y: self.size.height * 0.03)
//        self.addChild(fuelLabel)
        
        //gravity nodes
        gravityNode.position.x = -1000
        gravityNode.addChild(gravityNodeLabel)
        self.addChild(gravityNode)
        
        //exit label
        exitLabel.zPosition = 50
        exitLabel.size = CGSize(width: exitLabel.size.width * scaleFactor, height: exitLabel.size.height * scaleFactor)
        exitLabel.position = CGPoint(x: self.frame.width * 0.1, y: self.frame.height * 0.95)
        self.addChild(exitLabel)
        
        //pause label
        pauseLabel.zPosition = 50
        pauseLabel.size = CGSize(width: pauseLabel.size.width * scaleFactor, height: pauseLabel.size.height * scaleFactor)
        pauseLabel.position = CGPoint(x: self.frame.width * 0.9, y: self.frame.height * 0.95)
        self.addChild(pauseLabel)

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
            

            
            if player.position.x < self.size.width/2{
                self.physicsWorld.gravity = CGVector(dx: -gravity, dy: 0)
                gravityNode.position = CGPoint(x: self.frame.width * 0.05, y: self.frame.height * 0.04)
                gravityNode.zPosition = 100
            }
            else{
                self.physicsWorld.gravity = CGVector(dx: gravity, dy: 0)
                gravityNode.position = CGPoint(x: self.frame.width * 0.95, y: self.frame.height * 0.04)
                gravityNode.zPosition = 100
            }

            if player.position.x > self.frame.maxX - player.size.width/2
            {
                player.position.x = self.frame.maxX - player.size.width/2
                player.physicsBody?.velocity = CGVector(dx: -10, dy: 0)
              
            }
            
            if player.position.x < self.frame.minX + player.size.width/2
            {
                player.position.x = self.frame.minX + player.size.width/2
                player.physicsBody?.velocity = CGVector(dx: 10, dy: 0)
         
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
                highScoreText?.removeFromSuperview()
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition:myTransition)
            }


            if pointOfTouch.x < self.size.width / 2{
                if self.gameState == .inGame && !gameOverTransitioning{
                player.physicsBody?.applyImpulse(CGVector(dx: -impulse, dy: 0))
                player.thrustLeft()
                }
            }
            else if pointOfTouch.x >= self.size.width / 2{
                if self.gameState == .inGame && !gameOverTransitioning{
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
            
            var nextBarrier = barriers[barrierCount]
  
        DispatchQueue.global().async {
            
            // two actions
            let moveBarrier = SKAction.moveTo(y: CGFloat(-barrierHeight), duration: barrierSpeed)
            let appearBarrier = SKAction.fadeAlpha(to: 1.0, duration: 0.15)
            let barrierAnimation = SKAction.group([moveBarrier, appearBarrier])
            let deleteBarrier = SKAction.removeFromParent()
            
            // sequence of actions
            let barrierSequence = SKAction.sequence([ barrierAnimation, deleteBarrier])

            
           
            //setup left barrier

            let leftBarrier = SKSpriteNode(imageNamed: "BarrierLBig")
            var scaledX = leftBarrier.size.width * self.scaleFactor
            var scaledY = leftBarrier.size.height * self.scaleFactor
            leftBarrier.size = CGSize(width: scaledX, height: scaledY)
            
            var leftOffset = ((leftBarrier.size.width/10) * CGFloat(nextBarrier))
            leftBarrier.position = CGPoint(
                x: (self.frame.minX - leftBarrier.size.width/2) + leftOffset,
                y: self.size.height + CGFloat(barrierHeight))
            
//            leftBarrier.position = CGPoint(
//                x: random(min: self.frame.minX - leftBarrier.size.width/2,
//                            max: self.frame.maxX - (CGFloat(barrierGap) * self.scaleFactor) - leftBarrier.size.width/2) ,
//                y: self.size.height + CGFloat(barrierHeight))
            leftBarrier.physicsBody = SKPhysicsBody(rectangleOf: leftBarrier.size)
            leftBarrier.physicsBody!.affectedByGravity = false
            leftBarrier.physicsBody!.categoryBitMask = PhysicsCategories.Barrier
            leftBarrier.physicsBody!.collisionBitMask = PhysicsCategories.None
            leftBarrier.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Asteroid
            leftBarrier.name = "barrier"
            

            
            //setup right barrier

            let rightBarrier = SKSpriteNode(imageNamed: "BarrierRBig")
            scaledX = rightBarrier.size.width * self.scaleFactor
            scaledY = rightBarrier.size.height * self.scaleFactor
            rightBarrier.size = CGSize(width: scaledX, height: scaledY)
            
            rightBarrier.position = (CGPoint(x: leftBarrier.position.x
                + leftBarrier.size.width + (CGFloat(barrierGap) * self.scaleFactor),
                                             y: self.size.height + CGFloat(barrierHeight)))
            rightBarrier.physicsBody = SKPhysicsBody(rectangleOf: rightBarrier.size)
            rightBarrier.physicsBody!.affectedByGravity = false
            rightBarrier.physicsBody!.categoryBitMask = PhysicsCategories.Barrier
            rightBarrier.physicsBody!.collisionBitMask = PhysicsCategories.None
            rightBarrier.physicsBody!.contactTestBitMask = PhysicsCategories.Asteroid | PhysicsCategories.Player
            rightBarrier.name = "barrier"
            
            //setup gap
            let size = CGSize(width: (CGFloat(barrierGap) * self.scaleFactor), height: leftBarrier.size.height)
            let barrierSpaceNode = SKSpriteNode(texture: nil, color: UIColor.clear, size: size)
            barrierSpaceNode.position = CGPoint(x: leftBarrier.position.x + leftBarrier.size.width/2, y: self.size.height + CGFloat(barrierHeight) + 10.0)
            barrierSpaceNode.physicsBody = SKPhysicsBody(rectangleOf: barrierSpaceNode.size)
            barrierSpaceNode.physicsBody?.affectedByGravity = false
            barrierSpaceNode.physicsBody!.categoryBitMask = PhysicsCategories.BarrierGap
            barrierSpaceNode.physicsBody!.collisionBitMask = PhysicsCategories.None
            barrierSpaceNode.physicsBody!.contactTestBitMask = PhysicsCategories.Player
            barrierSpaceNode.name = "barrierGap"
            
            
            
            DispatchQueue.main.async(execute: {
                self.addChild(leftBarrier)
                self.addChild(rightBarrier)
                self.addChild(barrierSpaceNode)
                self.barrierCount += 1
                leftBarrier.run(barrierSequence, completion: {
                    })
                rightBarrier.run(barrierSequence, completion: {
                })
                barrierSpaceNode.run(barrierSequence, completion: {
                })
            })
        }
        
        }
    }
    
    func barrierTouchesPlayer(isHighScore: Bool, highScore: Int){
 
        if !shieldActive {
            
        
        gameOverTransitioning = true
        wasHighScore = isHighScore
        highScoreValue = highScore
            
        
        self.enumerateChildNodes(withName: "barrier") {
            (node, stop) in
            
            node.removeAllActions()
  
        }
        self.enumerateChildNodes(withName: "barrierGap") {
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
        self.enumerateChildNodes(withName: "shieldPower") {
                (node, stop) in
                
                node.removeAllActions()
                
        }
        
        backgroundSound.removeFromParent()
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        player.removeAllChildren()
        let hideAction = SKAction.hide()
        let waitAction = SKAction.wait(forDuration: 0.5)
        let animateExplosionAction = SKAction.animate(with: playerExplosionFrames, timePerFrame: 0.1, resize: false, restore: false)
        let playerExplosionSequence = SKAction.sequence([playerExplosionSound, animateExplosionAction,hideAction,waitAction])
        player.run(playerExplosionSequence, completion: {
             self.gameState = .gameOver
})
        
    }
       
}
    
    func powerUpTouchesPlayer(){

        let powerUpSequence = SKAction.sequence([powerUpSound])
        player.run(powerUpSequence)

    }
    
    func shouldExplodeNode(_ node: SKNode) -> Bool {
        // if this is an enemy and it's out of bounds, do nothing
        if node is PowerUpNode {
            return false
        }
        // otherwise, explode it!!
        //node.explode()
        return true
    }
    
    func asteroidTouchesPlayer(node: SKNode){
        
        if shieldActive{
            node.explode(frames: asteroidExplosionFrames)
        }
        else{
            gameLogic.asteroidTouchesPlayer()
        }
        
    }
    
    func shieldPowerTouchesPlayer(){
        
        if !shieldActive{

            let shieldPowerSequence = SKAction.sequence([shieldPowerSound])
            
            shieldActive = true
            player.setShield()
            player.run(shieldPowerSequence)

            shieldTimer = Timer.scheduledTimer(withTimeInterval: shieldActivationTime, repeats: false) { (time) in
                
                self.player.removeShield()
                self.shieldTransitionTimer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { (time) in
                    
                    self.player.run(shieldFinishSound)
                    self.shieldActive = false
                }
            }
        }
        
    }
    
//    func fuelEmpty(){
//
//        isFuelEmpty = true
//    }
    
//    func fuelDidChange(fuel:Int){
//
//        if fuel <= 0{
//            isFuelEmpty = true
//            fuelNode.size.width = 0
//        }
//
//        if !gameOverTransitioning && !isFuelEmpty{
//            fuelNode.size.width = CGFloat(fuel * 5)
//        }
//    }
    
    func shouldSpawnPowerUp() {
        if !gameOverTransitioning {
        
        DispatchQueue.global().async {
            
            let power = PowerUpNode(scale: self.scaleFactor)
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
                }
            })
            
            }
        }
    }
    
    func shouldSpawnAsteroid() {
        
        if !gameOverTransitioning {
            
            DispatchQueue.global().async {
                
                let asteroid = AsteroidNode(scale: self.scaleFactor)
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
    
    func shouldSpawnShield() {
        
        if !gameOverTransitioning {
            
            DispatchQueue.global().async {
                
                let shield = ShieldPowerNode(scale: self.scaleFactor)
                shield.name = "shieldPower"
                var moveType = ShieldMove.Straight
                moveType = (arc4random() % 2 == 0 ? .Straight : .Curvy)
                
                shield.move = moveType
                shield.zPosition = 50
                
                let randomXStart = random(min: 10.0, max: self.size.width - 10.0)
                let yStart = self.size.height + 200.0
                
                let randomXEnd = random(min: 10.0, max: self.size.width - 10.0)
                let yEnd: CGFloat = -shield.size.height
                
                DispatchQueue.main.async(execute: {
                    self.addChild(shield)
                    shield.animate()
                    shield.move(from: CGPoint(x: randomXStart, y: yStart), to: CGPoint(x: randomXEnd, y: yEnd)) {
                        //
                    }
                })
                
            }
        }
    }

    


    
}
    
    

    

    
 
    
    



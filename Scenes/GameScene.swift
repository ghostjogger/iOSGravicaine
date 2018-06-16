//
//  GameScene.swift
//  Gravicaine
//
//  Created by Stephen Ball on 04/04/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit
import GameplayKit
import SwiftEntryKit


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
        let sound = SKAction.playSoundFileNamed("score.wav", waitForCompletion: false)
        return SKAction.sequence([scale, unscale, sound])
    }
    
}

class GameScene: SKScene, GameLogicDelegate, UITextFieldDelegate {
   
    static let backgroundNodeNameObject = "background-node-0"

    
    //pop up message vars
    var attributes: EKAttributes
    var message: EKSimpleMessage
    var notificationMessage: EKNotificationMessage
    var notificationView: EKNotificationMessageView

 
    // player
    
    private var player: SpaceShip
    private var shieldActive: Bool = false
    private var shieldTimer = Timer()
    private var shieldTransitionTimer = Timer()
    private var leftTouchActive = false
    private var rightTouchActive = false

    
    //gravity
    private var gravityNode: SKSpriteNode = SKSpriteNode()
    private var gravityNodeLabel: SKLabelNode = SKLabelNode(text: "G")
    

    private var gameOverTransitioning = false
    private var gamePaused = false

    private var wasHighScore = false
    private var highScoreValue = 0
    private var highScoreNameText = ""
    private var highScoreText: UITextField? = nil
    
    let gameArea: CGRect
    var scaleFactor:CGFloat = 0
    
    //barriers
    var leftBarrierNode: SKSpriteNode = SKSpriteNode()
    var rightBarrierNode: SKSpriteNode = SKSpriteNode()
    var barriers = [Int]()
    var barrierCpoints = [Int]()
    var barrierTypes = [Int]()
    var barrierCount = 0
   
    // ui nodes
    private let exitLabel = SKSpriteNode(imageNamed: "exit")
    private let pauseLabel = SKSpriteNode(imageNamed: "pause")
    private var middleIndicator = SKSpriteNode()
    private var startPanel: StartPanelNode? = nil
    private var gameOverPanel: GameOverPanelNode? = nil
    private var highScorePanel: HighScorePanelNode? = nil
    private var pausePanel:PausePanelNode? = nil
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
    
   @objc func setPausedState(){
    
    if gameState == .gameOver || startPanel != nil{
        return
    }
 

    if !gamePaused{
        
        gamePaused = true
        pausePanel?.removeFromParent()
        pausePanel = PausePanelNode(size: self.size)
        pausePanel?.zPosition = 50
        self.addChild(pausePanel!)
        self.scene?.isPaused = true
        
    }
    
    else{
        self.scene?.isPaused = true
    }
    
    
    }
    
    
    
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
        let wait = SKAction.wait(forDuration: 1.8)
        
        let spawn = SKAction.run({[unowned self] in
            
            self.shouldSpawn()
        })
        
        let spawnSequence = SKAction.sequence([spawn,wait])
        let sequence = SKAction.sequence([playerAppear])
        self.player.run(sequence){
            if UserDefaults.standard.bool(forKey: "music"){
            self.addChild(backgroundSound)
            }

        }
        self.run(SKAction.repeatForever(spawnSequence), withKey: "spawning")
    }
    
    private func setGameOverState() {

        gameLogic.gameDidStop()



        if !wasHighScore{
            message = EKSimpleMessage(image: EKProperty.ImageContent(imageName: "gravicaineIcon32"),
                                      title: EKProperty.LabelContent(text: "Game Over! \nTap to try again!!",
                                                                     style: EKProperty.Label(font: UIFont(name: FontName, size: 15.0)!, color: UIColor.white, alignment: NSTextAlignment.center)),
                                      description: EKProperty.LabelContent(text: "You scored :   \(gameLogic.score)",
                                        style: EKProperty.Label(font: UIFont(name: FontName, size: 12.0)!, color: UIColor.white, alignment: NSTextAlignment.center)))
            
            notificationMessage = EKNotificationMessage(simpleMessage: message)
            notificationView = EKNotificationMessageView(with: notificationMessage)
            SwiftEntryKit.display(entry: notificationView, using: attributes)
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
        
        
        //gravity indicators
        gravityNode = SKSpriteNode(texture: nil, color: UIColor.green.withAlphaComponent(0.40), size: CGSize(width: 75 * scaleFactor, height: 150 * scaleFactor))
        gravityNodeLabel.fontName = FontName
        gravityNodeLabel.fontSize = 50.0 * scaleFactor
        gravityNodeLabel.fontColor = UIColor.green
        
        //player init
        player = SpaceShip(scale: scaleFactor)
        
        attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.entryInteraction = .dismiss
        attributes.entryBackground = .image(image: UIImage(named: "panelBackground")!)
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        message = EKSimpleMessage(image: EKProperty.ImageContent(imageName: "gravicaineIcon32"),
                                  title: EKProperty.LabelContent(text: "Game Over! \nTap to try again!!",
                                                                 style: EKProperty.Label(font: UIFont(name: FontName, size: 15.0)!, color: UIColor.white, alignment: NSTextAlignment.center)),
                                  description: EKProperty.LabelContent(text: "You scored :   \(gameLogic.score)",
                                    style: EKProperty.Label(font: UIFont(name: FontName, size: 12.0)!, color: UIColor.white, alignment: NSTextAlignment.center)))
        
        notificationMessage = EKNotificationMessage(simpleMessage: message)
        notificationView = EKNotificationMessageView(with: notificationMessage)
        
        super.init(size: size)
        

        // set up middle indicator stick
        let size = CGSize(width: 2, height: self.size.height)
        middleIndicator = SKSpriteNode(texture: nil, color: UIColor.red.withAlphaComponent(0.4), size: size)
        middleIndicator.zPosition = 1
        middleIndicator.position = CGPoint(x: self.frame.midX, y: self.size.height/2)
        
        

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
    
    deinit {
        unregisterForPauseNotifications()
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

        let sceneToMoveTo = MainMenuScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        self.removeAllActions()
        self.view?.presentScene(sceneToMoveTo)
        return true
    }
    

    
    override func didMove(to view: SKView) {
        

        self.physicsWorld.contactDelegate = gameLogic
        
        registerForPauseNotifications()
        
        barrierCount = 0
        barriers = seedRandom(seed: UInt64(bseed), count: 500, low:1, high:8)
        barrierCpoints = seedRandom(seed: UInt64(bseed), count: 500, low: 1, high: 6)
        barrierTypes = seedRandom(seed: UInt64(bseed), count: 500, low: 1, high: 5)
        
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
        if UserDefaults.standard.bool(forKey: "trans"){
             self.addChild(middleIndicator)
        }
       

        //set up player ship
        
        self.gameState = .waiting
        self.addChild(player)
    
        // score label prep work
        
        scoreLabel?.zPosition = 100
        scoreLabel?.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.95)
        scoreLabel?.text = gameLogic.scoreText()
        self.addChild(scoreLabel!)

        
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
            //player thrust
            
            if leftTouchActive{
                player.physicsBody?.applyForce(CGVector(dx: -thrustPower, dy: 0))
                player.thrustLeft()
            }
            
            if rightTouchActive{
                player.physicsBody?.applyForce(CGVector(dx: thrustPower, dy: 0))
                player.thrustRight()
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
                player.physicsBody?.velocity = CGVector(dx: -1, dy: 0)
              
            }
            
            if player.position.x < self.frame.minX + player.size.width/2
            {
                player.position.x = self.frame.minX + player.size.width/2
                player.physicsBody?.velocity = CGVector(dx: 1, dy: 0)
         
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
            
            if gamePaused{
                gamePaused = false
                self.pausePanel?.removeFromParent()
                self.pausePanel = nil
                self.scene?.isPaused = false
            }

            
            if exitLabel.contains(pointOfTouch){
                
                gameLogic.gameDidStop()
                highScoreText?.removeFromSuperview()
                SwiftEntryKit.dismiss()
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                self.removeAllActions()
                self.view?.presentScene(sceneToMoveTo)
            }
            
            if pauseLabel.contains(pointOfTouch){
                
                gamePaused = true
                pausePanel?.removeFromParent()
                pausePanel = PausePanelNode(size: self.size)
                pausePanel?.zPosition = 50
                self.addChild(pausePanel!)
                self.scene?.isPaused = true

            }


            if pointOfTouch.x < self.size.width / 2{
                if self.gameState == .inGame && !gameOverTransitioning{


                    leftTouchActive = true

                    
                }
            }
            else if pointOfTouch.x >= self.size.width / 2{
                if self.gameState == .inGame && !gameOverTransitioning{

                    
                    rightTouchActive = true
                    
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
            SwiftEntryKit.dismiss()
            let sceneToMoveTo = GameScene(size: self.size)
            sceneToMoveTo.scaleMode = self.scaleMode
            let myTransition = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(sceneToMoveTo, transition:myTransition)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        leftTouchActive = false
        rightTouchActive = false
        player.thrustRightEnded()
        player.thrustLeftEnded()

        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

        leftTouchActive = false
        rightTouchActive = false
        player.thrustRightEnded()
        player.thrustLeftEnded()

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
    
    func shouldSpawn(){
        
        if !gameOverTransitioning {
            
            let next = barriers[barrierCount]
            let type = barrierTypes[barrierCount]
            
            switch type{
                
            case 1:
                spawnNormalBarrier(count: next)
                break
            case 2:
                spawnAsteroidPair()
                break
            case 3:
                spawnMovingBarrier(count: next)
                break
            case 4:
                spawnAsteroidBelt()
                break
            case 5:
                spawnCurvyMovingBarrier(count: next)
                break
            default:
                break
                
                
            }
//            
//            if barrierCount < 10{
//                spawnNormalBarrier(count: next)
//            }
//            else if barrierCount >= 10 && barrierCount < 20{
//                spawnAsteroidPair()
//            }
//            else if barrierCount >= 20 && barrierCount < 30{
//                spawnMovingBarrier(count: next)                
//            }
//            else if barrierCount >= 30 && barrierCount < 40{
//                spawnAsteroidBelt()
//            }
//            else{
//                spawnCurvyMovingBarrier(count: next)
//            }
            
            barrierCount += 1
  

        
        }
    }
    
    func spawnNormalBarrier(count: Int){
        
        DispatchQueue.global().async {

         
            //setup left barrier
            
            let leftBarrier = BarrierNode(scale: self.scaleFactor, name: "Barrier2LBig")
            leftBarrier.move = .Straight
            let leftOffset = ((leftBarrier.size.width/10) * CGFloat(count))
            leftBarrier.position = CGPoint(
                x: (self.frame.minX - leftBarrier.size.width/2) + leftOffset,
                y: self.size.height + CGFloat(barrierHeight))
 
            //setup right barrier
            
            let rightBarrier = BarrierNode(scale: self.scaleFactor, name: "Barrier2RBig")
            rightBarrier.move = .Straight
            rightBarrier.position = (CGPoint(x: leftBarrier.position.x
                + leftBarrier.size.width + (CGFloat(barrierGap) * self.scaleFactor),
                                             y: self.size.height + CGFloat(barrierHeight)))
            
            //setup score gap
            
            let size = CGSize(width: (CGFloat(barrierGap) * self.scaleFactor), height: leftBarrier.size.height)
            let barrierSpaceNode = GapNode( size: size)
            barrierSpaceNode.move = .Straight
            barrierSpaceNode.position = CGPoint(x: leftBarrier.position.x + leftBarrier.size.width/2 + size.width/2, y: self.size.height + (CGFloat(barrierHeight) * 1.75) )
       
            DispatchQueue.main.async(execute: {
                self.addChild(leftBarrier)
                self.addChild(rightBarrier)
                self.addChild(barrierSpaceNode)
                leftBarrier.move(from: CGPoint(x: leftBarrier.position.x, y: leftBarrier.position.y), to: CGPoint(x: leftBarrier.position.x, y: CGFloat(-barrierHeight)), control: 1, cpoint: self.barrierCpoints[self.barrierCount],  run: {
                    
                })
                rightBarrier.move(from: CGPoint(x: rightBarrier.position.x, y: rightBarrier.position.y), to: CGPoint(x: rightBarrier.position.x, y: CGFloat(-barrierHeight)), control: 1, cpoint: self.barrierCpoints[self.barrierCount], run: {
                    
                })
                barrierSpaceNode.move(from: CGPoint(x: barrierSpaceNode.position.x, y: barrierSpaceNode.position.y), to: CGPoint(x: barrierSpaceNode.position.x, y: CGFloat(0)), control: 1, cpoint: self.barrierCpoints[self.barrierCount], run: {
                    
                })
                
            })
        }
        
    }
    
    func spawnMovingBarrier(count: Int){
        
        var left:Bool
        var control:Int
        
        if count < 5{
            left = false
            control = 1
        }
        else{
            left = true
            control = -1
        }
        
        DispatchQueue.global().async {
 
        //setup left barrier
        
        let leftBarrier = BarrierNode(scale: self.scaleFactor, name: "BarrierLongL")
        let leftOffset = ((leftBarrier.size.width/20) * CGFloat(count))
        leftBarrier.move = .Diagonal
        leftBarrier.position = CGPoint(
            x: (self.frame.minX - leftBarrier.size.width/2) + leftOffset,
            y: self.size.height + CGFloat(barrierHeight))
        
        //setup right barrier
        
        let rightBarrier = BarrierNode(scale: self.scaleFactor, name: "BarrierLongR")
        rightBarrier.move = .Diagonal
        rightBarrier.position = (CGPoint(x: leftBarrier.position.x
            + leftBarrier.size.width + (CGFloat(barrierGap) * self.scaleFactor),
                                         y: self.size.height + CGFloat(barrierHeight)))
        
        //setup score gap
            
        let size = CGSize(width: (CGFloat(barrierGap) * self.scaleFactor), height: leftBarrier.size.height)
        let barrierSpaceNode = GapNode( size: size)
        barrierSpaceNode.move = .Diagonal
        barrierSpaceNode.position = CGPoint(x: leftBarrier.position.x + leftBarrier.size.width/2 + size.width/2, y:self.size.height + (CGFloat(barrierHeight) * 1.75))
        
        //setup x movements
            let cpointX = self.barrierCpoints[self.barrierCount]
            
        //leftbarrier x movement
        var leftBarrierXdestination :CGFloat
            
        if left{
            leftBarrierXdestination = leftBarrier.position.x - CGFloat(barrierMovementX * cpointX)
        }
        else{
            leftBarrierXdestination = leftBarrier.position.x + CGFloat(barrierMovementX * cpointX)
        }


        //rightbarrier x movement
        var rightBarrierXdestination :CGFloat
            
        if left{
            rightBarrierXdestination = rightBarrier.position.x - CGFloat(barrierMovementX * cpointX)
        }
        else{
            rightBarrierXdestination = rightBarrier.position.x + CGFloat(barrierMovementX * cpointX)
        }


            
        //barrier gap x movement
        var barrierGapXdestination: CGFloat
        if left{
            barrierGapXdestination = barrierSpaceNode.position.x - CGFloat(barrierMovementX * cpointX)
        }
        else{
             barrierGapXdestination = barrierSpaceNode.position.x + CGFloat(barrierMovementX * cpointX)
        }


            
            DispatchQueue.main.async(execute: {

                self.addChild(leftBarrier)
                self.addChild(rightBarrier)
                self.addChild(barrierSpaceNode)
                leftBarrier.move(from: CGPoint(x: leftBarrier.position.x, y: leftBarrier.position.y), to: CGPoint(x: leftBarrierXdestination, y: CGFloat(-barrierHeight)), control: control, cpoint: self.barrierCpoints[self.barrierCount], run: {
                    
                })
                rightBarrier.move(from: CGPoint(x: rightBarrier.position.x, y: rightBarrier.position.y), to: CGPoint(x: rightBarrierXdestination, y: CGFloat(-barrierHeight)), control:control, cpoint: self.barrierCpoints[self.barrierCount],  run: {
                    
                })
                barrierSpaceNode.move(from: CGPoint(x: barrierSpaceNode.position.x, y: barrierSpaceNode.position.y), to: CGPoint(x: barrierGapXdestination, y: CGFloat(0)), control: control,  cpoint: self.barrierCpoints[self.barrierCount], run: {
                    
                })
                

            })
        
        }
    }
    
    func spawnCurvyMovingBarrier(count: Int){

        var control:Int
        
        if count < 5{
            control = 1
        }
        else{
            control = -1
        }
        
        DispatchQueue.global().async {
            
            
            //setup left barrier
            
            let leftBarrier = BarrierNode(scale: self.scaleFactor, name: "Barrier2LBig")
            leftBarrier.move = .Curvy
            let leftOffset = ((leftBarrier.size.width/10) * CGFloat(count))
            leftBarrier.position = CGPoint(
                x: (self.frame.minX - leftBarrier.size.width/2) + leftOffset,
                y: self.size.height + CGFloat(barrierHeight))
            
            //setup right barrier
            
            let rightBarrier = BarrierNode(scale: self.scaleFactor, name: "Barrier2RBig")
            rightBarrier.move = .Curvy
            rightBarrier.position = (CGPoint(x: leftBarrier.position.x
                + leftBarrier.size.width + (CGFloat(barrierGap) * self.scaleFactor),
                                             y: self.size.height + CGFloat(barrierHeight)))
            
            
            //setup score gap
            
            let size = CGSize(width: (CGFloat(barrierGap) * self.scaleFactor), height: leftBarrier.size.height)
            let barrierSpaceNode = GapNode( size: size)
            barrierSpaceNode.move = .Curvy
            barrierSpaceNode.position = CGPoint(x: leftBarrier.position.x + leftBarrier.size.width/2 + size.width/2, y: self.size.height +  (CGFloat(barrierHeight) * 1.75))

            
            DispatchQueue.main.async(execute: {
                self.addChild(leftBarrier)
                self.addChild(rightBarrier)
                self.addChild(barrierSpaceNode)
                leftBarrier.move(from: CGPoint(x: leftBarrier.position.x, y: leftBarrier.position.y), to: CGPoint(x: leftBarrier.position.x, y: CGFloat(-barrierHeight)), control: control, cpoint: self.barrierCpoints[self.barrierCount],  run: {
                    
                })
                rightBarrier.move(from: CGPoint(x: rightBarrier.position.x, y: rightBarrier.position.y), to: CGPoint(x: rightBarrier.position.x, y: CGFloat(-barrierHeight)), control: control,cpoint: self.barrierCpoints[self.barrierCount],run: {
                    
                })
                barrierSpaceNode.move(from: CGPoint(x: barrierSpaceNode.position.x, y: barrierSpaceNode.position.y), to: CGPoint(x: barrierSpaceNode.position.x, y: CGFloat(0)),control: control, cpoint: self.barrierCpoints[self.barrierCount],run: {
                    
                })
                
            })
        }
        
    }
    
    func spawnAsteroidPair(){
        var redAsteroids = [RedAsteroidNode]()
        var greyAsteroids = [GreyAsteroidNode]()
        
        let size = CGSize(width: self.frame.width, height: 10.0)
        let scoreNode = GapNode(size: size)
        
        let yStart = self.frame.maxY + CGFloat(75)
        let minX = CGFloat(self.frame.minX + CGFloat(30))
        let maxX = CGFloat(self.frame.maxX - CGFloat(30))
        DispatchQueue.global().async {
        for _ in 1...2 {
            
            let ra = RedAsteroidNode(scale: self.scaleFactor)
            ra.position = CGPoint(x: random(min: minX, max: maxX), y: yStart)
            redAsteroids.append(ra)
            let ga = GreyAsteroidNode(scale: self.scaleFactor)
            ga.position = CGPoint(x: random(min: minX, max: maxX), y: yStart)
            greyAsteroids.append(ga)
            }
        scoreNode.position = CGPoint(x: self.frame.midX, y: yStart + 120)
  
            DispatchQueue.main.async(execute: {
                
                let playerX = self.player.position.x
                
                for node in redAsteroids{
                    
                    self.addChild(node)
                    node.animate()
                    node.move(from: node.position,
                              to: CGPoint(x: random(min: playerX - 50, max: playerX + 50), y: self.frame.minY),
                              control: 1,
                              cpoint: 1,
                              run: {
                        
                    })

                }
                
                for node in greyAsteroids{
                    
                    self.addChild(node)
                    node.animate()
                    node.move(from: node.position,
                              to: CGPoint(x: random(min: playerX - 50, max: playerX + 50), y: self.frame.minY),
                              control: 1,
                              cpoint: 1,
                              run: {
                                
                    })
                    
                }
                
                self.addChild(scoreNode)
                scoreNode.move(from: scoreNode.position,
                               to: CGPoint(x: self.frame.midX, y: self.frame.minY + 120),
                               control: 1,
                               cpoint: 1,
                               run: {
                                
                })
                
                
            })
        }
    }
    
    func spawnAsteroidBelt(){
        
        var redAsteroids = [RedAsteroidNode]()
        var greyAsteroids = [GreyAsteroidNode]()
        
        let size = CGSize(width: self.frame.width, height: 10.0)
        let scoreNode = GapNode(size: size)
        
        let yStart = self.frame.maxY + CGFloat(75)
        let minX = CGFloat(self.frame.minX)
        let maxX = CGFloat(self.frame.maxX)
        let xGap = (self.frame.width)/4
        
        DispatchQueue.global().async {
                let ra1 = RedAsteroidNode(scale: self.scaleFactor)
                ra1.position = CGPoint(x: self.frame.width * 0.05 , y: yStart)
                redAsteroids.append(ra1)
                let ra2 = RedAsteroidNode(scale: self.scaleFactor)
                ra2.position = CGPoint(x: self.frame.width * 0.65, y: yStart)
                redAsteroids.append(ra2)
                let ga1 = GreyAsteroidNode(scale: self.scaleFactor)
                ga1.position = CGPoint(x: self.frame.width * 0.35, y: yStart)
                greyAsteroids.append(ga1)
                let ga2 = GreyAsteroidNode(scale: self.scaleFactor)
                ga2.position = CGPoint(x: self.frame.width * 0.95, y: yStart)
                greyAsteroids.append(ga2)
        
            scoreNode.position = CGPoint(x: self.frame.midX, y: yStart + 120)
            
            DispatchQueue.main.async(execute: {
                
                let playerX = self.player.position.x
                
                for node in redAsteroids{
                    
                    self.addChild(node)
                    node.animate()
                    node.move(from: node.position,
                              to: CGPoint(x: node.position.x, y: self.frame.minY),
                              control: 1,
                              cpoint: 1,
                              run: {
                                
                    })
                    
                }
                
                for node in greyAsteroids{
                    
                    self.addChild(node)
                    node.animate()
                    node.move(from: node.position,
                              to: CGPoint(x: node.position.x, y: self.frame.minY),
                              control: 1,
                              cpoint: 1,
                              run: {
                                
                    })
                    
                }
                
                self.addChild(scoreNode)
                scoreNode.move(from: scoreNode.position,
                               to: CGPoint(x: self.frame.midX, y: self.frame.minY + 120),
                               control: 1,
                               cpoint: 1,
                               run: {
                                
                })
                
                
            })
            
        }
        
        
    }
    
    
    func barrierTouchesPlayer(isHighScore: Bool, highScore: Int){
 
        if !shieldActive {
        self.removeAllActions()
        gameOverTransitioning = true
        wasHighScore = isHighScore
        highScoreValue = highScore
            
        for node in self.children{
            node.removeAllActions()
        }
        if self.children.contains(backgroundSound){
                backgroundSound.removeFromParent()
        }
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

}




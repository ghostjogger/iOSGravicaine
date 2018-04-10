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
    var barrierCurrentCount = 0
    let barrier = Barrier()

    
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
    
 
    
    override init(size:CGSize) {
        
        //setup screen area
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        

        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - game state
    private func setWaitingGameState() {
       

        
    }
    
    private func setInGameState() {
        
        gameLogic.gameDidStart()
        

        
    }
    
    private func setGameOverState() {
        gameLogic.gameDidStop()
        self.setWaitingGameState()
    }
    
    override func didMove(to view: SKView) {
        
        barrierCurrentCount = 0
        
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
        
//        for i in 0...Barrier.barrierStoredCodes.count - 1{
//            print("value: \(Barrier.barrierStoredCodes[i])")
//        }
        
 
        
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.1)
        self.addChild(player)
        
        startLabel.fontName = "Jellee-Roman"
        startLabel.fontColor = UIColor.white
        startLabel.fontSize = 100
        startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.9)
        self.addChild(startLabel)
        
       
    }
    
    var lastUpdateTime:TimeInterval = 0
    var deltaFrameTime:TimeInterval = 0
    var timer:TimeInterval = 0
    var timerAdd:TimeInterval = 0
    var speedToMove:CGFloat = 200.0
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0
        {
            lastUpdateTime = currentTime
            timer = currentTime
            timerAdd = currentTime
        }
        else
        {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        timerAdd += (currentTime - timer)
        
        if timerAdd - timer > Barrier.barrierFrequency{
            produceBarrier()
            timer = currentTime
            timerAdd = currentTime
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
    
    func produceBarrier(){
        
        // two actions
        let moveBarrier = SKAction.moveTo(y: 0, duration: 1)
        let appearBarrier = SKAction.fadeAlpha(to: 1.0, duration: 0.15)
        let barrierAnimation = SKAction.group([moveBarrier, appearBarrier])
        let deleteBarrier = SKAction.removeFromParent()
        
        // sequence of actions
        let barrierSequence = SKAction.sequence([ barrierAnimation, deleteBarrier])
        
        
        if barrierCurrentCount < Barrier.barrierStoredCodes.count{
            
          
            
            var i = Barrier.barrierStoredCodes[barrierCurrentCount]
            
            print("Barrier Produced \(timerAdd , timer, barrierCurrentCount, i)" )

            var leftBarrier = SKSpriteNode()
            var rightBarrier =  SKSpriteNode()

            switch i {

            case 1 :
                
                leftBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: (i+1) * Barrier.widthFraction, height: Barrier.barrierHeight))
                leftBarrier.position = (CGPoint(x: 0, y: self.size.height - 75))
                rightBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: 4 * Barrier.widthFraction, height: Barrier.barrierHeight))
                rightBarrier.position = CGPoint(x: 1536 - (1536/6), y: self.size.height - 75)
            case 2 :
                leftBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: (i+1) * Barrier.widthFraction, height: Barrier.barrierHeight))
                leftBarrier.position = (CGPoint(x: 0, y: self.size.height - 75))
                rightBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width:  3 * Barrier.widthFraction, height: Barrier.barrierHeight))
                rightBarrier.position = CGPoint(x: 1536 - (1536/6), y: self.size.height - 75)
            case 3 :
                leftBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: (i+1) * Barrier.widthFraction, height: Barrier.barrierHeight))
                leftBarrier.position = (CGPoint(x: 0, y: self.size.height - 75))
                rightBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: 2 * Barrier.widthFraction, height: Barrier.barrierHeight))
                rightBarrier.position = CGPoint(x: 1536 - (1536/6), y: self.size.height - 75)
            case 4 :
                leftBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: (i+1) * Barrier.widthFraction, height: Barrier.barrierHeight))
                leftBarrier.position = (CGPoint(x: 0, y: self.size.height - 75))
                rightBarrier = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: 1 * Barrier.widthFraction, height: Barrier.barrierHeight))
                rightBarrier.position = CGPoint(x: 1536 - (1536/6), y: self.size.height - 75)


            default: break

            }

            self.addChild(leftBarrier)
            self.addChild(rightBarrier)
            leftBarrier.run(barrierSequence)
            rightBarrier.run(barrierSequence)
            
            barrierCurrentCount += 1
            
        }
        
        else{
            print("Game over")
        }
       
    }
    
    // MARK: - game logic delegate
    
    func scoreDidChange(_ newScore: Int, text: String!) {
        

        
    }
    
    func livesDidChange(oldLives: Int, newLives: Int) {
        

        
    }
    
    func playerDidLose(destroyed: Bool) {
        

        
    }
    
    func shouldSpawnEnemy(enemySpeedMultiplier: CGFloat) {
        
 
        
    }
    
    func shouldSpawnBonus() {
        

        
    }
    
    func shouldExplodeNode(_ node: SKNode) -> Bool {

        return true
    }
    
    func shouldIncreaseSpeed() {
        
    }
    
 
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return Gravicaine.random() * (max - min) + min
    }
    
}
    
    

    

    
 
    
    



//
//  GameLogic.swift
//  Gravicaine
//
//  Created by Stephen Ball on 23/05/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit

protocol GameLogicDelegate: class {
    
    func scoreDidChange(_ newScore: Int, text: String!)
    func shouldSpawnBarrier()
    func barrierTouchesPlayer(isHighScore: Bool, highScore: Int)
    func fuelDidChange(fuel:Int)
    func fuelEmpty()
    func shouldSpawnPowerUp()
    func powerUpTouchesPlayer()
    func shouldSpawnAsteroid()
}

class GameLogic: NSObject, SKPhysicsContactDelegate {

    private static let DefaultScore: Int = 0

    
    
    // MARK: - delegate
    
    weak var delegate: GameLogicDelegate? = nil
    
    // MARK: - private
    
    private func gameOver(playerDestroyed destroyed: Bool) {
        if score > UserDefaults.standard.integer(forKey: HighScoreKey)
        {
            delegate?.barrierTouchesPlayer(isHighScore: true, highScore: self.score)
        }
        else
        {
            delegate?.barrierTouchesPlayer(isHighScore: false, highScore: self.score)
        }
    }
    

    
    // MARK: - score
    
    private(set) var score: Int = GameLogic.DefaultScore {
        didSet
        {
            if oldValue != score
            {
                delegate?.scoreDidChange(score, text: self.scoreText())
            }
        }
    }
    
    // MARK: - power
    private static let DefaultPowerSpawnInterval = 5.0
    
    //MARK - asteroid
    private static let DefaultAsteroidSpawnInterval = 1.5
    
    // MARK: - fuel
    
    private var fuelReducer: Timer? = nil
    private let fuelReducerFrequency: TimeInterval = 1.0
    private static let defaultFuel = 100
    
    private(set) var fuel: Int = GameLogic.defaultFuel {
        didSet
        {
            if oldValue != fuel
            {
                delegate?.fuelDidChange(fuel:fuel)
            }
        }
    }
    
    @objc private func reduceFuel(_ timer: Timer) {
        fuel -= 1
        self.startReducingFuel()
        
    }
    
    private func startReducingFuel() {
        
       fuelReducer = Timer.scheduledTimer(timeInterval: TimeInterval(fuelReducerFrequency),
                                              target: self,
                                              selector: #selector(GameLogic.reduceFuel(_:)),
                                              userInfo: nil,
                                              repeats: false)
    }
    
    private func stopReducingFuel() {
        fuelReducer?.invalidate()
        fuelReducer = nil
    }
    
    func addFuel(amount: Int){        
        fuel += amount
    }
    
    
    
    func scoreText() -> String! {
        return "\(score)"
    }
    
    // MARK: - asteroids
    
    private var spawnAsteroidInterval: TimeInterval = GameLogic.DefaultAsteroidSpawnInterval
    private var asteroidSpawner: Timer? = nil
    
    @objc private func spawnAsteroid(_ timer: Timer) {
        delegate?.shouldSpawnAsteroid()
    }
    
    private func startSpawningAsteroids() {
        asteroidSpawner = Timer.scheduledTimer(timeInterval:TimeInterval(spawnAsteroidInterval) ,
                                            target: self,
                                            selector: #selector(GameLogic.spawnAsteroid(_:)),
                                            userInfo: nil,
                                            repeats: true)
    }
    
    private func stopSpawningAsteroids() {
        asteroidSpawner?.invalidate()
        asteroidSpawner = nil
    }
    

    // MARK: - powerups
    
    private var spawnPowerInterval: TimeInterval = GameLogic.DefaultPowerSpawnInterval
    private var powerSpawner: Timer? = nil
    
    @objc private func spawnPower(_ timer: Timer) {
        delegate?.shouldSpawnPowerUp()
    }
    
    private func startSpawningPower() {
        powerSpawner = Timer.scheduledTimer(timeInterval: Double(random(min: CGFloat(2.0), max: CGFloat(spawnPowerInterval))) ,
                                              target: self,
                                              selector: #selector(GameLogic.spawnPower(_:)),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    private func stopSpawningPower() {
        powerSpawner?.invalidate()
        powerSpawner = nil
    }
    
    // MARK: - barrier
    
    private var barrierSpawner: Timer? = nil
    private let barrierFrequency: TimeInterval = 3.0
    
    @objc private func spawnBarrier(_ timer: Timer) {
        delegate?.shouldSpawnBarrier()
        self.startSpawningBarrier()
       
    }
    
    private func startSpawningBarrier() {
       
        barrierSpawner = Timer.scheduledTimer(timeInterval: Double(random(min: CGFloat(2.0), max: CGFloat(barrierFrequency))),
                                            target: self,
                                            selector: #selector(GameLogic.spawnBarrier(_:)),
                                            userInfo: nil,
                                            repeats: false)
    }
    
    private func stopSpawningBarrier() {
        barrierSpawner?.invalidate()
        barrierSpawner = nil
    }
    
    func passBarrier(){
        self.score += 1
    }
    
    func gameDidStart() {
        
self.stopSpawningBarrier()
        //self.startSpawningBarrier()
        self.startReducingFuel()
        self.startSpawningPower()
        //self.startSpawningAsteroids()
        
    }
    
    func gameDidStop(){
        self.stopSpawningBarrier()
        self.stopReducingFuel()
        self.stopSpawningPower()
        self.stopSpawningAsteroids()
    }
    

    
    // MARK: - SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // organise bodies by category bitmask order
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
            {
                body1 = contact.bodyA
                body2 = contact.bodyB
            }
            else
            {
                body1 = contact.bodyB
                body2 = contact.bodyA
            }

        // player hits barrier
        if      body1.categoryBitMask == PhysicsCategories.Player
            &&  body2.categoryBitMask == PhysicsCategories.Barrier
            {
                self.barrierTouchesPlayer()
            }
        //player hits powerup
        if      body1.categoryBitMask == PhysicsCategories.Player
            &&  body2.categoryBitMask == PhysicsCategories.PowerUp
            {
                self.powerUpTouchesPlayer()
            }
        
        //player hits asteroid
        if      body1.categoryBitMask == PhysicsCategories.Player
            &&  body2.categoryBitMask == PhysicsCategories.Asteroid
        {
            self.asteroidTouchesPlayer()
        }
//
//        // bullet hits enemy
//        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy {
//            if let node = body2.node {
//                if ((delegate?.shouldExplodeNode(node)) != nil) {
//                    self.enemyKilled()
//                }
//            }
//            // ... and bullet disappear
//            body1.node?.removeFromParent()
//        }
   
        // MARK: - implementation
    }


    func barrierTouchesPlayer(){
        if !GodMode
        {
            self.gameOver(playerDestroyed: true)
        }
    }
    
    func powerUpTouchesPlayer(){
        self.fuel = GameLogic.defaultFuel
        delegate?.powerUpTouchesPlayer()
    }
    
    func asteroidTouchesPlayer(){
        if !GodMode
        {
            self.gameOver(playerDestroyed: true)
        }
    }
    
    func updateHighScore(name: String, score: Int){
        
        UserDefaults.standard.set(score, forKey: HighScoreKey)
        UserDefaults.standard.set(name, forKey: HighScoreName)
    
    }
    


    
}

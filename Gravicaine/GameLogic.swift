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
    func shouldSpawn()
    func barrierTouchesPlayer(isHighScore: Bool, highScore: Int)
    //func fuelDidChange(fuel:Int)
    //func fuelEmpty()
    func shouldSpawnPowerUp()
    func powerUpTouchesPlayer()
    func shouldSpawnAsteroid()
    func shouldSpawnShield()
    func shieldPowerTouchesPlayer()
    func asteroidTouchesPlayer(node: SKNode)
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
    
    
    
    func scoreText() -> String! {
        return "\(score)"
    }
    
    
    func updateHighScore(name: String, score: Int){
        
        UserDefaults.standard.set(score, forKey: HighScoreKey)
        UserDefaults.standard.set(name, forKey: HighScoreName)
        
    }
    

    
    
    func barrierTouchesPlayer(){
        if !GodMode
        {
            self.gameOver(playerDestroyed: true)
        }
    }
    


    func gameDidStart() {

        
    }
    
    func gameDidStop(){
        
 

    }
    
    func gameDidPause(){
        
    }
    
    
    func gameDidUnpause(){
        
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
        
        //player contacts BarrierGap
        if      body1.categoryBitMask == PhysicsCategories.Player
            &&  body2.categoryBitMask == PhysicsCategories.BarrierGap
            {
                body2.node?.removeFromParent()
                self.score += 1
            }
        
        
        // player hits barrier
        if      body1.categoryBitMask == PhysicsCategories.Player
            &&  body2.categoryBitMask == PhysicsCategories.Barrier
        {
            self.barrierTouchesPlayer()
        }
        
        
    }
        
        //player hits shieldpowerup
        //        if      body1.categoryBitMask == PhysicsCategories.Player
        //            &&  body2.categoryBitMask == PhysicsCategories.ShieldPower
        //        {
        //            body2.node?.removeFromParent()
        //            self.shieldPowerTouchesPlayer()
        //        }
        // asteroid hits barrier
//        if      body1.categoryBitMask == PhysicsCategories.Barrier
//            &&  body2.categoryBitMask == PhysicsCategories.Asteroid
//        {
//            if let node = body2.node{
//                node.explode(frames: asteroidExplosionFrames)
//            }
//        }
        
        //player hits asteroid
//        if      body1.categoryBitMask == PhysicsCategories.Player
//            &&  body2.categoryBitMask == PhysicsCategories.Asteroid
//        {
//            if let node = body2.node{
//                if !GodMode
//                {
//                    delegate?.asteroidTouchesPlayer(node: node)
//                }
//            }
//
//        }
        

        

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
//    }


    
//    func powerUpTouchesPlayer(){
//        self.fuel = GameLogic.defaultFuel
//        delegate?.powerUpTouchesPlayer()
//    }
    
//    func shieldPowerTouchesPlayer(){
//
//        delegate?.shieldPowerTouchesPlayer()
//
//    }
//
//    func asteroidTouchesPlayer(){
//        if !GodMode
//        {
//            self.gameOver(playerDestroyed: true)
//        }
//    }

    // MARK: - power
    //private static let DefaultPowerSpawnInterval = 20.0
    
    //MARK - asteroid
    //private static let DefaultAsteroidSpawnInterval = 3.0
    
    // MARK: - fuel
    
    //    private var fuelReducer: Timer? = nil
    //    private let fuelReducerFrequency: TimeInterval = 1.0
    //    private static let defaultFuel = 100
    
    //    private(set) var fuel: Int = GameLogic.defaultFuel {
    //        didSet
    //        {
    //            if oldValue != fuel
    //            {
    //                delegate?.fuelDidChange(fuel:fuel)
    //            }
    //        }
    //    }
    //
    //    @objc private func reduceFuel(_ timer: Timer) {
    //        fuel -= 1
    //        self.startReducingFuel()
    //
    //    }
    //
    //    private func startReducingFuel() {
    //
    //       fuelReducer = Timer.scheduledTimer(timeInterval: TimeInterval(fuelReducerFrequency),
    //                                              target: self,
    //                                              selector: #selector(GameLogic.reduceFuel(_:)),
    //                                              userInfo: nil,
    //                                              repeats: false)
    //    }
    //
    //    private func stopReducingFuel() {
    //        fuelReducer?.invalidate()
    //        fuelReducer = nil
    //    }
    //
    //    func addFuel(amount: Int){
    //        fuel += amount
    //    }
    
    
    // MARK: - asteroids
    
    //    private var spawnAsteroidInterval: TimeInterval = GameLogic.DefaultAsteroidSpawnInterval
    //    private var asteroidSpawner: Timer? = nil
    //
    //    @objc private func spawnAsteroid(_ timer: Timer) {
    //        delegate?.shouldSpawnAsteroid()
    //    }
    //
    //    private func startSpawningAsteroids() {
    //        asteroidSpawner = Timer.scheduledTimer(timeInterval:TimeInterval(spawnAsteroidInterval) ,
    //                                            target: self,
    //                                            selector: #selector(GameLogic.spawnAsteroid(_:)),
    //                                            userInfo: nil,
    //                                            repeats: true)
    //    }
    //
    //    private func stopSpawningAsteroids() {
    //        asteroidSpawner?.invalidate()
    //        asteroidSpawner = nil
    //    }
    
    
    // MARK: - powerups
    //
    //    private var spawnPowerInterval: TimeInterval = GameLogic.DefaultPowerSpawnInterval
    //    private var powerSpawner: Timer? = nil
    //
    //    @objc private func spawnPower(_ timer: Timer) {
    //        delegate?.shouldSpawnPowerUp()
    //    }
    //
    //    private func startSpawningPower() {
    //        powerSpawner = Timer.scheduledTimer(timeInterval: Double(random(min: CGFloat(12.0), max: CGFloat(spawnPowerInterval))) ,
    //                                              target: self,
    //                                              selector: #selector(GameLogic.spawnPower(_:)),
    //                                              userInfo: nil,
    //                                              repeats: true)
    //    }
    //
    //    private func stopSpawningPower() {
    //        powerSpawner?.invalidate()
    //        powerSpawner = nil
    //    }
    
    
    
    
    // MARK: - shield
    
    //    private var shieldSpawner: Timer? = nil
    //    private let shieldFrequency: TimeInterval = 10.0
    //
    //    @objc private func spawnShield(_ timer: Timer) {
    //        delegate?.shouldSpawnShield()
    //        self.startSpawningShield()
    //
    //    }
    //
    //    private func startSpawningShield() {
    //
    //        shieldSpawner = Timer.scheduledTimer(timeInterval: shieldFrequency,
    //                                              target: self,
    //                                              selector: #selector(GameLogic.spawnShield(_:)),
    //                                              userInfo: nil,
    //                                              repeats: false)
    //    }
    //
    //    private func stopSpawningShield() {
    //        shieldSpawner?.invalidate()
    //        shieldSpawner = nil
    //    }
    
    
    // MARK: - barrier
    //
    //    private var spawner: Timer? = nil
    //    private let frequency: TimeInterval = 1.5
    //
    //    @objc private func spawn(_ timer: Timer) {
    //        delegate?.shouldSpawn()
    //        self.startSpawning()
    //
    //    }
    //
    //    private func startSpawning() {
    //
    //        spawner = Timer.scheduledTimer(timeInterval: frequency,
    //                                              target: self,
    //                                              selector: #selector(GameLogic.spawn(_:)),
    //                                              userInfo: nil,
    //                                              repeats: false)
    //    }
    //
    //    private func stopSpawning() {
    //        spawner?.invalidate()
    //        spawner = nil
    //    }

    
}

//
//  GameLogic.swift
//

import SpriteKit

protocol GameLogicDelegate: class {
    
    func scoreDidChange(_ newScore: Int, text: String!)
    func shouldSpawnBarrier()
    func barrierTouchesPlayer()
    func fuelDidChange(fuel:Int)
    func fuelEmpty()
    func shouldSpawnPowerUp()
    func powerUpTouchesPlayer()
}

class GameLogic: NSObject, SKPhysicsContactDelegate {

    private static let DefaultScore: Int = 0
    
    
    // MARK: - delegate
    
    weak var delegate: GameLogicDelegate? = nil
    
    // MARK: - private
    
    private func gameOver(playerDestroyed destroyed: Bool) {
        if score > UserDefaults.standard.integer(forKey: HighScoreKey) {
            UserDefaults.standard.set(score, forKey: HighScoreKey)
        }
        delegate?.barrierTouchesPlayer()
        
    }
    
    // MARK: - score
    
    private(set) var score: Int = GameLogic.DefaultScore {
        didSet {
            if oldValue != score {
                delegate?.scoreDidChange(score, text: self.scoreText())
            }
        }
    }
    
    // MARK: - power
    private static let DefaultPowerSpawnInterval = 5.0
    
    // MARK: - fuel
    
    private var fuelReducer: Timer? = nil
    private let fuelReducerFrequency: TimeInterval = 0.4
    private static let defaultFuel = 100
    
    private(set) var fuel: Int = GameLogic.defaultFuel {
        didSet {
            if oldValue != fuel {
                print(fuel)
                delegate?.fuelDidChange(fuel:fuel)
            }
        }
    }
    
    @objc private func reduceFuel(_ timer: Timer) {
        print(fuel)
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
    

    // MARK: - powerups
    
    private var spawnPowerInterval: TimeInterval = GameLogic.DefaultPowerSpawnInterval
    private var powerSpawner: Timer? = nil
    
    @objc private func spawnPower(_ timer: Timer) {
        delegate?.shouldSpawnPowerUp()
    }
    
    private func startSpawningPower() {
        powerSpawner = Timer.scheduledTimer(timeInterval: spawnPowerInterval,
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
    private let barrierFrequency: TimeInterval = 2.5
    
    @objc private func spawnBarrier(_ timer: Timer) {
        delegate?.shouldSpawnBarrier()
        self.startSpawningBarrier()
       
    }
    
    private func startSpawningBarrier() {
       
        barrierSpawner = Timer.scheduledTimer(timeInterval: TimeInterval(barrierFrequency),
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
        self.startSpawningBarrier()
        self.startReducingFuel()
        self.startSpawningPower()
        //self.stopSpawningPlanet()
        //self.startSpawningPlanet()
        
    }
    
    func gameDidStop(){
        self.stopSpawningBarrier()
        self.stopReducingFuel()
        self.stopSpawningPower()
    }
    

    
    // MARK: - SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // organise bodies by category bitmask order
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }

        // player hits barrier
        if      body1.categoryBitMask == PhysicsCategories.Player
            &&  body2.categoryBitMask == PhysicsCategories.Barrier {
                self.barrierTouchesPlayer()
            }
        //player hits powerup
        if      body1.categoryBitMask == PhysicsCategories.Player
            &&  body2.categoryBitMask == PhysicsCategories.PowerUp {
                self.powerUpTouchesPlayer()
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
        if !GodMode {
            self.gameOver(playerDestroyed: true)
        }
    }
    
    func powerUpTouchesPlayer(){
        print("collision")
        self.fuel = GameLogic.defaultFuel
        delegate?.powerUpTouchesPlayer()
    }
    


    
}

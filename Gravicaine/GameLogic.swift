//
//  GameLogic.swift
//

import SpriteKit

protocol GameLogicDelegate: class {
    
    func scoreDidChange(_ newScore: Int, text: String!)
    func shouldSpawnBarrier()
    func shouldSpawnPlanet()
    func barrierTouchesPlayer()

}

class GameLogic: NSObject, SKPhysicsContactDelegate {

    private static let DefaultScore: Int = 0
    
    // MARK: - delegate
    
    weak var delegate: GameLogicDelegate? = nil
    
    // MARK: - score
    
    private(set) var score: Int = GameLogic.DefaultScore {
        didSet {
            if oldValue != score {
                delegate?.scoreDidChange(score, text: self.scoreText())
            }
        }
    }
    
    
    func scoreText() -> String! {
        return "SCORE : \(score)"
    }
    

    
    // MARK: - planet
    
    private var planetSpawner: Timer? = nil
    
    @objc private func spawnPlanet(_ timer: Timer) {
        delegate?.shouldSpawnPlanet()
        self.startSpawningPlanet()
    }
    
    private func startSpawningPlanet() {
        let waitTime = random(min: 1.0, max: 5.0)
        planetSpawner = Timer.scheduledTimer(timeInterval: TimeInterval(waitTime),
                                            target: self,
                                            selector: #selector(GameLogic.spawnPlanet(_:)),
                                            userInfo: nil,
                                            repeats: false)
    }
    
    private func stopSpawningPlanet() {
        planetSpawner?.invalidate()
        planetSpawner = nil
    }
    
    // MARK: - barrier
    
    private var barrierSpawner: Timer? = nil
    private let barrierFrequency: TimeInterval = 1.5
    
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
        self.score += 10
    }
    
    func gameDidStart() {
        
        self.stopSpawningBarrier()
        self.startSpawningBarrier()
        //self.stopSpawningPlanet()
        //self.startSpawningPlanet()
        
    }
    
    func gameDidStop(){
        self.stopSpawningBarrier()
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
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Barrier {

            self.barrierTouchesPlayer()
            delegate?.barrierTouchesPlayer()
        
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

    }
    


    
}

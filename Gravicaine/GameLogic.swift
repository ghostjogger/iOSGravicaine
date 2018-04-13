//
//  GameLogic.swift
//

import SpriteKit

protocol GameLogicDelegate: class {
    
    func shouldSpawnBarrier()
    func barrierTouchesPlayer()

}

class GameLogic: NSObject, SKPhysicsContactDelegate {

 
    
    // MARK: - delegate
    
    weak var delegate: GameLogicDelegate? = nil
    
    // MARK: - bonus
    
    private var barrierSpawner: Timer? = nil
    private let barrierFrequency: TimeInterval = 2.0
    
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
    
    func gameDidStart() {
        
        self.stopSpawningBarrier()
        self.startSpawningBarrier()
        
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

            print("boom")
        
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

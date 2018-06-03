//
//  Utils.swift
//  Gravicaine
//
//  Created by Stephen Ball on 23/05/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import CoreGraphics
import SpriteKit
import GameplayKit



let GodMode: Bool = false
let FontName: String = "Jellee-Roman"
let HighScoreKey: String = "HighScore"
let HighScoreName: String = "HighScoreName"


struct PhysicsCategories {
    static let None:    UInt32 = 0      // 0
    static let Player:  UInt32 = 0b1    // 1
    static let Bullet:  UInt32 = 0b10   // 2
    static let Enemy:   UInt32 = 0b100  // 4
    static let Barrier: UInt32 = 0b1000 // 8
    static let Asteroid: UInt32 = 0b10000 // 16
    static let PowerUp: UInt32 = 0b100000 //32
    static let ShieldPower: UInt32 = 0b1000000 //64
    static let Shield: UInt32 = 0b10000000 //128
    
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func seedRandom(seed: UInt64) -> [Int]{
    
    let rs = GKMersenneTwisterRandomSource()
    rs.seed = seed
    
    
    var randomArray = [Int]()
    // Use the random source and a lowest and highest value to create a
    // GKRandomDistribution object that will provide the random numbers.
    let rd = GKRandomDistribution(randomSource: rs, lowestValue: 0, highestValue: 100)
    
    // Now generate 10 numbers in the range 0...100:
    for _ in 1...10 {
        let i = rd.nextInt()
        randomArray.append(i)
        print(i)
    }
    
    print("---")
    
    // Let's set the seed back to the starting value, and print the same 10
    // random numbers.
    rs.seed = seed
    for _ in 1...10 {
        print(rd.nextInt())
    }
    
    return randomArray
    
    
}



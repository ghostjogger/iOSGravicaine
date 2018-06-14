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
    let rd = GKRandomDistribution(randomSource: rs, lowestValue: 0, highestValue: 9)
    
    // Now generate 100 numbers in the range 0...9:
    for _ in 1...100 {
        let i = rd.nextInt()
        randomArray.append(i)
    }

    return randomArray
    
    
}

func seedRandom(seed: UInt64, count: Int, low: Int, high: Int) -> [Int]{
    
    let rs = GKMersenneTwisterRandomSource()
    rs.seed = seed
    
    var randomArray = [Int]()
    // Use the random source and a lowest and highest value to create a
    // GKRandomDistribution object that will provide the random numbers.
    let rd = GKRandomDistribution(randomSource: rs, lowestValue: low, highestValue: high)
    
    // Now generate count numbers in the range low...high:
    for _ in 1...count {
        let i = rd.nextInt()
        randomArray.append(i)
    }
    
    return randomArray
    
    
}



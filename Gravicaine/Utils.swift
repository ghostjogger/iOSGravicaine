//
//  Utils.swift
//  solo-mission
//
//  Created by Romain ROCHE on 04/07/2016.
//  Copyright © 2016 Romain ROCHE. All rights reserved.
//

import CoreGraphics

let GodMode: Bool = false
let FontName: String = "Jellee-Roman"
let HighScoreKey: String = "HighScore"
let HighScoreKeys: String = "HighScores"

struct PhysicsCategories {
    static let None:    UInt32 = 0      // 0
    static let Player:  UInt32 = 0b1    // 1
    static let Bullet:  UInt32 = 0b10   // 2
    static let Enemy:   UInt32 = 0b100  // 4
    static let Barrier: UInt32 = 0b1000 // 8
    static let Asteroid: UInt32 = 0b10000 // 16
    static let PowerUp: UInt32 = 0b100000 //32
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}



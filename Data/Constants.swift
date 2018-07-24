//
//  Constants.swift
//  Gravicaine
//
//  Created by stephen ball on 28/05/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import Foundation

let barrierHeight = 336
let barrierWidth = 800
let barrierGap = 400
let barrierVerticalSpacing = 600
let barrierHOverlap = 100
let obstacleVerticalSpeed = 1000.0
let barrierSpeedAcross = 5.0
let bseed = 1
let barrierMovementX = 80


let mineVerticalSpacing = 150


let playerBaseY = 0.2
let playerMass = 0.3
let playerPower = 100.0
let powerDecrement = 0.5
let laserMass = 5

let spawnInterval = 1.7

let impulse = 45
let thrustPower = 350
let gravity = 1.0

let shieldActivationTime = 6.0

// iphone X screen width
let maxDeviceScreenWidth = 1125
let maxDeviceScreenHeight = 2436


//option positioning
let musicX = 230.0
let musicY = 470.0
let musicLabelX = -140
let musicLabelY = 500
let doneX = 0
let doneY = -500
let gravIconX = -440
let gravIconY = 585



let GodMode: Bool = false
let FontName: String = "Jellee-Roman"
let HighScoreKey: String = "HighScore"
let HighScoreName: String = "HighScoreName"
let GlobalScoreName: String = "GlobalScoreName"


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
    static let BarrierGap: UInt32 = 0b100000000 //256
    
}



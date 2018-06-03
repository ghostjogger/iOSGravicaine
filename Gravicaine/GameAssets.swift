//
//  GameAssets.swift
//  Gravicaine
//
//  Created by Stephen Ball on 02/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

//player explosion animation variables

var playerExplosionFrames: [SKTexture] = []
let playerExplosionSound: SKAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
let playerExplosionAnimatedAtlas = SKTextureAtlas(named: "playerExplosion")


// entity explosion animation variables

var entityExplosionFrames: [SKTexture] = []
let entityExplosionSound: SKAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
let entityExplosionAnimatedAtlas = SKTextureAtlas(named: "entityExplosion")

// redexplosion animation variables

var redExplosionFrames: [SKTexture] = []
let redExplosionSound: SKAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
let redExplosionAnimatedAtlas = SKTextureAtlas(named: "redExplosion")

// asteroid explosion animation variables
// redexplosion animation variables

var asteroidExplosionFrames: [SKTexture] = []
let asteroidExplosionSound: SKAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
let asteroidExplosionAnimatedAtlas = SKTextureAtlas(named: "asteroidExplosion")

//powerup sound action
let powerUpSound: SKAction = SKAction.playSoundFileNamed("Powerup.wav", waitForCompletion: false)

// shield powerup sound actions
let shieldPowerSound: SKAction = SKAction.playSoundFileNamed("shieldSound.wav", waitForCompletion: false)
let shieldFinishSound: SKAction = SKAction.playSoundFileNamed("shieldFinish.wav", waitForCompletion: false)

//sound
let backgroundSound = SKAudioNode(fileNamed: "gameSoundtrack.mp3")

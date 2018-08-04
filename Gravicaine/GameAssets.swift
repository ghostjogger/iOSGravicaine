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


//powerup sound action
let powerUpSound: SKAction = SKAction.playSoundFileNamed("Powerup.wav", waitForCompletion: false)

// shield powerup sound actions
let shieldPowerSound: SKAction = SKAction.playSoundFileNamed("shieldSound.wav", waitForCompletion: false)
let shieldFinishSound: SKAction = SKAction.playSoundFileNamed("shieldFinish.wav", waitForCompletion: false)

//sound
let backgroundSound = SKAudioNode(fileNamed: "gameMusic.mp3")
let menuBackgroundSound = SKAudioNode(fileNamed: "Theme.mp3")

let playerZoomSound:SKAction = SKAction.playSoundFileNamed("zoom.wav", waitForCompletion: false)
let playerAppearSound:SKAction = SKAction.playSoundFileNamed("sound0.wav", waitForCompletion: false)

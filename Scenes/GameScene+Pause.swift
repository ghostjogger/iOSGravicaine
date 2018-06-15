//
//  GameScene+Pause.swift
//  Gravicaine
//
//  Created by stephen ball on 15/06/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

#if os(OSX)
import AppKit
#else
import UIKit
#endif

extension GameScene {
    // MARK: Properties
    
    /**
     The scene's `paused` property is set automatically when the
     app enters the background. Override to check if an `overlay` node is
     being presented to determine if the game should be paused.
     */
    override var isPaused: Bool {
        didSet {
           
        }
    }
    
    /// Platform specific notifications about the app becoming inactive.
    private var pauseNotificationNames: [NSNotification.Name] {
        #if os(OSX)
        return [
            .NSApplicationWillResignActive,
            .NSWindowDidMiniaturize
        ]
        #else
        return [
            NSNotification.Name.UIApplicationWillResignActive
        ]
        #endif
    }
    
    // MARK: Convenience
    
    /**
     Register for notifications about the app becoming inactive in
     order to pause the game.
     */
    func registerForPauseNotifications() {
        for notificationName in pauseNotificationNames {
            NotificationCenter.default.addObserver(self, selector: #selector(GameScene.setPausedState), name: notificationName, object: nil)
        }
    }
    
    func pauseGame() {
        //stateMachine.enter(LevelScenePauseState.self)
    }
    
    func unregisterForPauseNotifications() {
        for notificationName in pauseNotificationNames {
            NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        }
    }
}


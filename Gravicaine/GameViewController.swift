//
//  GameViewController.swift
//  Gravicaine
//
//  Created by Stephen Ball on 04/04/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit




class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        var deviceWidth =  UIScreen.main.nativeBounds.width
        var deviceHeight = UIScreen.main.nativeBounds.height


        let scene = MainMenuScene(size: CGSize(width: deviceWidth, height: deviceHeight))

        
        //configure the view
        guard let view = self.view as! SKView? else  {
            return
        }
        view.showsFPS = true
        view.showsNodeCount = true
        
        scene.scaleMode = .aspectFill
        view.presentScene(scene)

    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

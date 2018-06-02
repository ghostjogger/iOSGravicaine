//
//  StartPanelNode.swift
//  Gravicaine
//
//  Created by Stephen Ball on 23/05/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import SpriteKit

class StartPanelNode: SKSpriteNode {

    private static let FadeInTranslationY: CGFloat = 80.0
    
    let label: SKLabelNode = SKLabelNode()
    let labelVerticalSeparation = 30
    
    init(size: CGSize) {
        
        
        let scale = size.width/CGFloat(maxDeviceScreenWidth)

        label.fontSize = 80.0 * scale
        label.fontName = FontName
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "TAP TO START"
        
        var pos = CGPoint(x: size.width / 2, y: size.height * 0.66)
        label.position = pos
        
        super.init(texture: nil, color: UIColor.clear, size: size)

        self.addChild(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animate(alpha: CGFloat, yTranslation: CGFloat, completion: @escaping ()->() = {}) {
    
        let fadeIn = SKAction.fadeAlpha(to: alpha, duration: 0.2)
        let moveUpLabel = SKAction.moveTo(y: label.position.y + yTranslation, duration: 0.2)
        let groupLabel = SKAction.group([fadeIn, moveUpLabel])
        let waitLabel = SKAction.wait(forDuration: 0.1)
        
        label.run(SKAction.sequence([waitLabel, groupLabel])) {
            completion()
        }
        
    }
    
    func fadeIn(completion: @escaping ()->() = {}) {

        label.alpha = 0.0
        label.position.y -= StartPanelNode.FadeInTranslationY
        
        self.animate(alpha: 1.0, yTranslation: StartPanelNode.FadeInTranslationY, completion: completion)
        
    }
    
    func fadeOut(completion: @escaping ()->() = {}) {
        
        self.animate(alpha: 0.0, yTranslation: StartPanelNode.FadeInTranslationY) {
            self.label.position.y -= StartPanelNode.FadeInTranslationY
            completion()
        }
        
    }
    
}

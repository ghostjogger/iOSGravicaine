//
//  Alertable.swift
//  Gravicaine
//
//  Created by Stephen Ball on 04/08/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

import Foundation
import SpriteKit

protocol Alertable { }
extension Alertable where Self: SKScene {
    
    func showAlert(withTitle title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
    
    func showAlertWithSettings(withTitle title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if #available(iOS 10.0, *) {
                
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        alertController.addAction(settingsAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

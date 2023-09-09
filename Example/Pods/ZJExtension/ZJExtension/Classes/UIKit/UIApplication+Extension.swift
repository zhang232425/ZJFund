//
//  UIApplication+Extension.swift
//  Pods-ZJExtension_Example
//
//  Created by Jercan on 2022/10/28.
//

import Foundation

public extension UIApplication {
    
    func open(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                UIApplication.shared.open(url: url)
            }
        }
    }
    
    func switchRootViewController(to viewController: UIViewController?, anmated: Bool) {
        
        guard let window = delegate?.window as? UIWindow else { return }
        
        guard anmated else {
            window.rootViewController = viewController
            return
        }
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        })
        
    }
    
}

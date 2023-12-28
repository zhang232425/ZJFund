//
//  ViewController.swift
//  ZJFund
//
//  Created by 51930184@qq.com on 09/09/2023.
//  Copyright (c) 2023 51930184@qq.com. All rights reserved.
//

import UIKit
import ZJRoutableTargets

class ViewController: UITabBarController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var controllers = [UIViewController]()
        
        if let vc = ZJFundRoutableTarget.fund.viewController {
            
            vc.tabBarItem = .init(title: "Fund", image: UIImage(color: .blue, size: .init(width: 10, height: 10)), tag: 0)
            controllers.append(vc)
            
        }
        
        if let vc = ZJFundRoutableTarget.swift.viewController {
            
            vc.tabBarItem = .init(title: "Swift", image: UIImage(color: .blue, size: .init(width: 10, height: 10)), tag: 0)
            controllers.append(vc)
            
        }
        
        if let vc = ZJFundRoutableTarget.rxSwift.viewController {
            
            vc.tabBarItem = .init(title: "RxSwift", image: UIImage(color: .blue, size: .init(width: 10, height: 10)), tag: 0)
            controllers.append(vc)
            
        }
        
        if let vc = ZJFundRoutableTarget.vendors.viewController {
            
            vc.tabBarItem = .init(title: "Vendors", image: UIImage(color: .blue, size: .init(width: 10, height: 10)), tag: 0)
            controllers.append(vc)
            
        }
        
        viewControllers = controllers
        
    }

}


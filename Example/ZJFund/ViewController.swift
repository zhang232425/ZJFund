//
//  ViewController.swift
//  ZJFund
//
//  Created by 51930184@qq.com on 09/09/2023.
//  Copyright (c) 2023 51930184@qq.com. All rights reserved.
//

import UIKit
import ZJRoutableTargets

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func fundClick() {
        
        if let vc = ZJFundRoutableTarget.fund.viewController {
            present(vc, animated: true)
        }
        
    }
    

}


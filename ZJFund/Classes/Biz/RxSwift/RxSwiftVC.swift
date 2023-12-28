//
//  RxSwiftViewController.swift
//  ZJFund
//
//  Created by Jercan on 2023/11/7.
//

import UIKit

class RxSwiftVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
    }

}

private extension RxSwiftVC {
    
    func config() {
        self.navigationItem.title = "RxSwift"
    }
    
    func setupViews() {
        
    }
    
}

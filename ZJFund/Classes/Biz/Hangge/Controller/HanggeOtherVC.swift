//
//  HanggeOtherVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/2/27.
//

import UIKit

/**
 CAKeyframeAnimation
 */

class HanggeOtherVC: BaseVC {

    var square: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

}

// 沿路径运动的动画实现
private extension HanggeOtherVC {
    
    func setupViews() {

        square = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        square.backgroundColor = .orange
        square.add(to: view)
        
    }
    
}

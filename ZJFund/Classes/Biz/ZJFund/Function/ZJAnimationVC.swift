//
//  ZJAnimationVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/2/27.
//

import UIKit

// https://www.hangge.com/blog/cache/detail_1072.html

// https://blog.51cto.com/u_16124099/6338911
// https://www.hangge.com/blog/cache/detail_664.html

/**
 CABasicAnimation：
 CAKeyframeAnimation：关键帧动画
 */

class ZJAnimationVC: BaseVC {
    
    var square: UIView!

    private lazy var startBtn = UIButton(type: .system).then {
        $0.setTitle("开始", for: .normal)
    }
    
    private lazy var redView = UIView().then {
        $0.backgroundColor = .red
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }
    
}

private extension ZJAnimationVC {
    
    func setupViews() {

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: startBtn)
        
        redView.add(to: view).snp.makeConstraints {
            $0.left.equalToSuperview().inset(30)
            $0.top.equalToSuperview().inset(50)
            $0.size.equalTo(30)
        }
        
    }
    
    func bindActions() {
        
        startBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.animation1()
        }).disposed(by: disposeBag)
        
    }
    
}

/**
 UIView动画本质是对Core Animation的封装，提供简洁的动画接口。
 有两种实现方式：类方法动画，Block动画
 */

private extension ZJAnimationVC {
    
    
    func animation1() {
        
        
    }
    
}


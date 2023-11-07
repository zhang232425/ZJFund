//
//  SwiftViewController.swift
//  ZJFund
//
//  Created by Jercan on 2023/11/7.
//

import UIKit

/**
 https://juejin.cn/post/7030610828285968414
 */

class SwiftViewController: BaseViewController {
    
    private lazy var button = UIButton(type: .custom).then {
        $0.setTitle("Test", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.backgroundColor = .orange
        $0.titleLabel?.font = UIFont.bold15
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindAction()
    }
    
}

private extension SwiftViewController {
    
    func setupViews() {
        
        button.add(to: view).snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.bottom.equalToSuperview().inset(UIScreen.safeAreaBottom + 20.auto)
            $0.height.equalTo(50.auto)
        }
        
    }
    
    func bindAction() {
        
        button.rx.tap.subscribe(onNext: { [weak self] in
            self?.test()
        }).disposed(by: disposeBag)
        
    }
    
    func test() {
        
        print("点击了")
        
    }
    
}


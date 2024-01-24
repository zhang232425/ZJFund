//
//  HanggeViewVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/23.
//

import UIKit
import RxSwift
import RxCocoa

class HanggeViewVC: BaseVC {
    
    /// UILabel+Rx
    private lazy var label = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "我是一个label"
    }
    
    private lazy var testBtn = UIButton(type: .custom).then {
        $0.setTitle("Test", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }

}

private extension HanggeViewVC {
    
    func setupViews() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: testBtn)
        
        label.add(to: view).snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.test()
        }).disposed(by: disposeBag)
        
    }
    
}

private extension HanggeViewVC {
    
    func test() {
        
        let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        timer.map{ "\($0)" }.bind(to: label.rx.text).disposed(by: disposeBag)
        
    }
    
}

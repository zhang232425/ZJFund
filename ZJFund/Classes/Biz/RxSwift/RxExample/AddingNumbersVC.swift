//
//  AddingNumbersVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/15.
//

import UIKit
import RxSwift
import RxCocoa

class AddingNumbersVC: BaseVC {
    
    private lazy var number1 = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.textAlignment = .right
    }
    
    private lazy var number2 = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.textAlignment = .right
    }
    
    private lazy var number3 = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.textAlignment = .right
    }

    private lazy var addLabel = UILabel().then {
        $0.text = "+"
    }
    
    private lazy var lineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private lazy var resultLabel = UILabel().then {
        $0.textAlignment = .right
        $0.text = "0"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindData()
    }

}

private extension AddingNumbersVC {
    
    func setupViews() {
        
        number1.add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.width.equalTo(137)
            $0.centerX.equalToSuperview()
        }
        
        number2.add(to: view).snp.makeConstraints {
            $0.top.equalTo(number1.snp.bottom).offset(10.auto)
            $0.left.right.equalTo(number1)
        }
        
        number3.add(to: view).snp.makeConstraints {
            $0.top.equalTo(number2.snp.bottom).offset(10.auto)
            $0.left.right.equalTo(number2)
        }
    
        addLabel.add(to: view).snp.makeConstraints {
            $0.right.equalTo(number3.snp.left).offset(-20)
            $0.centerY.equalTo(number3)
        }
        
        lineView.add(to: view).snp.makeConstraints {
            $0.top.equalTo(number3.snp.bottom).offset(10.auto)
            $0.left.equalTo(addLabel)
            $0.right.equalTo(number3)
            $0.height.equalTo(1)
        }
        
        resultLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(10.auto)
            $0.left.right.equalTo(number3)
        }
        
    }
    
    func bindData() {
        
        /** 结合操作符
         merge：将两个及两个以上的Observable合并
         zip：合并多个Observable，等一一对应再发出
         combineLatest：合并多个Observable，当任意一个 Observable 有新的事件发出时，它会将每个 Observable 序列的最新的一个事件元素进行合并
         */
        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) {
            value1, value2, value3 -> Int in
            return (Int(value1) ?? 0) + (Int(value2) ?? 0) + (Int(value3) ?? 0)
        }
        .map { $0.description }
        .bind(to: resultLabel.rx.text)
        .disposed(by: disposeBag)
        
        
    }
    
}



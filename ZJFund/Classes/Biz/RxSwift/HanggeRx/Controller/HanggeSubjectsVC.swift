//
//  HanggeSubjectsVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/19.
//

import UIKit
import RxCocoa
import RxSwift

class HanggeSubjectsVC: BaseVC {
    
    private lazy var testBtn = UIButton(type: .custom).then {
        $0.setTitle("Test", for: .normal)
        $0.setTitleColor(UIColor.blue, for: .normal)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.bold16
        $0.text = "Subjects：\n1、PublisSubject\n2、BehaviorSuject\n3、ReplaySubject\n4、BehaviorRelay"
    }
    
    private lazy var desLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .red
        $0.text = "有时候我们Observable能够动态的发出一些event，这就需要Subjects\n 常用方法：\nonNext(:)\nonErroe(:)\nonCompleted"
    }
    
    private lazy var label = UILabel().then {
        $0.text = "我是个label"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }

}

private extension HanggeSubjectsVC {
    
    func setupViews() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: testBtn)
        
        titleLabel.add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        desLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.right.equalTo(titleLabel)
        }
        
        label.add(to: view).snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.behaviorRelay()
        }).disposed(by: disposeBag)
        
    }
    
}

private extension HanggeSubjectsVC {
    
    /// 一、PublishSubject：不需要初始值，订阅之后发出去的event，能监听到
    func publishSubject() {
        
        let subject = PublishSubject<String>()
        
        subject.onNext("A")
        
        subject.subscribe(onNext: { element in
            print("第一次订阅：", element)
        }, onCompleted: {
            print("第一次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        subject.onNext("B")
        
        subject.subscribe(onNext: { element in
            print("第二次订阅：", element)
        }, onCompleted: {
            print("第二次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        
    }
    
    /// 二、BehaviorSubject：需要一个初始化默认值，每个订阅者都会收到上一次发送的event（没发送过就收到默认event），其他和PublishSubject一样
    func behaviorSubject() {
        
        let subject = BehaviorSubject<Int>(value: 111)
        
        subject.subscribe(onNext: { element in
            print("第一次订阅：", element)
        }, onCompleted: {
            print("第一次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        subject.onNext(222)
        
        subject.subscribe(onNext: { element in
            print("第二次订阅：", element)
        }, onCompleted: {
            print("第二次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
    }
    
    /// 三、ReplaySubject：bufferSize缓存数
    func replaySubject() {
        
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")
        
        subject.subscribe(onNext: { element in
            print("第一次订阅：", element)
        }, onCompleted: {
            print("第一次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        subject.onNext("444")
        
        subject.subscribe(onNext: { element in
            print("第二次订阅：", element)
        }, onCompleted: {
            print("第二次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
    }
    
    /// 四、BehaviorRelay：本质是对BehaviorSubject的封装，value属性，accept()方法
    func behaviorRelay() {
        
        /*
        let subject = BehaviorRelay(value: "111")
        
        subject.accept("222")
        
        subject.subscribe(onNext: { element in
            print("第一次订阅：", element)
        }).disposed(by: disposeBag)
        
        subject.accept("333")
        
        subject.subscribe(onNext: { element in
            print("第二次订阅：", element)
        }).disposed(by: disposeBag)
        */
        
        let subject = BehaviorRelay<[String]>(value: ["1"])
        
        subject.accept(subject.value + ["2", "3"])
        
        subject.subscribe(onNext: { element in
            print("订阅：", element)
        }).disposed(by: disposeBag)
        
        subject.accept(subject.value + ["4", "5", "6"])
        
        
    }

    
}

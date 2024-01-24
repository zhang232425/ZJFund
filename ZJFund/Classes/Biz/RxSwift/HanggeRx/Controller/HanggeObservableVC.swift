//
//  HanggeObservableVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/18.
//

import UIKit
import RxSwift
import RxCocoa

class HanggeObservableVC: BaseVC {
    
    private lazy var testBtn = UIButton(type: .custom).then {
        $0.setTitle("Test", for: .normal)
        $0.setTitleColor(UIColor.blue, for: .normal)
    }
    
    private lazy var desLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.bold16
        $0.text = "RxSwift的本质：\n1.创建信号\n2.订阅信号\n3.发送信号\n4.销毁"
    }
    
    private lazy var subLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .red
        $0.font = UIFont.regular15
        $0.text = "一、可观察序列：Observable\n二、订阅者（观察者）：Observer\n三、可观察序列被订阅者订阅"
    }
    
    private lazy var label = UILabel().then {
        $0.text = "当前索引：0"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }

}

private extension HanggeObservableVC {
    
    func setupViews() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: testBtn)
        
        desLabel.add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        subLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(desLabel.snp.bottom).offset(20)
            $0.left.right.equalTo(desLabel)
        }
        
        label.add(to: view).snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.observable2()
        }).disposed(by: disposeBag)
        
    }
    
}

private extension HanggeObservableVC {
    
    /// AnyObserver：可以描述任意一种订阅者
    /// 1、配合subscribe方法使用
    /// 2、配合bildTo方法使用
    
    func test1() {
        
        // 1.创建可观察序列
        let observable = Observable.of("A", "B", "C")
        
        // 2.创建观察者
        let observer = AnyObserver<String> { event in
            switch event {
            case .next(let data):
                print(data)
            case .completed:
                print("completed")
            case .error(let error):
                print(error)
            }
        }
        
        // 3.序列被订阅
        observable.subscribe(observer).disposed(by: disposeBag)
        
    }
    
    func test2() {
        
        // 1.创建可观察序列
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        // 2.创建订阅者
        let observer = AnyObserver<String> { [weak self] event in
            switch event {
            case .next(let text):
                self?.label.text = text
            default:
                break
            }
        }
        
        // 3.序列被订阅
        observable.map { "当前索引：\($0 + 1)" }.bind(to: observer).disposed(by: disposeBag)
        
    }
    
}

private extension HanggeObservableVC {
    
    /// 1. Observable<Any>.create { ... } 创建序列
    func observable1() {
        
        // 创建
        let observable = Observable<Any>.create { observer -> Disposable in
            observer.onNext("我是一条消息")
            return Disposables.create()
        }
        
        // 订阅
        observable.subscribe(onNext: { val in
            print("onNext：\(val)")
        }).disposed(by: disposeBag)
        
    }
    
    /** 其他创建可观察序列的方法
     .just：传入一个默认值
     .of：可多个类型一样的数据
     .from：传入数组
     .empty()：创建一个空内容的序列
     */
    
    func observable2() {
            
        // MARK: - .just 传入一个默认值
        
        /*
        let observable = Observable<[String]>.just(["A", "C"])
        
        let observer = AnyObserver<[String]> { event in
            switch event {
            case .next(let data):
                print("data ==== \(data)")
            case .completed:
                print("completd")
            case .error(let error):
                print("error ==== \(error)")
            }
        }
        
        observable.subscribe(observer).disposed(by: disposeBag)
         */
        
        // MARK: - .of ：可多个类型相同的参数
        
        /*
        let observable = Observable.of(["1"], ["2"], ["3"])
        
        let observer = AnyObserver<[String]> { event in
            switch event {
            case .next(let data):
                print("data ==== \(data)")
            case .completed:
                print("completd")
            case .error(let error):
                print("error ==== \(error)")
            }
        }
        
        observable.subscribe(observer).disposed(by: disposeBag)
         */
        
        
        // MARK: - .from：传入数组参数
        
        /*
        let _ = Observable.from(["1", 2, "3", 4]).subscribe { event in
            switch event {
            case .next(let data):
                print("data ==== \(data)")
            case .completed:
                print("completd")
            case .error(let error):
                print("error ==== \(error)")
            }
        }
        
        let _ = Observable.empty().subscribe(onNext: {
            print("data ==== ")
        }, onError: { error in
            print("error ====")
        }, onCompleted: {
            print("onCompleted")
        }, onDisposed: {
            print("onDisposed")
        })
        
        let _ = Observable<Int>.timer(.seconds(3), period: .seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print("====== \($0)")
            }).disposed(by: disposeBag)
         */
        
        /*
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable.subscribe { event in
            print(event)
        }
        */
        
        /*
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        let observer = AnyObserver<Int> { [weak self] event in
            switch event {
            case .next(let data):
                self?.label.text = "\(data)"
            default:
                break
            }
        }
        
        observable.subscribe(observer).disposed(by: disposeBag)
        */
        
        /*
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        observable.map{ "当前索引：\($0 + 1)" }.bind(to: label.rx.text).disposed(by: disposeBag)
         */
        
        
        let observable = Observable.range(start: 1, count: 10)
        
        let observer = AnyObserver<Int> { event in
            switch event {
            case .next(let data):
                print(data)
            case .error(let error):
                print(error)
            case .completed:
                print("completd")
            }
        }
        
        observable.subscribe(observer).disposed(by: disposeBag)
        
    }
        
}

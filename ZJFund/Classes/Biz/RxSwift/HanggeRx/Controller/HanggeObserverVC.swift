//
//  HanggeObserverVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/19.
//

import UIKit
import RxSwift
import RxCocoa

class HanggeObserverVC: BaseVC {
    
    private lazy var testBtn = UIButton(type: .custom).then {
        $0.setTitle("Test", for: .normal)
        $0.setTitleColor(UIColor.blue, for: .normal)
    }
    
    private lazy var desLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.bold16
        $0.text = "Observer：相应序列，处理事件"
    }
    
    private lazy var subLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .red
        $0.font = UIFont.regular15
        $0.text = "一、创建方式\n 1）自己在subscrible、bind方法中创建 \n 2）使用AnyObserver创建订阅者\n 3）使用Binder创建订阅者"
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

private extension HanggeObserverVC {
    
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
            self?.observer4()
        }).disposed(by: disposeBag)
        
    }
    
}

private extension HanggeObserverVC {
    
    /// 一、在subscrible、bind方法中创建订阅者
    func observer1() {
        
        // 1. 在subscribe中创建
        /*
        let observable = Observable<Int>.of(1, 22, 333, 4444)
        
        observable.subscribe { event in
            switch event {
            case .next(let element):
                print(element)
            case .completed:
                print("completed")
            case .error(let error):
                print(error)
            }
        }.disposed(by: disposeBag)
         */
        
        // 2. 在bind方法中创建
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        observable.map{ "当前索引：\($0 + 1)" }.bind { [weak self] element in
            self?.label.text = element
        }.disposed(by: disposeBag)
        
    }
    
    /// 二、使用AnyObserver创建订阅者 ｜ 配合bind(to)
    func observer2() {
        
        /*
        let observable = Observable<Int>.of(1, 22, 333, 4444).share(replay: 1)
        
        let observer = AnyObserver<Int> { event in
            switch event {
            case .next(let element):
                print(element)
            case .completed:
                print("completd")
            case .error(let error):
                print(error)
            }
        }
        
        observable.subscribe(observer).disposed(by: disposeBag)
        observable.bind(to: observer).disposed(by: disposeBag)
         */
        
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        let observer = AnyObserver<String> { [weak self] event  in
            switch event {
            case .next(let element):
                self?.label.text = element
            default:
                break
            }
        }
        
        observable.map{ "当前索引：\($0 + 1)" }.bind(to: observer).disposed(by: disposeBag)
        
    }
    
    /// 三、使用Binder创建，Binder只处理onNext事件，在指定的scheduler上执行，默认是MainScheduler
    func observer3() {
        
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        let observer = Binder(label) { label, element in
            label.text = element
        }
        
        observable.map{ "当前索引：\($0)" }.bind(to: observer).disposed(by: disposeBag)
        
    }
    
    /// 四、对UI类进行扩展，新增一个fontSize可绑定属性
    func observer4() {
        
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
//        observable.map{ CGFloat($0) }.bind(to: label.fontSize).disposed(by: disposeBag)
        
        observable.map{ CGFloat($0) }.bind(to: label.rx.fontSize).disposed(by: disposeBag)
        
    }
    
}

/*
fileprivate extension UILabel {
    
    var fontSize: Binder<CGFloat> {
        return Binder(self) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
}
*/

fileprivate extension Reactive where Base: UILabel {
    
    var fontSize: Binder<CGFloat> {
        return Binder(self.base) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
}

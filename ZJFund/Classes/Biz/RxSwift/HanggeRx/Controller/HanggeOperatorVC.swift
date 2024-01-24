//
//  HanggeOperatorVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/22.
//

import UIKit
import RxCocoa
import RxSwift

class HanggeOperatorVC: BaseVC {
    
    private var count = 1
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont.bold16
        $0.textColor = .red
        $0.text = "Operator操作符"
    }
    
    private lazy var desLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "变换操作符：buffer、map、flatMap、scan等\n过滤操作符：filter、take、skip等\n条件和布尔操作符：amb、takeWhile、skipWhile等\n结合操作符：startWith、merge、zip等\n连接操作符：connect、publish、replay、multicast\n其他操作符：delay、materialize、timeout"
    }
    
    private lazy var testBtn = UIButton(type: .custom).then {
        $0.setTitle("Test", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
    }
    
    private lazy var textField = UITextField().then {
        $0.borderStyle = .roundedRect
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }
    
}

private extension HanggeOperatorVC {
    
    func setupViews() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: testBtn)
        
        titleLabel.add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(15)
        }
        
        desLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        textField.add(to: view).snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(45)
            $0.bottom.equalToSuperview().inset(77)
        }
        
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.retry()
        }).disposed(by: disposeBag)
        
        textField.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
    }
    
}

/// 变换操作：Transforming Observables
private extension HanggeOperatorVC {
    
    /// 1.buffer、window
    func buffer() {
        
        /**
         buffer：是周期性将缓存的元素集合发送出来
         window：是周期性将元素集合以Observable形式发送出来
         */
        
        /// 1.指定的时间，或者指定个数发送
        let subject = PublishSubject<String>()
        
        subject.window(timeSpan: .seconds(2), count: 2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { element in
                print(element)
            }).disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
    }
    
    /// 2.map、flatMap、flatMapLatest、flatMapFirst、concatMap
    func map() {
        
//        Observable.of(1, 2, 3).map { $0 * 2 }.subscribe(onNext: { element in
//            print(element)
//        }).disposed(by: disposeBag)
        
    }
    
    /// 3. scan、groupBy
    func scan() {
        
        /*
        Observable.of(1, 2, 3, 4, 5)
            .scan(0) { acum, element in
                acum + element
            }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
         */
        
        
        /**
         //将奇数偶数分成两组
         Observable<Int>.of(0, 1, 2, 3, 4, 5)
             .groupBy(keySelector: { (element) -> String in
                 return element % 2 == 0 ? "偶数" : "基数"
             })
             .subscribe { (event) in
                 switch event {
                 case .next(let group):
                     group.asObservable().subscribe({ (event) in
                         print("key：\(group.key)    event：\(event)")
                     })
                     .disposed(by: disposeBag)
                 default:
                     print("")
                 }
             }
         .disposed(by: disposeBag)
         */
        
        Observable.of(0, 1, 2, 3, 4, 5)
            .groupBy(keySelector: { (element) -> String in
                return element % 2 == 0 ? "偶数" : "奇数"
            })
            .subscribe { event in
                switch event {
                case .next(let group):
                    group.asObservable().subscribe { event in
                        print("key：\(group.key)  event：\(event)")
                    }.disposed(by: self.disposeBag)
                default:
                    print("")
                }
            }
            .disposed(by: disposeBag)
        
        
    }
    
    
}

/// 过滤操作：Filtering Observables
private extension HanggeOperatorVC {
    
    // filter：过滤掉不满足条件的事件
    func filter() {
    
        Observable.of(2, 30, 22, 5, 60, 3, 40, 9)
            .filter { $0 > 10 }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
    }
    
    // distinctUntilChanged：过滤掉连续重复的事件
    func distinctUntilChanged() {
    
        Observable.of(1, 2, 3, 1, 1, 4)
            .distinctUntilChanged()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
    }
    
    // single：单个事件，只发出满足条件的第一个事件，如果有多个事件满足发出第一个满足事件，再发error事件，如果没有则发error事件
    func single() {
    
        Observable.of(1, 2, 3, 4, 5)
            .single { $0 > 2 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        Observable.of("A", "B", "C", "D")
            .single()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
    }
    
    // elementAt：该操作符只处理指定位置的事件
    func elementAt() {
        
        Observable.of(1, 2, 3, 4, 5)
            .element(at: 10)
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
    }
    
    // ignoreElements：忽略事件，只想知道什么时候终止
    func ignoreElements() {
        
//        Observable.of(1, 2, 3, 4, 5)
//            .ignoreElements()
//            .subscribe(onNext: { print($0 ?? 0) })
//            .disposed(by: disposeBag)
        
    }
    
    // take 处理指定位置前的事件
    func take() {
        
        Observable.of(1, 2, 3)
            .take(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
    }
    
    // takeLast 处理指定后的事件
    func takeLast() {
        
        Observable.of(1, 2, 3, 4, 5)
            .takeLast(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
    }
    
    // takeWhile 第一个不满足条件值出现时，便自动停止
    func takeWhile() {
        
        Observable.of(1, 2, 3, 4, 5, 6)
            .take(while: { $0 < 4 })
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
    }
    
    // takeUntil：当notifier发出值或者completed通知，那么源Observable便自动完成
    func takeUntil() {
        
        let source = PublishSubject<String>()
        let notifier = PublishSubject<String>()
        
        source.take(until: notifier)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        source.onNext("1")
        source.onNext("2")
        source.onNext("3")
        source.onNext("4")
        
        notifier.onNext("5")
        
        source.onNext("6")
        source.onNext("7")
        source.onNext("8")
        
    }
    
    // skip 跳过指定位数的事件
    func skip() {
        
        Observable.of(1, 2, 3, 4, 5)
            .skip(3)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
    }
    
    // skipWhile：跳过满足条件的事件，直到遇到不满足条件的事件，终止跳过
    func skipWhile() {
        
        Observable.of(1, 2, 3, 4, 5, 6)
            .skip(while: { $0 < 4 })
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    // skipUntil：一直跳过，直到notifier发出值或者completed为止
    func skipUntil() {
        
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<Int>()
        
        source
            .skip(until: notifier)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        source.onNext(1)
        source.onNext(2)
        source.onNext(3)
        source.onNext(4)
        source.onNext(5)
        
        notifier.onNext(0)
        
        source.onNext(6)
        source.onNext(7)
        source.onNext(8)
        
        notifier.onNext(0)
        
        source.onNext(9)
        
    }
    
    // debounce：间隔多少时间
    func debounce() {
        

    }
    
}

/// 条件和布尔操作符（Conditional and Boolean Operators）
private extension HanggeOperatorVC {
    
    /// 多个Observable，只发送第一个发出元素的Observable，多个Observable的数据类型必须保持一致
    func amb() {
        
    
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        let subject3 = PublishSubject<String>()
        
        subject1
            .amb(subject2)
            .amb(subject3)
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        subject2.onNext("A")
        subject1.onNext("1")
        subject3.onNext("1A")
        
        subject1.onNext("2")
        subject2.onNext("B")
        subject3.onNext("2B")
        
        subject1.onNext("3")
        subject2.onNext("C")
        subject3.onNext("3C")
        
    }
    
    ///
    
}

/// 结合操作（Combining Observables）
private extension HanggeOperatorVC {
    
    /// startWith：在序列开始之前插入一个元素
    func startWith() {
        
        Observable.of(2, 3, 4, 5)
            .startWith(1)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
    }
    
    /// merge：多个observable合并成一个
    func merge() {
        
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        
        Observable.merge(subject1, subject2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext(20)
        subject1.onNext(40)
        subject1.onNext(60)
        
        subject2.onNext(1)
        subject1.onNext(80)
        subject1.onNext(100)
        subject2.onNext(1)
        
    }
    
    /// zip：合并多个observable，等到一一对应凑齐之后再合并，主要用于整合网络请求上
    /// combineLatest：合并多个observable，只要有新的事件发出，去所有observable最新的值合并发出
    func zip() {
        
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
        
        Observable.combineLatest(subject1, subject2) {
            "\($0)\($1)"
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
        subject1.onNext(1)
        subject2.onNext("A")
        subject1.onNext(2)
        subject2.onNext("B")
        subject2.onNext("C")
        subject2.onNext("D")
        subject1.onNext(3)
        subject1.onNext(4)
        subject1.onNext(5)
        
    }
    
    /// withLatestFrom：当第一个序列发出事件时，就从第二个序列里面取最新的值发出
    func withLatestFrom() {
    
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        subject1.withLatestFrom(subject2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject2.onNext("1")
        subject1.onNext("A")
        subject1.onNext("B")
        subject2.onNext("2")
        subject1.onNext("C")
        subject1.onNext("D")
        
    }
    
    /// switchLatest：可以对事件流进行转换

}

/// 算数&聚合操作符：toArray、reduce、concat
private extension HanggeOperatorVC {
    
    func toArray() {
        
        Observable.of(1, 2, 3)
            .toArray()
            .subscribe { event in
                switch event {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    /// reduce：传入初始值和一个操作符，累计就算返回一个结果
    func reduce() {
        
        Observable.of(1, 2, 3, 4, 5)
            .reduce(0, accumulator: +)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
    }
    
    /// concat：合并多个，等前面的observable执行completed事件之后，再执行后面的，串行
    func concat() {
        
        
        
    }
    
}

/// 连接操作符 & 其他操作符：connect、publish、replay、multicast
private extension HanggeOperatorVC {
    
    /**
     可连接的序列（Connectable Observable）
     (1) 可连接的序列和一般序列不同在于：有订阅时不会立刻开始发送事件消息，只有当调用 connect() 之后才会开始发送值
     (2) 可连接的序列可以让订阅者订阅后，才开始发送事件消息，从而保证我们想要的所有订阅者都能接受到事件消息
     */
    
    /// share(relay:) 该操作符将使得观察者共享源 Observable，并且缓存最新的 n 个元素，将这些元素直接发送给新的观察者
    
    /// delay：延时
    func delay() {
        
        Observable.of(1, 2, 3, 4, 5)
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
    }
    
    /// timeout：超时
    
}

/// 错误处理 Error Handling Operators
private extension HanggeOperatorVC {
    
    /// catchErrorJustReturn：当遇到 error 事件的时候，就返回指定的值，然后结束
    func catchErrorJustReturn() {
        
        let subject = PublishSubject<String>()
        
        subject
            .catchAndReturn("错误")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onError(OperatorError.A)
        
        subject.onNext("d")
        subject.onNext("e")
        
    }
    
    /// catchError：可以捕获error，同时返回另外一个Observable序列进行订阅（切换到新的序列）
    func catchError() {
        
        let subject = PublishSubject<String>()
        let observable = Observable.of("1", "2", "3")

        subject.catch {
            print("Error：", $0)
            return observable
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        subject.onError(OperatorError.A)
        subject.onNext("d")
        
    }
    
    /// retry：重试
    func retry() {
                
        let observable = Observable<String>.create { observer in
            observer.onNext("a")
            observer.onNext("b")
            if self.count == 1 {
                observer.onError(OperatorError.A)
                print("Error encountered")
                self.count += 1
            }
            
            observer.onNext("c")
            observer.onNext("d")
            
            observer.onError(OperatorError.A)
            
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        observable
            .retry(3) // 重实两次
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        
    }
    
}

fileprivate enum OperatorError: Error {
    case A
    case B
}

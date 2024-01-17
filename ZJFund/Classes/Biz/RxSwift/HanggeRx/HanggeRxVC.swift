//
//  HanggeRxVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/8.
//

import UIKit
import RxSwift
import RxCocoa

/*

class HanggeRxVC: BaseVC {
    
    private let viewModel = MusicListVM()
    
    private lazy var tableView = UITableView().then {
        $0.registerCell(UITableViewCell.self)
//        $0.dataSource = self
//        $0.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
}

private extension HanggeRxVC {
    
    func setupViews() {
        
        tableView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func bindViewModel() {
        
        // 将数据绑定到tableView上
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "UITableViewCell")) { _, music, cell in
            cell.textLabel?.text = music.name
            cell.detailTextLabel?.text = music.singer
        }.disposed(by: disposeBag)
        
        // 点击响应
        tableView.rx.modelSelected(Music.self).subscribe(onNext: { music in
            print("你选中的歌曲信息【\(music)】")
        }).disposed(by: disposeBag)
        
    }
    
    
}

/*
extension HanggeRxVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
        let music = viewModel.data[indexPath.row]
        cell.textLabel?.text = music.name
        cell.detailTextLabel?.text = music.singer
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("你选中的歌曲信息【\(viewModel.data[indexPath.row])】")
    }
    
}
 */

fileprivate struct Music {

    /// 歌名
    let name: String
    /// 演唱者
    let singer: String
    
    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
    
}

extension Music: CustomStringConvertible {
    
    var description: String {
        return "name：\(name) singer：\(singer)"
    }
    
}

fileprivate struct MusicListVM {
    
    /*
    let data = [
        Music(name: "海阔天空", singer: "黄家驹"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "心如刀割", singer: "张学友"),
        Music(name: "在木星", singer: "朴树")
    ]
     */
    
    let data = Observable.just([
        Music(name: "海阔天空", singer: "黄家驹"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "心如刀割", singer: "张学友"),
        Music(name: "在木星", singer: "朴树")
    ])
    
}
*/

/**
 Observable<T>：可观察序列
 Observer：订阅者（观察者）
 Event事件：
 case next(Element)
 case error(Swift.Error)
 case completed
 */

class HanggeRxVC: BaseVC {
    
    private lazy var label = UILabel().then {
        $0.text = "当前索引：0"
    }
    
    private lazy var button = UIButton(type: .system).then {
        $0.setTitle("Test", for: .normal)
    }
    
    private lazy var cocoaBtn = UIButton(type: .system).then {
        $0.setTitle("HanggeCocoaRx", for: .normal)
    }
    
    private lazy var exampleBtn = UIButton(type: .system).then {
        $0.setTitle("HanggeExample", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }
    
}

private extension HanggeRxVC {
    
    func setupViews() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(testClick))
        
        label.add(to: view).snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        button.add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.centerX.equalToSuperview()
        }
        
        cocoaBtn.add(to: view).snp.makeConstraints {
            $0.top.equalTo(button.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        exampleBtn.add(to: view).snp.makeConstraints {
            $0.top.equalTo(cocoaBtn.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    func bindActions() {
        
        cocoaBtn.rx.tap.subscribe(on: MainScheduler.instance).subscribe { [weak self] _ in
            let vc = HanggeCocoaRxVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        exampleBtn.rx.tap.subscribe(on: MainScheduler.instance).subscribe { [weak self] _ in
            let vc = HanggeExampleVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
    
    @objc func testClick() {
        
//        share1()
        
        let vc = HanggeListVC()
        self.navigationController?.pushViewController(vc, animated: true)
        

    }
    
}

/** 一
 Observable的介绍，创建可观察序列
 */
private extension HanggeRxVC {
    
    /// 1.create创建
    func create1() {
        
        /// 1.创建序列
        let observable = Observable<String>.create { observe -> Disposable in
            /// 产生一个事件
            observe.onNext("1")
            /// 产生一个事件
            observe.onNext("2")
            /// 产生一个错误事件
            observe.onError(HanggeError.a)
            /// 产生一个完成事件
            observe.onCompleted()
            /// 返回一个资源管理对象
            return Disposables.create()
        }
        
        /// 订阅序列
        observable.subscribe(on: MainScheduler.instance).subscribe(onNext: { element in
            print(element)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("订阅完成")
        }).disposed(by: DisposeBag())
        
    }
    
    /// 2.just创建
    func create2() {
        
        /**
         1.传入一个初始值
         2.指定类型Observable<Int>
         */
        
//        let observable = Observable.just(1)
        let observable = Observable<String>.just("张云峰")
        
        observable.subscribe(onNext: {
            print($0)
        }).disposed(by: DisposeBag())
        
    }
    
    /// 3.of方法
    func create3() {
        
        /**
         类型必须相同
         */
//        let observable = Observable.of("a", "b", "2")
        
        let observable = Observable.of([1, 2], [3, 4], [5, "6"])
        
        observable.subscribe(onNext: { element in
            print(element)
        }).disposed(by: DisposeBag())
        
    }
    
    /// 4.from方法
    func create4() {
        
        /**
         1.传入一个数组
         2.输出和of()效果一样
         */
        
        let observable = Observable.from(["a", "b", 1])
        
        observable.subscribe(onNext: { element in
            print(element)
        }).disposed(by: DisposeBag())
        
    }
    
    /// 5.empty方法
    func create5() {
        
        /// 该方法创建一个空内容的observable序列
        let observable = Observable<Int>.empty()
        
        observable.subscribe(onNext: { element in
            print(element)
        }).disposed(by: DisposeBag())
        
    }
    
    /// 6.range方法
    func create6() {
        
        let observable = Observable.range(start: 1, count: 5)
        
        observable.subscribe(onNext: {
            print($0)
        }).disposed(by: DisposeBag())
        
    }
    
    /// 7.repeatElement方法
    func create7() {
        
        /// 该方法创建一个可以无限发出给定元素的 Event 的 Observable 序列 (永不终止)
        /*
        let observable = Observable.repeatElement(1)
        
        observable.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
         */
        
    }
    
    /// 8.generate方法创建
    func create8() {
        
        let observable = Observable.generate(initialState: 1, condition: { $0 <= 10 }, iterate: { $0 + 2 })
        
        observable.subscribe(onNext: {
            print($0)
        }).disposed(by: DisposeBag())
        
    }
    
    /// 9.create方法创建
    func create9() {
        
        /// 该方法接受一个 block 形式的参数，任务是对每一个过来的订阅进行处理
        /// 这个block有一个回调参数observer，observer就是这个Obervable对象的订阅者
        let observable = Observable<String>.create { observer in
            observer.onNext("zhangdachun")
            observer.onCompleted()
            return Disposables.create()
        }
        
        observable.subscribe(onNext: {
            print($0)
        }).disposed(by: DisposeBag())
        
    }
    
    /// 10.deferred方法（延迟）
    func create10() {
        
        // 用于标记奇数还是偶数
        var isOld = true
        
        let factory: Observable<Int> = Observable.deferred {
            
            // 让每次执行这个block时候都会让奇、偶数进行交替
            isOld = !isOld
            
            // 根据isOld参数，决定创建并返回的是奇数Observable、还是偶数Observable
            if isOld {
                return Observable.of(1, 3, 5, 7, 9)
            } else {
                return Observable.of(2, 4, 6, 8, 10)
            }
            
        }
        
        // 第一次订阅测试
        factory.subscribe(onNext: { event in
            print("\(isOld)", event)
        }).disposed(by: DisposeBag())
        
        // 第二次订阅测试
        factory.subscribe(onNext: { event in
            print("\(isOld)", event)
        }).disposed(by: DisposeBag())
        
    }
    
    /// 11.interval方法创建
    func create11() {
        
        /**
         interval：间隔时间一直发送索引数字，一直发下去
         */
        
        let observable = Observable<Int>.interval(.seconds(2), scheduler: MainScheduler.instance)
        
        observable.subscribe(onNext: {
            print("\($0)")
        }).disposed(by: DisposeBag())
        
    }
    
    /// 12.timer方法创建
    func create12() {
        
        /**
         timer
         1. 第一种用法，创建Observable序列在经过设定的一段时间后，产生唯一的一个元素
         2. 第二种方法，创建Observable序列在经过设定的一段时间后，每隔一段时间产生一个元素
         */
        

//        let observable = Observable<Int>.timer(.seconds(3), scheduler: MainScheduler.instance)
        
        let observable = Observable<Int>.timer(.seconds(2), period: .seconds(1), scheduler: MainScheduler.instance)
        
        observable.subscribe(onNext: {
            print("\($0)")
        }).disposed(by: DisposeBag())
        
        
    }
    
    
}

/** 二
 Observable的订阅、事件监听、订阅销毁
 */
private extension HanggeRxVC {
    
    /// 订阅
    func subscribe1() {
        
        /**
         订阅：
         1、subscribe()
         2、subscribe(onNext: , onError: , onCompleted: , onDisposed:)
         */
        
        let observable = Observable.of("A", "B", "C")
        
//        observable.subscribe { event in
//            print(event)
//        }.disposed(by: DisposeBag())
        
//        observable.subscribe { event in
//            print(event.element)
//        }.disposed(by: DisposeBag())
        
        observable.subscribe(onNext: { element in
            print(element)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("onCompleted")
        }, onDisposed: {
            print("onDisposed")
        }).disposed(by: DisposeBag())
        
    }
    
    /// 生命周期的监听
    func subscribe2() {
        
       /**
        doOn介绍：
        1、可以使用 doOn 方法来监听事件的生命周期，它会在每一次事件发送前调用
        2、同时它和 subscribe 一样，可以通过不同的 block 回调处理不同类型的 event
        */
    
        let observable = Observable.of("a", "b", "c")
        
        observable.do(onNext: { element in
            print("Intercepted Next：", element)
        }, onError: { error in
            print("Intercepted Error：", error)
        }, onCompleted: {
            print("Intercepted Completed")
        }, onDispose: {
            print("Intercepted Dispose")
        }).subscribe(onNext: { element in
            print(element)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        }).disposed(by: DisposeBag())
        
    }
    
    /**
     let observable = Observable.of("A", "B", "C")
              
     //使用subscription常量存储这个订阅方法
     let subscription = observable.subscribe { event in
         print(event)
     }
              
     //调用这个订阅的dispose()方法
     subscription.dispose()
     */
    
    /// 销毁Dispose
    func dispose1() {
        
        let observable = Observable.of("a", "b", "c")
        
        // 使用subscription常量存储这个订阅方法
        let subscription = observable.subscribe { event in
            print(event)
        }
        
        // 调用Dispose
        subscription.dispose()
                
    }
    
}

/** 三
 订阅者、观察者 AnyObserver、Binder
 */
private extension HanggeRxVC {
    
    /**
     在subscribe方法中创建订阅者
     */
    func observer1() {
        
        // 1.在subscribe里面创建
        let observable = Observable.of("A", "B", "C")
        
        observable.subscribe(onNext: { element in
            print(element)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("completed")
        }).disposed(by: DisposeBag())
        
        
    }
    
    /**
     在bind在创建订阅者
     */
    func observer2() {
        
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        observable.map { "当前索引：\($0)" }.bind { [weak self] in
            self?.label.text = $0
        }.disposed(by: disposeBag)
        
    }
    
    /**
     使用AnyObserver创建订阅者
     AnyObserver可以描述任意一种订阅者
     */
    func observer3() {
        
        // 1.创建可观察序列
        let observable = Observable.of("1", "2", "3")
        
        // 2.创建订阅者
        let observer: AnyObserver<String> = AnyObserver { event in
            switch event {
            case .next(let element):
                print(element)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
        
        // 3.订阅
        observable.subscribe(observer).disposed(by: disposeBag)
        
    }
    
    /** 配合 bindTo 方法使用
     配合 bindTo 方法使用
     */
    func observer4() {
    
        // 1.创建可观察序列
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        // 2.创建观察者
        let observer: AnyObserver<String> = AnyObserver { [weak self] event in
            switch event {
            case .next(let text):
                self?.label.text = text
            default:
                break
            }
        }
        
        // 3.订阅
        observable.map { "当前索引：\($0)" }.bind(to: observer).disposed(by: disposeBag)
        
    }
    
    /**
     4.使用 Binder 创建观察者
     1）相比较 AnyObserver 的大而全，Binder 更专注于特定的场景。Binder 主要有以下两个特征：
     1.1 不会处理错误事件, 确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
     1.2 一单产生错误事件，在调试环境下将执行 fatelError，在发布环境下将打印错误信息
     */
    
    func observer5() {
        
        // 1.创建序列
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        // 2.创建观察者
        let observer: Binder<String> = Binder(label) { (numLabel, text) in
            numLabel.text = text
        }
        
        // 3.订阅
        observable.map { "当前索引：\($0)" }.bind(to: observer).disposed(by: disposeBag)
        
    }
    
    /**
     Binder在RxCocoa中的应用
     其实在 RxCocoa 中对许多 UI 控件进行了扩展，利用 Binder 将控件的属性编程观察者（订阅者）, 比如 UIControl+Rx 中的 isEnabled 属性就是一个 observer
     */
    
    func observer6() {
        
        // 1.创建序列
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        // 2.订阅
        observable.map { $0 % 2 == 0 }.bind(to: button.rx.isEnabled).disposed(by: disposeBag)
        
    }
    
    
}

/** 四
 自定义可绑定属性
 */
private extension HanggeRxVC {
    
    /**
     需求：对UILabel进行扩展，增加一个fontSize可绑定属性
     */
    
    /**
     方案一：对UILabel类进行扩展
     */
    
    /**
     备注： text 和 attributedText
     */
    
    func binder1() {
        
        // 1.创建序列
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        // 2.序列被订阅（label.fontSize是扩展的Binder观察者）
//        observable.map { CGFloat($0) }.bind(to: label.fontSize).disposed(by: disposeBag)
        
        observable.map { CGFloat($0) }.bind(to: label.rx.fontSize).disposed(by: disposeBag)
        
    }
    
    
}

/** 五
 Subjects、Variables 简介
 当我们创建一个 Observable 的时候，要预先将要发出的数据准备好，等到有人订阅它的时候再将数据通过 Event 发出去。
 但有时我们希望 Observable 在运行的时候能动态地获取或者产生一个新的数据，再通过 Event 发送出去。
 比如：订阅一个输入框的输入内容，当用户每输入一个字后，这个输入框关联的 Observable 就会发出一个带有输入内容的 Event，通知给所有的订阅者，这个就需要 Subjects 来实现
 
 Subjects 既是订阅者observer，也是可观察序列obervable
 PublishSubject：
 BehaviorSubject：
 ReplaySubject：
 Variable：
 区别：当一个新的订阅者订阅它的时候，能不能收到subjects之前发出去过的旧的Event，如果能又能收到几个
 */

private extension HanggeRxVC {
    
    /**
     PublishSubject
     订阅之后，发出的event被监听
     */
    func publishSubject() {
    
        // 1.创建一个PublishSubject
        let subject = PublishSubject<String>()
        
        subject.onNext("111")
        
        // 第一次订阅subject
        subject.subscribe(onNext: {
            print("第一次订阅：", $0)
        }, onCompleted: {
            print("第一次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        // 当前有一个订阅者，则该信息会输出到控制台
        subject.onNext("222")
        
        // 第二次订阅subject
        subject.subscribe(onNext: {
            print("第二次订阅：", $0)
        }, onCompleted: {
            print("第二次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        subject.onNext("333")
        
        // 让subject结束
        subject.onCompleted()
        
        subject.onNext("444")
        
        subject.subscribe(onNext: {
            print("第三次订阅：", $0)
        }, onCompleted: {
            print("第三次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
    }
    
    /**
     BehaviorSubject
     初始化需要初始值，订阅会立即收到event
     */
    func behaviorSubject() {
        
        let subject = BehaviorSubject(value: "111")
        
        // 第一次订阅
        subject.subscribe(onNext: {
            print("第1次订阅：", $0)
        }, onCompleted: {
            print("第1次订阅: onCompleted")
        }).disposed(by: disposeBag)
        
        subject.onNext("222")
        
        subject.subscribe(onNext: {
            print("第2次订阅：", $0)
        }, onCompleted: {
            print("第2次订阅: onCompleted")
        }).disposed(by: disposeBag)
        
    }
    
    /**
     ReplaySubject bufferSize
     初始化传入butterSize，缓存数
     */
    func replaySubject() {
        
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")
        
        // 第一次订阅
        subject.subscribe { event in
            print("第一次订阅：", event)
        }.disposed(by: disposeBag)
        
        subject.onNext("444")
        
        // 第二次订阅
        subject.subscribe { event in
            print("第2次订阅：", event)
        }.disposed(by: disposeBag)
        
        // 让subject结束
        subject.onCompleted()
        
        // 第三次订阅
        subject.subscribe { event in
            print("第3次订阅：", event)
        }.disposed(by: disposeBag)
        
    }
    
    /**
     BehaviorRelay：本质是对 BehaviorSubect的封装，初始化需要初始值
     能够向订阅者发出上一个 event 已经之后新创建的 event
     有一个 value 值属性，可以通过这个属性获取最新值，通过 accept() 方法对值进行修改
     如果想将新值合并到原值上，可以通过 accept() 方法与 value 属性配合来实现。（这个常用于在表格上拉加载功能上， BehaviorRelay 用来保存所有加载到的数据）
     */
    func behaviorRelay1() {
        
        let subject = BehaviorRelay<String>(value: "111")
        
        subject.accept("222")
        
        subject.subscribe { event in
            print("第1次订阅：", event)
        }.disposed(by: disposeBag)
        
        subject.accept("333")
        
        subject.subscribe { event in
            print("第2次订阅：", event)
        }.disposed(by: disposeBag)
        
        subject.accept("444")
        
    }
    
    func behaviorRelay2() {
        
        let subject = BehaviorRelay(value: ["1"])
        
        subject.accept(subject.value + ["2", "3"])
        
        subject.subscribe {
            print("第1次订阅：", $0)
        }.disposed(by: disposeBag)
        
        subject.accept(subject.value + ["4", "5"])
        
        subject.asObservable().subscribe {
            print("第2次订阅：", $0)
        }.disposed(by: disposeBag)
        
        subject.accept(subject.value + ["6", "7"])
        
    }
    
    
}

/** 六
 变换操作符：Transforming Observables 实际就是对Observable进行一些转换
 buffer、map、flatMap、scan等
 */
private extension HanggeRxVC {
    
    // buffer：当元素达到一定个数或者经过特定时间，然后发出
    func buffer() {
        
        let subject = PublishSubject<String>()
        
        // 缓存三个或者两秒内不够三个也发出(有几个发就几个，没有就发空数组)
        subject
            .buffer(timeSpan: .seconds(2), count: 3, scheduler: MainScheduler.instance)
            .subscribe {
                print($0)
            }.disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
    }
    
    // window和buffer一样，但是发出的是observable
    func window() {
        
        let subject = PublishSubject<String>()
        
        // 缓存三个或者两秒内不够三个也发出(有几个发就几个，没有就发空数组)
        subject
            .window(timeSpan: .seconds(2), count: 3, scheduler: MainScheduler.instance)
            .subscribe {
                print($0)
            }.disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
    }
    
    // map：通过传入一个函数闭包，把原来的observable转换成一个新的observable
    func map() {
        
        Observable.of(1, 2, 3).map { $0 + 10 }.subscribe {
            print($0)
        }.disposed(by: disposeBag)
        
    }
    
    // flatMap：
    /**
     map容易升维：当事件元素是observable时，需要flatMap
     */
    func flatMap() {
        
        /// 如果Observable中的元素也是Observable
        Observable.of(1, 2, 3)
            .map { value in
                return Observable.just(value * 10)
            }.subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
        Observable.of(1, 2, 3)
            .map {
                return Observable.just($0 * 10)
            }.flatMap { $0 }.subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
    }
    
    // flatMapLatest：只会接受最新的value，发出来的序列
    func flatMapLatest() {
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = BehaviorRelay(value: subject1)
        
        variable.flatMap { $0 }.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        subject1.onNext("B")
        subject1.onNext("C")
//        variable.value = subject2
        subject2.onNext("2")
        subject2.onNext("3")
        
    }
    
    // flatMapFirst：只会接受旧的
    
    // concatMap：等待前一个 Observable 产生完成事件后，才会对后一个 Observable进行订阅
    
    // scan：给定一个初始化的数，拿前一个结果和最新的值进行处理
    func scan() {
        
        /**
         Observable.of(1, 2, 3, 4, 5)
             .scan(0) { acum, elem in
                 acum + elem
             }
             .subscribe(onNext: { print($0) })
             .disposed(by: disposeBag)
         */
        
        Observable.of(1, 2, 3, 4, 5)
            .scan(0) { acum, element in
                acum + element
            }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
    }
    
    // groupBy
    /**
     groupBy 操作符将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来，分组
     */
    func groupBy() {
        
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
                    .disposed(by: DisposeBag())
                default:
                    print("")
                }
            }
        .disposed(by: disposeBag)
        
        
    }
    
    
    /**
     map：返回的
     flatMap
     flatMapLatest
     Map与FlatMap的联系：都可以对元素进行转换，并且都是返回Observable类型
     flatMapLatest：闭包返回的是Observable , map 闭包返回值是任意类型
     */
    
   
    
}

/** 七
 过滤操作符：filter、take、skip等
 */
private extension HanggeRxVC {
    
    // 1.filter：该操作符过滤掉不符合要求的事件
    func filter() {

        Observable.of(2, 30, 22, 5, 60, 3, 40, 9)
                 .filter { $0 > 10 }
                 .subscribe(onNext: {
                     print($0)
                 }).disposed(by: disposeBag)
        
    }
    
    // 2.distinctUntilChanged：过滤掉连续重复的事件
    func distinectUntilChanged() {
        
        Observable.of(1, 2, 3, 1, 1, 4)
            .distinctUntilChanged()
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
    }
    
    
}

/** 八
 条件操作符：条件和布尔操作符：amb、takeWhile、skipWhile等
 */
private extension HanggeRxVC {
    
    
    
}

/** 九
 结合操作符：startWith、merge、zip等
 */
private extension HanggeRxVC {
    
    
    
}

/** 十
 算数&聚合操作符：toArray、reduce、concat
 */
private extension HanggeRxVC {
    
    
    
}

/** 十一
 算数&聚合操作符：toArray、reduce、concat
 */
private extension HanggeRxVC {
    
    
    
}

/** 十二
 连接操作符：connect、publish、replay、multicast
 */
private extension HanggeRxVC {
    
    
    
}

/** 十三
 其他操作符：delay、materialize、timeout等
 */
private extension HanggeRxVC {
    
    
    
}

/** 十四
 错误处理符号：Error Handling Operators
 调试：debug()
 */

/** 十五：
 特征序列：Traits
 */

/// Single：
/**
 Single：只发出一个元素或者一个错误，不共享状态，主要用于网络请求
 SingleEvent：RxSwift为了方便Single使用还提供了一个枚举
 asSingle()：Observable 可以通过 asSingle 转换成 Single
 public enum Result<Success, Failure> where Failure : Error {

     /// A success, storing a `Success` value.
     case success(Success)

     /// A failure, storing a `Failure` value.
     case failure(Failure)
 */
private extension HanggeRxVC {

    func single() {

        getPlayList("0").subscribe { event in
            switch event {
            case .success(let json):
                print("JSON结果：", json)
            case .failure(let error):
                print("发生错误：", error)
            }
        }.disposed(by: disposeBag)
        
    }

    /// 获取豆瓣数据
    func getPlayList(_ channel: String) -> Single<[String: Any]> {
        
        return Single<[String: Any]>.create { single in
            
            let url = "https://douban.fm/j/mine/playlist?" + "type=n&channel=\(channel)&from=mainsite"
            
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
                
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                      let result = json as? [String: Any] else {
                    single(.failure(DataError.cantParseJSON))
                    return
                }
                
                single(.success(result))
                
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
        
    }
    
    enum DataError: Error {
        case cantParseJSON
    }
    
}

/// Completable
/**
 只发出一个completed事件或者error事件
 Completable 和 Observable<Void> 一样
 public enum CompletableEvent {
     /// Sequence terminated with an error. (underlying observable sequence emits: `.error(Error)`)
     case error(Swift.Error)
     
     /// Sequence completed successfully.
     case completed
 }
 */
private extension HanggeRxVC {
    
    func completed() {
        
        /**
         //将数据缓存到本地
         func cacheLocally() -> Completable {
             return Completable.create { completable in
                 //将数据缓存到本地（这里掠过具体的业务代码，随机成功或失败）
                 let success = (arc4random() % 2 == 0)
                  
                 guard success else {
                     completable(.error(CacheError.failedCaching))
                     return Disposables.create {}
                 }
                  
                 completable(.completed)
                 return Disposables.create {}
             }
         }
          
         //与缓存相关的错误类型
         enum CacheError: Error {
             case failedCaching
         }
         */
        
    }
    
    /// 将数据缓存到本地
    func cacheLocally() -> Completable {
        
        return Completable.create { completable in
            
            let success = (arc4random() % 2 == 0)
            
            guard success else {
                completable(.error(CacheError.failedCaching))
                return Disposables.create {}
            }
            
            completable(.completed)
            
            return Disposables.create {}
            
        }
        
    }
    
    enum CacheError: Error {
        case failedCaching
    }
    
}

/// Maybe
/**
 Maybe：要么发出一个元素，要么completed，要么error
 */
private extension HanggeRxVC {
    
    func maybe() {
        
        generateString().subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
        
    }
    
    func generateString() -> Maybe<String> {
        
        return Maybe<String>.create { maybe in
            
            maybe(.success("dachun.com"))
            
            maybe(.success("学习"))
            
            maybe(.completed)
            
            maybe(.error(StringError.failedGenerate))
            
            return Disposables.create {}
            
        }
        
    }
    
    enum StringError: Error {
        case failedGenerate
    }
    
}

/// Driver

/// ControlProperty、 ControlEvent
private extension HanggeRxVC {
    
    /**
     ControlProperty 是专门用来描述 UI 控件属性，拥有该类型的属性都是被观察者 （Observable）
     具有以下特征：
     1、不会产生 error 事件
     2、一定在 MainScheduler 订阅（主线程订阅）
     3、一定在 MainScheduler 监听（主线程监听）
     4、共享状态变化
     
     其实在 RxCocoa 下许多 UI 控件属性都是被观察者（可观察序列），比如 UITextField+Rx.swift，可以发现 UITextField 的 rx.text 属性类型便是 ControlProperty<String?>:
     
     */
    
    /**
     ControlEvent 是专门用于描述 UI 所产生的事件，拥有该类型的属性都是被观察者 （Observable）
     具有以下特征：
     1、不会产生 error 事件
     2、一定在 MainScheduler 订阅（主线程订阅）
     3、一定在 MainScheduler 监听（主线程监听）
     4、共享状态变化
     
     同样地，在 RxCocoa 下许多 UI 控件的事件方法都是被观察者（可观察序列）。比如我们查看源码（UIButton+Rx.swift），可以发现 UIButton 的 rx.tap 方法类型便是 ControlEvent<Void>：
    
     */
    
    
    
    
    
}

/** 十六
 调度器：subscribeOn，observeOn
 区别：
 subscribeOn()：该方法决定构建序列的构造函数在哪个 Scheduler 上运行
 observeOn：该方法决定在哪个 Scheduler 上监听这个数据序列
 */
private extension HanggeRxVC {
    
    func dispatch() {
        
        /// 后台获取数据
        DispatchQueue.global(qos: .userInitiated).async {
            let data = try? Data(contentsOf: URL(string: "")!)
            DispatchQueue.main.async {
                print("data")
            }
            
        }
        
        /*
        let rxData: Observable<Data> = ...
         
        rxData
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated)) //后台构建序列
            .observeOn(MainScheduler.instance)  //主线程监听并处理序列结果
            .subscribe(onNext: { [weak self] data in
                self?.data = data
            })
            .disposed(by: disposeBag)
         */
        
        

    }
    
}

/** 十七
 RxSwift_操作符_share(replay:scope:)
 */

private extension HanggeRxVC {

    /**
     share(replay:scope:) 作用：
     解决有多个订阅者的情况下，避免事件转换操作符（比如：map、flatMap、flatMapLatest等等）被多次执行的问题
     */
    func share() {
        
        let seq = PublishSubject<Int>()
        
        let ob = seq.map {
            print("map 被调用：---\($0)")
            return $0 * 2
        }
        
        ob.subscribe(onNext: {
            print("--第一次订阅--\($0)")
        }).disposed(by: disposeBag)
        
        ob.subscribe(onNext: {
            print("--第二次订阅--\($0)")
        }).disposed(by: disposeBag)
        
        seq.onNext(1)
        
    }
    
    func share1() {
        
        let net = Observable<String>.create { observable -> Disposable in
            print("我开始网络请求了")
            observable.onNext("请求结果")
            observable.onCompleted()
            return Disposables.create {
                print("销毁了")
            }
        }
        
        net.subscribe(onNext: {
            print("第一次订阅：\($0)", Thread.current)
        }).disposed(by: disposeBag)
        
        net.subscribe(onNext: {
            print("第二次订阅：\($0)", Thread.current)
        }).disposed(by: disposeBag)
        
    }
    
}


fileprivate enum HanggeError: Swift.Error {
    case a
    case b
}

/**
 Driver
 combineLatest
 withLatestFrom
 flatMapLatest
 startWith
 */

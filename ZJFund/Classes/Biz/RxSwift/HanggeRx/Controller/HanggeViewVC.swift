//
//  HanggeViewVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/23.
//

import UIKit
import RxSwift
import RxCocoa

/**

class HanggeViewVC: BaseVC {
    
    /// UILabel+Rx
    private lazy var label = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "我是一个label"
    }
    
    /// UITextField+Rx
    private lazy var field1 = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    private lazy var field2 = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    private lazy var testBtn = UIButton(type: .system).then {
        $0.setTitle("提交", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
        textField()
    }

}

private extension HanggeViewVC {
    
    func setupViews() {
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: testBtn)
        
        field1.add(to: view).snp.makeConstraints {
            $0.left.top.right.equalToSuperview().inset(20)
            $0.height.equalTo(45)
        }
        
        field2.add(to: view).snp.makeConstraints {
            $0.top.equalTo(field1.snp.bottom).offset(15)
            $0.left.right.height.equalTo(field1)
        }
        
        label.add(to: view).snp.makeConstraints {
            $0.left.equalTo(field2)
            $0.top.equalTo(field2.snp.bottom).offset(15)
        }
        
        testBtn.add(to: view).snp.makeConstraints {
            $0.left.equalTo(label)
            $0.top.equalTo(label.snp.bottom).offset(15)
        }
        
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.label3()
        }).disposed(by: disposeBag)
        
    }
    
}

/// UILabel+Rx
private extension HanggeViewVC {
    
    func label1() {
        
        let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        timer.map{ "\($0)" }.bind(to: label.rx.text).disposed(by: disposeBag)
        
    }
    
    func label2() {
        
        /**
         seconds：秒
         milliseconds：毫秒，千分之一秒
         microseconds：微秒，一百万分之一秒
         nanoseconds：纳秒，十亿分之一秒
         */
        
        let timer = Observable<Int>.interval(.milliseconds(100), scheduler: MainScheduler.instance)
        
        timer.map(formatTimeInterval).bind(to: label.rx.attributedText).disposed(by: disposeBag)
        
    
        
    }

    // 将数字转成对应的富文本
    func formatTimeInterval(_ ms: NSInteger) -> NSMutableAttributedString {
        
        let string = String(format: "%0.2d:%0.2d:%0.1d", ms / 600, (ms / 10) % 60, ms % 10)
        
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes([NSAttributedStringKey.font: UIFont.bold16,
                                        NSAttributedStringKey.foregroundColor: UIColor.white,
                                        NSAttributedStringKey.backgroundColor: UIColor.orange], range: NSMakeRange(0, 5))
        
        return attributedString
        
    }
    
    func label3() {
        
        let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        timer.map{ $0 % 2 == 0 ? UIColor.red : UIColor.orange }.bind(to: label.rx.textColor).disposed(by: disposeBag)
        
    }
    
    
    
}

/// UITextField+Rx
private extension HanggeViewVC {
    
    func textField() {
        
        /*
        field1.rx.text.orEmpty.changed.subscribe(onNext: { [weak self] element in
            print("输入值 === ", element)
            self?.label.text = element
        }).disposed(by: disposeBag)
        
        field.rx.text.orEmpty.asObservable().bind(to: label.rx.text).disposed(by: disposeBag)
         */
        
        /*
        let input = field1.rx.text.orEmpty.asDriver().throttle(.milliseconds(300))
        
        input.drive(field2.rx.text).disposed(by: disposeBag)
        
        input.map { "当前字数：\($0.count)" }.drive(label.rx.text).disposed(by: disposeBag)
        
        input.map { $0.count > 5 }.drive(testBtn.rx.isEnabled).disposed(by: disposeBag)
        */
        
        /// 监听多个UITextField
        /*
        Observable.combineLatest(field1.rx.text.orEmpty, field2.rx.text.orEmpty)
            .map { "你输入的号码是：\($0) - \($1)" }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
         */
        
        /// 事件监听
        /*
        field1.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: {
                print("开始编辑了")
            }).disposed(by: disposeBag)
         */
        
        field1.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            self?.field2.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        field2.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            self?.field2.resignFirstResponder()
        }).disposed(by: disposeBag)
        
        /// UITextView和UITextField的区别：
        /**
         UITextView单独封装了事件
         didBeginEditing：开始编辑
         didEndEditing：结束编辑
         didChange：编辑内容发生改变
         didChangeSelection：选中部分发生变化
         */
        
    }
    
}

 */

// MARK: - UIButton & UIBarButtonItem
class HanggeButtonVC: BaseVC {
    
    private lazy var button = UIButton(type: .system).then {
        $0.setTitle("按钮", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }
    
    func setupViews() {
        
        button.add(to: view).snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(30)
        }
        
    }
    
    func bindActions() {
        
//        button.rx.tap.subscribe(onNext: { [weak self] in
//            self?.showMessage("按钮被点击了")
//        }).disposed(by: disposeBag)
        
//        button.rx.tap.bind { [weak self] in
//            self?.showMessage("按钮被点击了")
//        }.disposed(by: disposeBag)
        
        let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
//        timer.map{ "当前记数：\($0)" }.bind(to: button.rx.title(for: .normal)).disposed(by: disposeBag)
        
//        timer.map { $0 % 2 == 0 ? true : false }.bind(to: button.rx.isEnabled).disposed(by: disposeBag)
        
        timer.map { $0 % 2 == 0 ? true : false }.bind(to: button.rx.isSelected).disposed(by: disposeBag)
        
    }

    func showMessage(_ text: String) {
        let alertVC = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alertVC.addAction(title: "确定", style: .cancel, handler: nil)
        self.present(alertVC, animated: true)
    }
    
}

// MARK: - UISwitch & UISegmentedControl & UIActivityIndicatorView & UIApplication & UISlider & UIStepper
class HanggeSwitchVC: BaseVC {
    
    private lazy var switchBtn = UISwitch()
    
    private lazy var button = UIButton(type: .system).then {
        $0.setTitle("按钮", for: .normal)
    }
    
    private lazy var segmented = UISegmentedControl(items: ["学习", "锻炼", "泡妞"])
    
    private lazy var indicatorView = UIActivityIndicatorView()
    
    private lazy var slider = UISlider()
    
    private lazy var stepper = UIStepper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }
    
    func setupViews() {
        
        switchBtn.add(to: view).snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(50)
        }
        
        button.add(to: view).snp.makeConstraints {
            $0.left.equalTo(switchBtn.snp.right).offset(50)
            $0.centerY.equalTo(switchBtn)
        }
        
        indicatorView.add(to: view).snp.makeConstraints {
            $0.left.equalTo(button.snp.right).offset(30)
            $0.centerY.equalTo(button)
        }
        
        segmented.add(to: view).snp.makeConstraints {
            $0.left.equalTo(switchBtn)
            $0.top.equalTo(switchBtn.snp.bottom).offset(50)
            $0.right.equalToSuperview().inset(50)
            $0.height.equalTo(50)
        }
        
        slider.add(to: view).snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(segmented.snp.bottom).offset(30)
        }
        
        stepper.add(to: view).snp.makeConstraints {
            $0.top.equalTo(slider.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    func bindActions() {
        
        switchBtn.rx.isOn.asObservable().subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        switchBtn.rx.isOn.bind(to: button.rx.isEnabled).disposed(by: disposeBag)
        
        segmented.rx.selectedSegmentIndex.asObservable().subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
//        switchBtn.rx.isOn.asObservable().bind(to: indicatorView.rx.isAnimating).disposed(by: disposeBag)
        switchBtn.rx.value.bind(to: indicatorView.rx.isAnimating).disposed(by: disposeBag)
        switchBtn.rx.value.bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible).disposed(by: disposeBag)
        
        slider.rx.value.subscribe(onNext: { value in
            print(value)
        }).disposed(by: disposeBag)
        
//        slider.rx.value
//            .map { Double($0) }
//            .bind(to: stepper.rx.stepValue)
//            .disposed(by: disposeBag)
        
    }
    
}

// MARK: - 双向绑定 & UIGestureRecognizer
class HanggeRecognizerVC: BaseVC {
    
    var viewModel = HanggeViewVM()
    
    private lazy var userNameField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "请输入用户名"
    }
    
    private lazy var label = UILabel().then {
        $0.text = "您是---"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }
    
    func setupViews() {
        
//        userNameField.add(to: view).snp.makeConstraints {
//            $0.left.top.right.equalToSuperview().inset(20)
//            $0.height.equalTo(45)
//        }
//
//        label.add(to: view).snp.makeConstraints {
//            $0.left.equalTo(userNameField)
//            $0.top.equalTo(userNameField.snp.bottom).offset(20)
//        }
        
    }
    
    func bindActions() {
        
        /**
        viewModel.username.asObservable().bind(to: userNameField.rx.text).disposed(by: disposeBag)
        userNameField.rx.text.orEmpty.bind(to: viewModel.username).disposed(by: disposeBag)
        viewModel.userInfo.bind(to: label.rx.text).disposed(by: disposeBag)
        */
        
        /*
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .up
        self.view.addGestureRecognizer(swipe)
        
//        swipe.rx.event
//            .subscribe(onNext: { [weak self] recognizer in
//                let point = recognizer.location(in: recognizer.view)
//                self?.showAlert(title: "向上滑动", message: "\(point.x) \(point.y)")
//            })
//            .disposed(by: disposeBag)
        
        swipe.rx.event.bind { [weak self] recognizer in
            let point = recognizer.location(in: recognizer.view)
            self?.showAlert(title: "向上滑动", message: "\(point.x) \(point.y)")
        }.disposed(by: disposeBag)
        */
        
        
        let tap = UITapGestureRecognizer()
        tap.rx.event.subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        
    }
    
    func showAlert(title: String, message: String) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "确定", style: .cancel))
        self.present(alertVC, animated: true)
        
    }
    
}

// MARK: - Notification
class HanggeNotificationVC: BaseVC {
    
    private lazy var pushBtn = UIButton(type: .system).then {
        $0.setTitle("Push", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }
    
    func setupViews() {
        
        pushBtn.add(to: view).snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(30)
        }
        
    }
    
    func bindActions() {
        
        pushBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.test()
        }).disposed(by: disposeBag)
        
    }
    
    func test() {
        
        // 发送通知
        /**
         let notificationName = Notification.Name(rawValue: "DownloadImageNotification")
                 NotificationCenter.default.post(name: notificationName, object: self,
                                             userInfo: ["value1":"hangge.com", "value2" : 12345])
         */
        // succeed
        let notificationName = Notification.Name(rawValue: "Download.image.success")
        NotificationCenter.default.post(name: notificationName, object: self, userInfo: ["username": "hangge.com", "password": "123456"])
        
    }
    
}

// MARK: - KVO
class HanggeViewVC: BaseVC {
    
    // @objc dynamic var message = "hangge.com"
    
    @objc dynamic var message = "hangge.com"
    
    private lazy var tableView = UITableView()
    
    private lazy var addBtn = UIButton(type: .system).then {
        $0.setTitle("增加", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindActions()
        
    }
    
    func setupViews() {
        
        addBtn.add(to: view).snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    func bindActions() {
        
        addBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.add()
        }).disposed(by: disposeBag)
        
        /*
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.message.append("!")
            })
            .disposed(by: disposeBag)
        
        self.rx.observeWeakly(String.self, "message")
            .subscribe(onNext: { value in
                print(value ?? "")
            })
            .disposed(by: disposeBag)
         */
        
        
        /**
         //监听视图frame的变化
                 _ = self.rx.observe(CGRect.self, "view.frame")
                     .subscribe(onNext: { frame in
                         print("--- 视图尺寸发生变化 ---")
                         print(frame!)
                         print("\n")
                     })
         */
        
        // 监听视图的frame的变化
        self.rx.observe(CGRect.self, "view.frame")
            .subscribe(onNext: { frame in
                print("--- 视图尺寸发生变化 ---")
                print(frame!)
                print("\n")
            })
            .disposed(by: disposeBag)
        
        /**
         //使用kvo来监听视图偏移量变化
                 _ = self.tableView.rx.observe(CGPoint.self, "contentOffset")
                     .subscribe(onNext: {[weak self] offset in
                         var delta = offset!.y / CGFloat(64) + 1
                         delta = CGFloat.maximum(delta, 0)
                         self?.barImageView?.alpha = CGFloat.minimum(delta, 1)
                     })
         */
        
        self.tableView.rx.observe(CGPoint.self, "contentOffset")
            .subscribe(onNext: { offset in
                var delta = offset!.y / CGFloat(64) + 1
                delta = CGFloat.maximum(delta, 0)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func add() {
        

        
    }
    
    
}

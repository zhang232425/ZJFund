//
//  HanggeCocoaRxVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/11.
//

import UIKit
import RxSwift
import RxCocoa

class HanggeCocoaRxVC: BaseVC {
    
    private lazy var button = UIButton(type: .system).then {
        $0.setTitle("Test", for: .normal)
    }
    
    private lazy var label = UILabel().then {
        $0.text = "我是一个Label"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }
    
}

private extension HanggeCocoaRxVC {
    
    func setupViews() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        label.add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    func bindActions() {
        
        button.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.labelTest2()
            }.disposed(by: disposeBag)
        
    }
    
}

/// UILabel+Rx.swift
private extension HanggeCocoaRxVC {
    
    func labelTest1() {
        
        // 1.创建定时器序列（0.1秒发送一个索引数）
        let timer = Observable<Int>.interval(.milliseconds(100), scheduler: MainScheduler.instance)
        
        // 2.序列被订阅
        timer.map { String(format: "%0.2d:%0.2d.%0.1d", arguments: [($0 / 600) % 600, ($0 % 600) / 10, $0 % 10]) }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    
    }
    
    func labelTest2() {
        
        // 1.创建定时器序列（0.1秒发送一个索引数）
        let timer = Observable<Int>.interval(.milliseconds(100), scheduler: MainScheduler.instance)
        
        // 2.序列被订阅
        timer.map(formatInterval).bind(to: label.rx.attributedText).disposed(by: disposeBag)
        
    }
    
    // 将数字转成对应的富文本
    func formatInterval(ms: Int) -> NSMutableAttributedString {
        
        let string = String(format: "%0.2d:%0.2d.%0.1d", [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
        
        // 富文本设置
        let attributeString = NSMutableAttributedString(string: string)
        // 0~6个字符字体Bold，16号
        attributeString.addAttributes([NSAttributedString.Key.font: UIFont.bold16], range: NSMakeRange(0, 5))
        // 设置文字字体颜色
        attributeString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], range: NSMakeRange(0, 5))
        // 设置文字背景颜色
        attributeString.addAttributes([NSAttributedString.Key.backgroundColor: UIColor.orange], range: NSMakeRange(0, 5))
        
        return attributeString
        
    }
    
}

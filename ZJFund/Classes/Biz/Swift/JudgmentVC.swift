//
//  JudgmentVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/2/23.
//

import UIKit

class JudgmentVC: BaseVC {
    
    private lazy var testBtn = UIButton(type: .system).then {
        $0.setTitle("开始测试", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }
    
}

private extension JudgmentVC {
    
    func setupViews() {
        
        testBtn.add(to: view).snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(50)
        }
        
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.power()
        }).disposed(by: disposeBag)
        
    }
    
}

private extension JudgmentVC {
    
    func test1() {
        
        /// is用来做检验
        let dog = Dog()
        let pig = Pig()
        let array = [dog, pig]
        
        for animal in array {
            if animal is Dog {
                print("这是一只狗狗")
            } else if animal is Pig {
                print("这是一只猪猪")
            }
        }
        
        /// as用来做类型转换
        for animal in array {
            if let dog = animal as? Dog {
                print("这是只狗 \(dog)")
            } else if let pig = animal as? Pig {
                print("这是只猪 \(pig)")
            }
        }
        
        let card = Poker(suit: .heart, number: .three)
        card.description()
        
    }
    
}

/// 计算次方 &
private extension JudgmentVC {
    
    func power() {
        
        /// 2的N次方，2的随机次方
        var value1 = 1 << 4
        var value2 = 1 << Int(arc4random_uniform(5)) // 2的0～4次方（包括0～4）
        print("value1 = ", value1)
        print("value2 = ", value2)
        
    }
    
}

/// 动物类
fileprivate class Animal {}

/// 狗
fileprivate class Dog: Animal {}

/// 猪
fileprivate class Pig: Animal {}

/// 类型嵌套

struct Poker {
    
    enum Suit: String {
        case heart   = "红桃"
        case club    = "梅花"
        case diamond = "方片"
        case spade   = "黑桃"
    }
    
    enum Number: Int {
        case two = 2
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten
        case jack
        case queen
        case king
        case ace
    }
    
    let suit: Suit
    
    let number: Number
    
    func description() {
        print("这张牌的花色是\(suit.rawValue)，牌的面值是\(number.rawValue)")
    }
    
}

//
//  GenericsVC.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/21.
//

/***
 https://gitbook.swiftgg.team/swift/swift-jiao-cheng/22_generics
 */

import UIKit

class GenericsVC: BaseVC {
    
    private lazy var testBtn = UIButton(type: .system).then {
        $0.setTitle("Test", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }

}

private extension GenericsVC {
    
    func setupViews() {
        
        testBtn.add(to: view).snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribeNext(weak: self, GenericsVC.testClick).disposed(by: disposeBag)
        
    }
    
}

private extension GenericsVC {
    
    func testClick(_: Void) {
        
//        var a = 10
//        var b = 20
//        print("a === \(a), b === \(b)")
//        swapTwoValues(&a, &b)
//        print("a === \(a), b === \(b)")
        
//        var array = [1, 2, 3, 4, 5]
//        let result = array.removeLast()
//        print("result === \(result)")
//        print("array === \(array)")
        
//        var stackStrings = Stack<String>()
//        stackStrings.push("张大春")
//        stackStrings.push("王滕")
//        stackStrings.push("彭敏")
//        stackStrings.push("陈铭")
//        stackStrings.push("龙蓉")
//
//        let top = stackStrings.pop()
        
//        let array = [1, 2, 3]
//        if array.indices.contains(5) {
//            print("数组未越界")
//        } else {
//            print("数组越界")
//        }
        
        /**
         let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
         if let foundIndex = findIndex(ofString: "llama", in: strings) {
             print("The index of llama is \(foundIndex)")
         }
         */
        
//        let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
//        if let foundIndex = findIndex(ofString: "llama", in: strings) {
//            print("The index of llama is \(foundIndex)")
//        }
        
        
    
        
    }
    
}

/// 泛型函数 & 类型参数
/**
 inout: 输入输出参数原理
 */
private extension GenericsVC {
    
    /*
    func swapTwoInts(_ a: inout Int, _ b: inout Int) {
        let temp = a
        a = b
        b = temp
    }
    
    func swapTwoStrings(_ a: inout String, _ b: inout String) {
        let temp = a
        a = b
        b = temp
    }
     */
    
    /**
     func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
         let temporaryA = a
         a = b
         b = temporaryA
     }
     */
    
    func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
        let temp = a
        a = b
        b = temp
    }
    
    
}

/// 泛型类型

/**
fileprivate struct IntStack {
    
    var items: [Int] = []
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
}
*/

/**
 struct Stack<Element> {
     var items: [Element] = []
     mutating func push(_ item: Element) {
         items.append(item)
     }
     mutating func pop() -> Element {
         return items.removeLast()
     }
 }
 */

fileprivate struct Stack<Element> {
    var items: [Element] = []
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

/// 泛型扩展
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

/// 类型约束
private extension GenericsVC {
    
    /**
    func someFunction<T: someClass, U: SomeProtocol>(someT: T, someU: U) {
        // 函数体
    }
     */
    
    // findIndex(ofString:in:)
    /*
    func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
        for (index, value) in array.enumerated() {
            if value == valueToFind {
                return index
            }
        }
        return nil
    }
     */
    
    
    /**
     func findIndex<T>(of valueToFind: T, in array:[T]) -> Int? {
         for (index, value) in array.enumerated() {
             if value == valueToFind {
                 return index
             }
         }
         return nil
     }
     */
    
    func findIndex<T: Equatable>(ofString valueToFind: T, in array: [T]) -> Int? {
        for (index, value) in array.enumerated() {
            if value == valueToFind {
                return index
            }
        }
        return nil
    }
    
}

/// 关联类型
/**
 protocol Container {
     associatedtype Item
     mutating func append(_ item: Item)
     var count: Int { get }
     subscript(i: Int) -> Item { get }
 }
 */
fileprivate protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

/**
 
 struct IntStack: Container {
     // IntStack 的原始实现部分
     var items: [Int] = []
     mutating func push(_ item: Int) {
         items.append(item)
     }
     mutating func pop() -> Int {
         return items.removeLast()
     }
     // Container 协议的实现部分
     typealias Item = Int
     mutating func append(_ item: Int) {
         self.push(item)
     }
     var count: Int {
         return items.count
     }
     subscript(i: Int) -> Int {
         return items[i]
     }
 }
 */

fileprivate struct IntStack: Container {
    // IntStack 的原始实现部分
    var items: [Int] = []
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    // Container 协议的实现部分
    typealias Item = Int
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}

 /// 给关联类型添加约束

//
//  ZJFundModule.swift
//  Pods-ZJFund_Example
//
//  Created by Jercan on 2023/9/9.
//

import ZJRouter
import ZJRoutableTargets
import ZJBase

public struct ZJFundModule: ZJModule {
    
    public init() {}
    
    public func initialize() {
        
        ZJFundRoutableTarget.register(path: ZJFundRoutePath.fund) { _ in
            return BaseNavigationVC(rootViewController: ZJFundVC())
        }
        
        ZJFundRoutableTarget.register(path: ZJFundRoutePath.swift) { _ in
            return BaseNavigationVC(rootViewController: SwiftVC())
        }
        
        ZJFundRoutableTarget.register(path: ZJFundRoutePath.rxSwift) { _ in
            return BaseNavigationVC(rootViewController: RxSwiftVC())
        }
        
        ZJFundRoutableTarget.register(path: ZJFundRoutePath.hangge) { _ in
            return BaseNavigationVC(rootViewController: HanggeVC())
        }
        
        ZJFundRoutableTarget.register(path: ZJFundRoutePath.vendors) { _ in
            return BaseNavigationVC(rootViewController: VendorsVC())
        }
        
    }
    
}

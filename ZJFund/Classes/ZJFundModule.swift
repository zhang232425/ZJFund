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
            return ZJNavigationController(rootViewController: ZJFundViewController())
        }
        
    }
    
}

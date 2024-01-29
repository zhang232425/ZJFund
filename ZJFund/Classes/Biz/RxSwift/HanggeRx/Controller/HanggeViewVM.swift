//
//  HanggeViewVM.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/25.
//

import Foundation
import RxCocoa

struct HanggeViewVM {
    
    // 用户名
    let username = BehaviorRelay(value: "guest")
    
    // 用户信息
    lazy var userInfo = {
        return self.username.asObservable()
            .map{ $0 == "hangge" ? "您是管理员" : "您是普通访客" }
            .share(replay: 1)
    }()
    
}

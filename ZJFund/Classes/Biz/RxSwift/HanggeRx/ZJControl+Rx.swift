//
//  ZJControl+Rx.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/9.
//

import UIKit
import RxSwift

extension Reactive where Base: UIControl {
    
    public var isEnabled: Binder<Bool> {
        return Binder(self.base) { control, value in
            control.isEnabled = value
        }
    }
    
}


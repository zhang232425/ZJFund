//
//  ZJUILabel+Rx.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/10.
//

import Foundation
import RxSwift

/**
 方案一：直接对UILabel类进行扩展
 */
extension UILabel {
    
    var fontSize: Binder<CGFloat> {
        return Binder(self) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
}

/**
 方案二：通过对 Reactive 类进行扩展
 */

extension Reactive where Base: UILabel {
    
    var fontSize: Binder<CGFloat> {
        return Binder(self.base) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }

}

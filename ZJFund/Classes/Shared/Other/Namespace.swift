//
//  Namespace.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/22.
//

import Foundation

protocol NamespaceWrappable {
    
    associatedtype WrapperType
    
    var dd: WrapperType { get }
    
    static var dd: WrapperType.Type { get }
    
}

extension NamespaceWrappable {
    
    var dd: NamespaceWrapper<Self> {
        return NamespaceWrapper(warppedValue: self)
    }
    
    static var dd: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
    
}

struct NamespaceWrapper<T> {
    
    let warppedValue: T
    
    init(warppedValue: T) {
        self.warppedValue = warppedValue
    }
    
}

//
//  ZJFundRoutableTarget.swift
//  ZJRoutableTargets
//
//  Created by Jercan on 2023/9/9.
//

import ZJRouter

public struct ZJFundRoutePath {}

public extension ZJFundRoutePath {
    
    static let fund = ZJRoutePath(value: "as://fund.fund")
    static let swift = ZJRoutePath(value: "as://fund.swift")
    static let rxSwift = ZJRoutePath(value: "as://fund.rxswift")
    static let vendors = ZJRoutePath(value: "as://fund.vendors")
    
}

public enum ZJFundRoutableTarget {
    
    case fund
    case swift
    case rxSwift
    case vendors
    
}

extension ZJFundRoutableTarget: ZJRoutableTarget {
    
    public var path: ZJRoutePath {
        switch self {
        case .fund:
            return ZJFundRoutePath.fund
        case .swift:
            return ZJFundRoutePath.swift
        case .rxSwift:
            return ZJFundRoutePath.rxSwift
        case .vendors:
            return ZJFundRoutePath.vendors
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .fund:
            return nil
        case .swift:
            return nil
        case .rxSwift:
            return nil
        case .vendors:
            return nil
        }
    }
    
}

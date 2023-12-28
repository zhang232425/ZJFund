//
//  ZJPersonalRoutableTarget.swift
//  Pods-ZJRoutableTargets_Example
//
//  Created by Jercan on 2022/9/16.
//

import ZJRouter

public struct ZJPersonalRoutePath {}
    
public extension ZJPersonalRoutePath {
    static let personal = ZJRoutePath(value: "as://personal.personal")
    static let test = ZJRoutePath(value: "as://personal.test")
}

public enum ZJPersonalRoutableTarget: ZJRoutableTarget {
    case personal
    case test
}

extension ZJPersonalRoutableTarget {
    
    public var path: ZJRoutePath {
        switch self {
        case .personal:
            return ZJPersonalRoutePath.personal
        case .test:
            return ZJPersonalRoutePath.test
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .personal:
            return nil
        case .test:
            return nil
        }
    }
    
}

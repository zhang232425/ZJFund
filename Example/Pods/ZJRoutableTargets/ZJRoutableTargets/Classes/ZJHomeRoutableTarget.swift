//
//  ZJHomeRoutableTarget.swift
//  Pods-ZJRoutableTargets_Example
//
//  Created by Jercan on 2022/9/16.
//

import ZJRouter

public struct ZJHomeRoutePath {}

public extension ZJHomeRoutePath {
    static let home = ZJRoutePath(value: "as://home.home")
    static let test = ZJRoutePath(value: "as://home.test")
}

public enum ZJHomeRoutableTarget: ZJRoutableTarget {
    case home
    case test
}

extension ZJHomeRoutableTarget {
    
    public var path: ZJRoutePath {
        switch self {
        case .home:
            return ZJHomeRoutePath.home
        case .test:
            return ZJHomeRoutePath.test
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .home:
            return nil
        case .test:
            return nil
        }
    }
    
}


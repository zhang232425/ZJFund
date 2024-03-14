//
//  ZJStudyRoutableTarget.swift
//  ZJRoutableTargets
//
//  Created by Jercan on 2024/3/5.
//

import ZJRouter

public struct ZJStudyRoutePath {
    
    static let grammar = ZJRoutePath(value: "as://study.grammar")
    static let function = ZJRoutePath(value: "as://study.function")
    static let scheme = ZJRoutePath(value: "as://study.scheme")
    static let algorithm = ZJRoutePath(value: "as://study.algorithm")
    
}

public enum ZJStudyRoutableTarget: ZJRoutableTarget {
    
    case grammar
    case function
    case scheme
    case algorithm
    
}

extension ZJStudyRoutableTarget {
    
    public var path: ZJRoutePath {
        switch self {
        case .grammar:
            return ZJStudyRoutePath.grammar
        case .function:
            return ZJStudyRoutePath.function
        case .scheme:
            return ZJStudyRoutePath.scheme
        case .algorithm:
            return ZJStudyRoutePath.algorithm
        }
    }
    
    public var parameters: [String : Any]? {
        return nil
    }
    
}

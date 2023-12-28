//
//  Bundle+Extension.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/22.
//

import Foundation

extension Bundle {
    
    static var framework_ZJFund: Bundle {
        let frameworkName = "ZJFund"
        let resourcePath: NSString = .init(string: Bundle(for: ZJFundClass.self).resourcePath ?? "")
        let path = resourcePath.appendingPathComponent("/\(frameworkName).bundle")
        return Bundle(path: path)!
    }
    
    private class ZJFundClass {}
    
}

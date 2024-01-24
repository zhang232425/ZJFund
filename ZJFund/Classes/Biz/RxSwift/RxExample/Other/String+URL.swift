//
//  String+URL.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/24.
//

import Foundation

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}

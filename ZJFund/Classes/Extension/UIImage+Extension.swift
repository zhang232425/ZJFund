//
//  UIImage+Extension.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/22.
//

import Foundation

extension UIImage: NamespaceWrappable {}

extension NamespaceWrapper where T == UIImage {
    
    static func named(_ name: String) -> UIImage? {
        UIImage(name: name, bundle: .framework_ZJFund)
    }
    
}

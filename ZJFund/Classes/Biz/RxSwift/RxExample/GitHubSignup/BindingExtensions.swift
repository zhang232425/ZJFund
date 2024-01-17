//
//  BindingExtensions.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/16.
//

import Foundation
import RxSwift
import RxCocoa

extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .success(let message):
            return message
        case .empty:
            return ""
        case .validating:
            return "validating..."
        case .failed(let message):
            return message
        }
    }
}

struct ValidationColors {
    static let successColor = UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    static let failedColor = UIColor.red
}

extension ValidationResult {
    var textColor: UIColor {
        switch self {
        case .success:
            return ValidationColors.successColor
        case .empty:
            return UIColor.black
        case .validating:
            return UIColor.black
        case .failed:
            return ValidationColors.failedColor
        }
    }
}

extension Reactive where Base: UILabel {
    var validationResult: Binder<ValidationResult> {
        return Binder(base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}

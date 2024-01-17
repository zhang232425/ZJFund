//
//  Protocols.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/16.
//

import Foundation
import RxSwift
import Action

enum ValidationResult {
    case success(String)
    case empty
    case validating
    case failed(String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
}

protocol GitHubAPI {
    func usernameAvailable(_ username: String) -> Observable<Bool>
    func signup(_ username: String, _ password: String) -> Observable<Bool>
}

protocol GitHubValidationService {
    func validateUsername(_ username: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepeatedPassword(_ password: String, _ repeatedPassword: String) -> ValidationResult
}

protocol Wireframe {
    func open(url: URL)
    func promptFor<Action: CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}


//
//  DefaultImplementations.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/16.
//

import Foundation
import RxSwift
import RxCocoa

class GitHubDefaultValidationService: GitHubValidationService {
    
    let minPasswordCount = 5
    
    let API: GitHubAPI
    
    static let sharedValidationService = GitHubDefaultValidationService(API: GitHubDefaultAPI.sharedAPI)
    
    init(API: GitHubAPI) {
        self.API = API
    }
    
    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        
        if username.isEmpty {
            return .just(.empty)
        }
        
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed("Username can only contain numbers or digits"))
        }
        
        let loadingValue = ValidationResult.validating
        
        return API.usernameAvailable(username)
            .map { available in
                return available ? .success("Username available") : .failed("Username already taken")
            }
            .startWith(loadingValue)
        
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        
        let numberOfCharacters = password.count
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minPasswordCount {
            return .failed("Password must be at least \(minPasswordCount) characters")
        }
        
        return .success("Password acceptable")
        
    }
    
    func validateRepeatedPassword(_ password: String, _ repeatedPassword: String) -> ValidationResult {
        
        if repeatedPassword.count == 0 {
            return .empty
        }
        
        if repeatedPassword == password {
            return .success("Password repeated")
        } else {
            return .failed("Password different")
        }
        
    }
    

}

class GitHubDefaultAPI: GitHubAPI {
        
    let URLSession: Foundation.URLSession
    
    static let sharedAPI = GitHubDefaultAPI(URLSession: Foundation.URLSession.shared)
    
    init(URLSession: URLSession) {
        self.URLSession = URLSession
    }
    
    func usernameAvailable(_ username: String) -> Observable<Bool> {
        
        let url = URL(string: "https://github.com/\(username.URLEscaped)")!
        let request = URLRequest(url: url)
        return self.URLSession.rx.response(request: request).map { pair in
            return pair.response.statusCode == 404
        }
        .catchAndReturn(false)
        
    }
    
    func signup(_ username: String, _ password: String) -> Observable<Bool> {
        
        let signupResult = arc4random() % 5 == 0 ? false : true
        return Observable.just(signupResult).delay(.seconds(1), scheduler: MainScheduler.instance)
        
    }
    
}


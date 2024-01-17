//
//  GitHubSignupVM.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/15.
//

import Foundation
import RxSwift

/**
 flatMapLatest：
 share(replay：
 combineLatest：
 distinctUntilChanged：
 share：
 startWith：
 */

class GitHubSignupVM {

    let validatedUsername: Observable<ValidationResult>
    let validatedPassword: Observable<ValidationResult>
    let validatedPasswordRepeated: Observable<ValidationResult>
    
    let signupEnabled: Observable<Bool>
    
    let signedIn: Observable<Bool>
    
    let signingIn: Observable<Bool>
    
    init(input: (username: Observable<String>,
                 password: Observable<String>,
                 repeatedPassword: Observable<String>,
                 loginTaps: Observable<Void>),
         dependency: (api: GitHubAPI,
                      validationService: GitHubValidationService,
                      wireframe: Wireframe)) {
        
        validatedUsername = input.username.flatMapLatest { username in
            return dependency.validationService.validateUsername(username)
                .observe(on: MainScheduler.instance)
                .catchAndReturn(.failed("Error contacting server"))
        }.share(replay: 1)
        
        validatedPassword = input.password.map { password in
            return dependency.validationService.validatePassword(password)
        }.share(replay: 1)
            
        validatedPasswordRepeated = Observable.combineLatest(input.password, input.repeatedPassword, resultSelector: dependency.validationService.validateRepeatedPassword).share(replay: 1)
        
        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asObservable()
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { (username: $0, password: $1) }
        
        signedIn = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair in
                return dependency.api.signup(pair.username, pair.password)
                    .observe(on: MainScheduler.instance)
                    .catchAndReturn(false)
                    .trackActivity(signingIn)
            }
            .flatMapLatest { loggedIn -> Observable<Bool> in
                let message = loggedIn ? "Mock: Signed in to GitHub." : "Mock: Sign in to GitHub failed"
                return dependency.wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    .map { _ in
                        loggedIn
                    }
            }
            .share(replay: 1)
        
        signupEnabled = Observable.combineLatest(
            validatedUsername,
            validatedPassword,
            validatedPasswordRepeated,
            signingIn.asObservable()
        ) { username, password, repeatPassword, signingIn in
            username.isValid && password.isValid && repeatPassword.isValid && !signingIn
        }
        .distinctUntilChanged()
        .share(replay: 1)
        
    }
    
}

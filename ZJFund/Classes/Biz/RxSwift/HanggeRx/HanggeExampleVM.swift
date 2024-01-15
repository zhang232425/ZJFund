//
//  HanggeExampleVM.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/12.
//

import RxSwift
import RxCocoa

class HanggeExampleVM {
    
    /// 类型别名
    typealias Input = (username: Driver<String>, password: Driver<String>, repeatedPassword: Driver<String>, loginTaps: Driver<Void>)
    typealias Dependency = (networkService: GitHubNetworkService, signupService: GitHubSignupService)
    
    /// 用户验证结果
    let validatedUsername: Driver<ValidationResult>
    
    /// 密码验证结果
    let validatedPassword: Driver<ValidationResult>
    
    /// 第二次密码验证结果
    let validatedPasswordRepeated: Driver<ValidationResult>
    
    /// 按钮是否可用
    let signupEnabled: Driver<Bool>
    
    /// 注册结果
    let signupResult: Driver<Bool>
    
    init(input: Input, dependency: Dependency) {
        
        /// 用户名验证
        validatedUsername = input.username.flatMapLatest { userName in
            return dependency.signupService.validateUsername(userName).asDriver(onErrorJustReturn: .failed("服务器发生错误!"))
        }
    
        /// 密码验证
        validatedPassword = input.password.map { password in
            return dependency.signupService.validatePassword(password)
        }
        
        /// 第二次密码验证
        validatedPasswordRepeated = Driver.combineLatest(
            input.password,
            input.repeatedPassword,
            resultSelector: dependency.signupService.validateRepeatedPassword)
        
        
        /// 注册按钮是否可用
        signupEnabled = Driver.combineLatest(validatedUsername,
                                             validatedPassword,
                                             validatedPasswordRepeated) {
            $0.isValid && $1.isValid && $2.isValid
        }.distinctUntilChanged()
        
        /// 注册按钮的用户名和密码
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) {
            (username: $0, password: $1)
        }
        
        /// 注册按钮点击结果
        signupResult = input.loginTaps.withLatestFrom(usernameAndPassword).flatMapLatest { pair in
            return dependency.networkService.signup(pair.username, pair.password)
                .asDriver(onErrorJustReturn: false)
        }
        
    }

    
}

enum ValidationResult {
    case empty
    case validating
    case failed(String)
    case success(String)
}

/// 扩展 ValidationResult，对应不同的验证结果返回成功还是失败
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

extension ValidationResult {
    
    var textColor: UIColor {
        switch self {
        case .empty:
            return UIColor.gray
        case .validating:
            return UIColor.black
        case .failed:
            return UIColor.red
        case .success:
            return UIColor(red: 0/255, green: 130/255, blue: 0/255, alpha: 1)
        }
    }
    
}

extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .empty:
            return ""
        case .validating:
            return "正在验证..."
        case .failed(let message):
            return message
        case .success(let message):
            return message
        }
    }
}

class GitHubNetworkService {
    
    // 验证用户是否存在
    func usernameAvailable(_ username: String) -> Observable<Bool> {
        
        // 通过检查这个用户的GitHub主页是否存在来判断用户是否存在
        let url = URL(string: "https://github.com/\(username.URLEscaped)")!
        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request).map { pair in
            return pair.response.statusCode == 404
        }.catchAndReturn(false)
        
    }
    
    // 注册用户
    func signup(_ username: String, _ password: String) -> Observable<Bool> {
        // 模拟这个操作（平均三次有一次失败）
        let sigupResult = arc4random() % 3 == 0 ? false : true
        return .just(sigupResult).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
    
}

extension String {
    
    // 字符串的url地址转义
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
}

class GitHubSignupService {
    
    // 密码最少位数
    let minPasswordCount = 5
    
    // 网络请求服务
    lazy var networkService = {
       return GitHubNetworkService()
    }()
    
    // 验证用户名
    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        
        // 用户名是否为空
        if username.isEmpty {
            return .just(.empty)
        }
        
        // 判断用户名是否只包含数字和字母
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed("用户名只能包含数字和字母"))
        }
        
        // 发起网络请求检查用户名是否存在
        return networkService.usernameAvailable(username)
            .map { available in
                return available ? .success("用户名可用") : .failed("用户名存在")
            }.startWith(.validating) // 在发送网络前，先返回一个"正在检查"的验证结果
        
    }
    
    /// 验证密码
    func validatePassword(_ password: String) -> ValidationResult {
        
        let numberOfCharacters = password.count
        
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minPasswordCount {
            return .failed("密码至少需要\(minPasswordCount)个字符")
        }
        
        return .success("密码有效")
        
    }
    
    /// 验证第二次密码
    func validateRepeatedPassword(_ password: String, _ repeatedPassword: String) -> ValidationResult {
        
        if repeatedPassword.isEmpty {
            return .empty
        }
    
        return repeatedPassword == password ? .success("密码有效") : .failed("两次密码输入不一致")
        
    }
    
    
}

/**
 combineLatest：合并操作符号
 */

//
//  HanggeExampleVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/11.
//

import UIKit

/** MVC架构
 Model - View - Controller 三层架构
 1）
 Model：数据层。负责数据的读写，保存App状态等
 View：显示层。显示页面，用户交互，反馈用户行为
 Controller：业务逻辑层。负责业务逻辑、事件响应、数据加工等
 2）
 通常情况下，Model与View不进行通信，而是由Controller层进行协调
 3)
 优点：分工明确，数据，页面，逻辑分层明确，每一层相对独立
 4）
 缺点：
 Controller代码臃肿
 */

/** MVVM架构
 Model - View - ViewModel：MVC架构的升级
 将Controller中的业务逻辑抽离到ViewModel里面，减轻Controller的负担
 View|Controller - ViewModel - Model
 Model与View|Controller之间不进行通信，由ViewModel层协调
 */


class HanggeExampleVC: BaseVC {
    
    private lazy var input = (
        username: userNameField.rx.text.orEmpty.asDriver(),
        password: passwordField.rx.text.orEmpty.asDriver(),
        repeatedPassword: repeatedPasswordField.rx.text.orEmpty.asDriver(),
        loginBtn.rx.tap.asDriver()
    )
    
    private lazy var dependency = (
        networkService: GitHubNetworkService(),
        signupService: GitHubSignupService()
    )
    
    private lazy var viewModel = HanggeExampleVM(input: input, dependency: dependency)
    
    private lazy var userNameField = UITextField().then {
        $0.placeholder = "用户名"
        $0.borderStyle = .roundedRect
    }

    private lazy var userNameValidationLabel = UILabel()
    
    private lazy var passwordField = UITextField().then {
        $0.placeholder = "密码"
        $0.borderStyle = .roundedRect
    }
    
    private lazy var passwordValidationLabel = UILabel()
    
    private lazy var repeatedPasswordField = UITextField().then {
        $0.placeholder = "确认密码"
        $0.borderStyle = .roundedRect
    }
    
    private lazy var repeatePasswordValidationLabel = UILabel()
    
    private lazy var loginBtn = UIButton(type: .custom).then {
        $0.setTitle("Login", for: .normal)
        $0.backgroundColor = .blue
        $0.isEnabled = false
        $0.alpha = 0.3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindDatas()
    }
    
}

private extension HanggeExampleVC {
    
    func setupViews() {
        
        self.navigationItem.title = "Login"
        
        userNameField.add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview().inset(30.auto)
            $0.left.right.equalToSuperview().inset(20.auto)
            $0.height.equalTo(40.auto)
        }
        
        userNameValidationLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(userNameField.snp.bottom).offset(3.auto)
            $0.left.right.equalTo(userNameField)
        }
        
        passwordField.add(to: view).snp.makeConstraints {
            $0.top.equalTo(userNameValidationLabel.snp.bottom).offset(10.auto)
            $0.left.right.equalTo(userNameValidationLabel)
            $0.height.equalTo(userNameField)
        }
        
        passwordValidationLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(3.auto)
            $0.left.right.equalTo(passwordField)
        }
        
        repeatedPasswordField.add(to: view).snp.makeConstraints {
            $0.top.equalTo(passwordValidationLabel.snp.bottom).offset(10.auto)
            $0.left.right.equalTo(passwordValidationLabel)
            $0.height.equalTo(passwordField)
        }
        
        repeatePasswordValidationLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(repeatedPasswordField.snp.bottom).offset(3.auto)
            $0.left.right.equalTo(repeatedPasswordField)
        }
        
        loginBtn.add(to: view).snp.makeConstraints {
            $0.top.equalTo(repeatePasswordValidationLabel.snp.bottom).offset(30.auto)
            $0.left.right.equalTo(repeatePasswordValidationLabel)
            $0.height.equalTo(40.auto)
        }
        
        
    }
    
    func bindDatas() {
        
        /**
                 //注册结果绑定
                 viewModel.signupResult
                     .drive(onNext: { [unowned self] result in
                         self.showMessage("注册" + (result ? "成功" : "失败") + "!")
                     })
                     .disposed(by: disposeBag)
         */
        
        // 用户名验证结果绑定
        viewModel.validatedUsername
            .drive(userNameValidationLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        // 密码验证结果绑定
        viewModel.validatedPassword
            .drive(passwordValidationLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        // 再次输入密码验证结果绑定
        viewModel.validatedPasswordRepeated
            .drive(repeatePasswordValidationLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        // 按钮是否可用绑定
        viewModel.signupEnabled
            .drive(onNext: { [weak self] valid in
                self?.loginBtn.isEnabled = valid
                self?.loginBtn.alpha = valid ? 1.0 : 0.3
            }).disposed(by: disposeBag)
        
        // 注册结果绑定
        viewModel.signupResult
            .drive(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
    }
    
}


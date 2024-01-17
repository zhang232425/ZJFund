//
//  GitHubSignupVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/15.
//

import UIKit
import RxSwift
import RxCocoa

class GitHubSignupVC: BaseVC {
    
    private var viewModel: GitHubSignupVM!
    
    private lazy var usernameField = UITextField().then {
        $0.placeholder = "请输入用户名"
        $0.borderStyle = .roundedRect
    }
    
    private lazy var usernameValidLabel = UILabel().then {
        $0.textColor = .red
    }
    
    private lazy var passwordField = UITextField().then {
        $0.placeholder = "请输入密码"
        $0.borderStyle = .roundedRect
    }
    
    private lazy var passwordValidLabel = UILabel().then {
        $0.textColor = .red
    }
    
    private lazy var signupBtn = UIButton(type: .custom).then {
        $0.setTitle("Signup", for: .normal)
        $0.backgroundColor = .blue
        $0.alpha = 0.3
        $0.isEnabled = false
    }
    
    private lazy var repeatedPasswordField = UITextField().then {
        $0.placeholder = "请确认密码"
        $0.borderStyle = .roundedRect
    }
    
    private lazy var repeatedPasswordValidLabel = UILabel().then {
        $0.textColor = .red
    }
    
    private lazy var indicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
        bindActions()
    }
    
}

private extension GitHubSignupVC {
    
    func config() {
        
        viewModel = GitHubSignupVM(input: (username: usernameField.rx.text.orEmpty.asObservable(),
                                           password: passwordField.rx.text.orEmpty.asObservable(),
                                           repeatedPassword: repeatedPasswordField.rx.text.orEmpty.asObservable(),
                                           loginTaps: signupBtn.rx.tap.asObservable()),
                                   dependency: (api: GitHubDefaultAPI.sharedAPI,
                                                validationService: GitHubDefaultValidationService.sharedValidationService,
                                                wireframe: DefaultWireframe.shared))
        
    }
    
    func setupViews() {
        
        usernameField.add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(45)
        }
        
        usernameValidLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(usernameField.snp.bottom).offset(10)
            $0.left.right.equalTo(usernameField)
        }
        
        passwordField.add(to: view).snp.makeConstraints {
            $0.top.equalTo(usernameValidLabel.snp.bottom).offset(10)
            $0.left.right.equalTo(usernameValidLabel)
            $0.height.equalTo(45)
        }
        
        passwordValidLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(10)
            $0.left.right.equalTo(passwordField)
        }
        
        repeatedPasswordField.add(to: view).snp.makeConstraints {
            $0.top.equalTo(passwordValidLabel.snp.bottom).offset(10)
            $0.left.right.equalTo(passwordValidLabel)
            $0.height.equalTo(45)
        }
        
        repeatedPasswordValidLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(repeatedPasswordField.snp.bottom).offset(10)
            $0.left.right.equalTo(repeatedPasswordField)
        }
        
        signupBtn.add(to: view).snp.makeConstraints {
            $0.top.equalTo(repeatedPasswordValidLabel.snp.bottom).offset(20)
            $0.left.right.equalTo(repeatedPasswordValidLabel)
            $0.height.equalTo(45)
        }
        
        indicatorView.add(to: signupBtn).snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    func bindActions() {
    
        viewModel.validatedUsername
            .bind(to: usernameValidLabel.rx.validationResult)
            .disposed(by: disposeBag)
    
        viewModel.signedIn.subscribe(onNext: { signedIn in
            print("User signed in \(signedIn)")
        }).disposed(by: disposeBag)
        
        viewModel.validatedPassword
            .bind(to: passwordValidLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.validatedPasswordRepeated
            .bind(to: repeatedPasswordValidLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.signedIn
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.signupEnabled.subscribe(onNext: { [weak self] valid in
            self?.signupBtn.isEnabled = valid
            self?.signupBtn.alpha = valid ? 1.0 : 0.5
        }).disposed(by: disposeBag)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event.subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        view.addGestureRecognizer(tapBackground)
    
    }
    
}

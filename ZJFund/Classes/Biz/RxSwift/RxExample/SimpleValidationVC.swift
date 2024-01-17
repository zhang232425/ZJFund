//
//  SimpleValidationVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/15.
//

import UIKit
import RxSwift
import RxCocoa

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class SimpleValidationVC: BaseVC {
    
    private lazy var usernameHintLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = "Username"
    }
    
    private lazy var usernameField = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    private lazy var usernameValidLabel = UILabel().then {
        $0.textColor = .red
        $0.text = "Username has to be at least \(minimalUsernameLength) characters"
        $0.isHidden = true
    }

    private lazy var passwordHintLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = "Password"
    }
    
    private lazy var passwordField = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    private lazy var passwordValidLabel = UILabel().then {
        $0.textColor = .red
        $0.text = "Password has to be at least \(minimalPasswordLength) characters"
        $0.isHidden = true
    }
    
    private lazy var loginBtn = UIButton(type: .custom).then {
        $0.setTitle("Do someting", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        $0.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindData()
    }

}

private extension SimpleValidationVC {
    
    func setupViews() {
        
        usernameHintLabel.add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        usernameField.add(to: view).snp.makeConstraints {
            $0.top.equalTo(usernameHintLabel.snp.bottom).offset(10)
            $0.left.right.equalTo(usernameHintLabel)
            $0.height.equalTo(45)
        }
        
        usernameValidLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(usernameField.snp.bottom).offset(10)
            $0.left.right.equalTo(usernameField)
        }
        
        passwordHintLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(usernameValidLabel.snp.bottom).offset(10)
            $0.left.right.equalTo(usernameValidLabel)
        }
        
        passwordField.add(to: view).snp.makeConstraints {
            $0.top.equalTo(passwordHintLabel.snp.bottom).offset(10)
            $0.left.right.equalTo(passwordHintLabel)
            $0.height.equalTo(usernameField)
        }
        
        passwordValidLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(10)
            $0.left.right.equalTo(passwordField)
        }
        
        loginBtn.add(to: view).snp.makeConstraints {
            $0.top.equalTo(passwordValidLabel.snp.bottom).offset(20)
            $0.left.right.equalTo(passwordValidLabel)
            $0.height.equalTo(45)
        }
        
    }
    
    func bindData() {
        
        let usernameValid = usernameField.rx.text.orEmpty.map { $0.count >= minimalUsernameLength }.share(replay: 1)
        
        let passwordValid = passwordField.rx.text.orEmpty.map { $0.count >= minimalPasswordLength }
        
        let loginValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
        
//        usernameValid
//            .bind(to: usernameValidLabel.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to: usernameValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
//        passwordValid
//            .bind(to: passwordField.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        loginValid
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginValid.subscribe(onNext: { [weak self] in
            self?.loginBtn.backgroundColor = UIColor.blue.withAlphaComponent($0 ? 1 : 0.3)
        }).disposed(by: disposeBag)
        
        loginBtn.rx.tap.subscribe(onNext: {
            print("相应点击了")
        }).disposed(by: disposeBag)
        
        
    }
    
}

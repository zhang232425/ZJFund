//
//  AlamofireVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/2/2.
//

import UIKit
import Alamofire
import RxCocoa
import RxSwift

class AlamofireVC: BaseVC {
    
    private lazy var startBtn = UIButton(type: .system).then {
        $0.setTitle("开始按钮", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }
    
}

private extension AlamofireVC {
    
    func setupViews() {
        
        startBtn.add(to: view).snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(20)
        }
        
    }
    
    func bindActions() {
        
        startBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.request()
        }).disposed(by: disposeBag)
        
    }
    
}

private extension AlamofireVC {
    
    func request() {
    
    }
    
}

//
//  BaseViewController.swift
//  Pods-ZJFund_Example
//
//  Created by Jercan on 2023/9/9.
//

import UIKit
import Then
import Action
import RxSwift
import RxCocoa
import ZJExtension
import ZJBase
import SnapKit

class BaseVC: ZJViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

}

private extension BaseVC {
    
    func initialize() {
        view.backgroundColor = .white
    }
    
}

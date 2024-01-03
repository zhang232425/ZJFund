//
//  DrawRectContentVC.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/28.
//

import UIKit

class DrawRectContentVC: BaseVC {
    
    private lazy var lineView = ZJLineView()
    
    private lazy var textView = ZJTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

}

private extension DrawRectContentVC {
    
    func setupViews() {
        
//        lineView.add(to: view).snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
        
        textView.add(to: view).snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
        }
        
    }
    
}

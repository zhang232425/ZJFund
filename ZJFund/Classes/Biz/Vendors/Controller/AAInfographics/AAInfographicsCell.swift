//
//  InfographicsCell.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/26.
//

import UIKit

class AAInfographicsCell: BaseListCell {
    
    lazy var numberLabel = UILabel().then {
        $0.backgroundColor = .black
        $0.textColor = .white
        $0.textAlignment = .center
        $0.layer.cornerRadius = 10.auto
        $0.layer.masksToBounds = true
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18)
    }

    override func setupViews() {
        
        numberLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalToSuperview().inset(15.auto)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20.auto)
        }
        
        titleLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalTo(numberLabel.snp.right).offset(10)
            $0.right.equalToSuperview().inset(10.auto)
            $0.top.bottom.equalToSuperview().inset(15.auto)
        }
        
    }
    
}

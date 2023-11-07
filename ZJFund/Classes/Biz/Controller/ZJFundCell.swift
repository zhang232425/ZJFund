//
//  ZJFundCell.swift
//  ZJFund
//
//  Created by Jercan on 2023/11/7.
//

import UIKit

class ZJFundCell: UITableViewCell {
    
    private lazy var titleLabel = UILabel()
    
    private lazy var arrowImgView = UIImageView().then {
        $0.backgroundColor = .red
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ZJFundCell {
    
    func setupViews() {
        
        titleLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalToSuperview().inset(15.auto)
            $0.centerY.equalToSuperview()
        }
        
        arrowImgView.add(to: contentView).snp.makeConstraints {
            $0.right.equalToSuperview().inset(15.auto)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(15)
        }
        
    }
    
}

extension ZJFundCell {
    
    func setRow(_ row: ZJFundViewController.Row) {
        
        titleLabel.text = row.title
        
    }
    
}

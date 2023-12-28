//
//  VendorsCell.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/22.
//

import UIKit

class VendorsCell: BaseListCell {
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont.regular15
    }
    
    private lazy var iconImgView = UIImageView().then {
        $0.backgroundColor = .red
        $0.image = UIImage.dd.named("arrow_icon")
    }

    override func setupViews() {
        
        titleLabel.add(to: contentView).snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(15.auto)
        }
        
        iconImgView.add(to: contentView).snp.makeConstraints {
            $0.right.equalToSuperview().inset(15.auto)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        
    }

}

extension VendorsCell {
    
    func update(with text: String) {
        titleLabel.text = text
    }
    
}

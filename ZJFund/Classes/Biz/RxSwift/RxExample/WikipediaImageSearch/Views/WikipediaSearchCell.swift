//
//  WikipediaSearchCell.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/23.
//

import UIKit

class WikipediaSearchCell: BaseListCell {

    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont.medium15
        $0.textColor = UIColor.blue
    }
    
    private lazy var urlLabel = UILabel().then {
        $0.font = UIFont.regular12
    }
    
    private lazy var imagesView = UICollectionView()

    override func setupViews() {
        
        titleLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalToSuperview().inset(15)
            $0.top.equalToSuperview().inset(20)
        }
        
        urlLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        imagesView.add(to: contentView).snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.equalTo(urlLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
    }

}

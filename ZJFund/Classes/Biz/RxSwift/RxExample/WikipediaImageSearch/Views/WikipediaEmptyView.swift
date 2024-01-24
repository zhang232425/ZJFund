//
//  WikipediaEmptyView.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/23.
//

import UIKit

class WikipediaEmptyView: BaseView {
    
    private lazy var holderLabel = UILabel().then {
        $0.textColor = UIColor.gray
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = "This app transforms Wikipedia into image search engine.\nIt uses Wikipedia search API to find content and scrapes the HTML of those pages for image URLs.\nThis is only showcase app, not intended for production purposes."
    }

    override func setupViews() {
        
        holderLabel.add(to: self).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
}

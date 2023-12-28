//
//  BasicChartVC.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/26.
//

import UIKit
import AAInfographics

class BasicChartVC: BaseVC {
    
    var chartType: AAChartType!
    
    private lazy var chartModel = AAChartModel()
    
    private lazy var chartView = AAChartView().then {
        $0.isScrollEnabled = false
        $0.isClearBackgroundColor = true
        $0.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
    }
    
}

private extension BasicChartVC {
    
    func config() {
        
        self.navigationItem.title = chartType.map { $0.rawValue }
        
    }
    
    func setupViews() {
        
        chartView.add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(200)
        }
        
    }
    
}

extension BasicChartVC: AAChartViewDelegate {
    
    
    
}

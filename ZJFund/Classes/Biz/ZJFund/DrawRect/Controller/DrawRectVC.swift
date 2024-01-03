//
//  DrawRectVC.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/28.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxSwiftExt

/**
 drawRect
 UIBezierPath
 Core Graphics
 */

class DrawRectVC: BaseListVC {

    private lazy var titles = [
        "绘制实线和虚线",
        "绘制文本",
        "绘制图片",
        "绘制圆形图片",
        "绘制圆形",
        "绘制椭圆形",
        "绘制扇形",
        "绘制正方形",
        "绘制矩形",
        "绘制菱形",
        "曲线和弧线",
        "渐变背景颜色"
    ]
    
    private lazy var datas = BehaviorRelay(value: [SectionModel(model: "", items: titles)])
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>!

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
        bindData()
    }
    
}

private extension DrawRectVC {
    
    func config() {
        
        self.navigationItem.title = "DrawRect方法"
        
    }
    
    func setupViews() {
        
        tableView.then {
            $0.registerCell(VendorsCell.self)
        }.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func bindData() {
        
        bindListDataSource()
        
        tableView.rx.modelSelected(String.self).subscribeNext(weak: self, DrawRectVC.rowClick).disposed(by: disposeBag)
        
    }
    
    func bindListDataSource() {
        
        dataSource = .init(configureCell: { (ds, tableView, indexPath, item) in
            
            let cell: VendorsCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.update(with: item)
            return cell
            
        })
        
        datas.observe(on: MainScheduler.instance).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
}

private extension DrawRectVC {
    
    func rowClick(text: String) {
        
        let vc = DrawRectContentVC()
        vc.navigationItem.title = text
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

//
//  SwiftViewController.swift
//  ZJFund
//
//  Created by Jercan on 2023/11/7.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SwiftVC: BaseListVC {
    
    private lazy var titles: [String] = ["泛型(Generics)"]
    
    /**
     private let items = BehaviorRelay<[SectionModel<Void, Row>]>(value: .init())
     private lazy var items = BehaviorRelay(value: [SectionModel(model: "", items: titles)])
     */
    
    private lazy var datas = BehaviorRelay(value: [SectionModel(model: "", items: titles)])
        
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
        bindData()
    }
    
}

private extension SwiftVC {
    
    func config() {
        
        
        
    }
    
    func setupViews() {
        
        self.navigationItem.title = "Swift"
        
        tableView.then {
            $0.registerCell(ZJListCell.self)
        }.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func bindData() {
        
        bindListDataSource()
        
        tableView.rx.modelSelected(String.self).subscribeNext(weak: self, SwiftVC.rowClick).disposed(by: disposeBag)
        
    }
    
    func bindListDataSource() {
        
        dataSource = .init(configureCell: { (ds, tableView, indexPath, item) in
            
            let cell: ZJListCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.update(with: item)
            return cell
            
        })
        
        datas.observe(on: MainScheduler.instance).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }

}

private extension SwiftVC {
    
    func rowClick(text: String) {
        
        switch text {
            
        case "泛型(Generics)":
            let vc = GenericsVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
            
        }
        
    }
    
}

class ZJListCell: BaseListCell {
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont.bold15
    }

    override func setupViews() {
        
        titleLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalToSuperview().inset(15.auto)
            $0.top.bottom.equalToSuperview().inset(15.auto)
        }
    
    }
    
    func update(with text: String) {
        titleLabel.text = text
    }
    
}

//
//  RxSwiftViewController.swift
//  ZJFund
//
//  Created by Jercan on 2023/11/7.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RxSwiftVC: BaseVC {
    
    /**
     private let items = BehaviorRelay<[SectionModel<Void, Row>]>(value: .init())
     private lazy var items = BehaviorRelay(value: [SectionModel(model: "", items: titles)])
     private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>!
     */

    private lazy var rows: [String] = ["Hangge", "RxSwift中文文档", "RxSwift社区", "RxExample"]
    
    private lazy var datas = BehaviorSubject(value: [SectionModel(model: "", items: rows)])
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>!
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.registerCell(ZJListCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindDatas()
    }

}

private extension RxSwiftVC {
    
    func setupViews() {
        
        self.navigationItem.title = "RxSwift"
        
        tableView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func bindDatas() {
        
        tableView.rx.modelSelected(String.self).subscribeNext(weak: self, RxSwiftVC.rowClick).disposed(by: disposeBag)
        
        dataSource = .init(configureCell: { dataSource, tableView, indexPath, item in
            
            let cell: ZJListCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.update(with: item)
            return cell
            
        })
        
        datas.observe(on: MainScheduler.instance).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
    func rowClick(_ text: String) {
        
        switch text {
            
        case "Hangge":
            let vc = HanggeRxVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "RxSwift中文文档":
            break
            
        case "RxSwift社区":
            break
            
        case "RxExample":
            let vc = RxExampleVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
            
        }
        
    }
    
}


//
//  ZJFunctionVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/2/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ZJFunctionVC: BaseVC {
    
    private lazy var datas = BehaviorRelay(value: [SectionModel(model: "", items: ["Animation动画", "Drawing绘画"])])
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>!
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.registerCell(UITableViewCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindDatas()
    }
    
}

private extension ZJFunctionVC {
    
    func setupViews() {
        
        tableView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func bindDatas() {
        
        dataSource = RxTableViewSectionedReloadDataSource(configureCell: { dataSource, tableView, indexPath, element in
            let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.textLabel?.text = "\(element)"
            return cell
        })
        
        datas.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribeNext(weak: self, ZJFunctionVC.rowClick).disposed(by: disposeBag)
        
    }
    
}

private extension ZJFunctionVC {
    
    func rowClick(_ text: String) {
        
        switch text {
            
        case "Animation动画":
            let vc = ZJAnimationVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Drawing绘画":
            let vc = ZJDrawingVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
            
        }
        
    }
    
}

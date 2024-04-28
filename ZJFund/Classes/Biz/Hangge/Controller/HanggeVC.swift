//
//  HanggeVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/2/2.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HanggeVC: BaseVC {
    
    private let datas = BehaviorRelay(value: [SectionModel(model: "", items: ["UIStackView", "ScratchView", "Other"])])
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>!
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.registerCell(UITableViewCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }

}

private extension HanggeVC {
    
    func setupViews() {
        
        self.navigationItem.title = "Hangge"
        
        tableView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func bindActions() {
        
        bindDataSource()
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: { [weak self] in
            self?.rowClick($0)
        }).disposed(by: disposeBag)
        
    }
    
    func bindDataSource() {
        
        dataSource = .init(configureCell: { dataSource, tableView, indexPath, element in
            let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.textLabel?.text = "\(element)"
            return cell
        })
        
        datas.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
}

private extension HanggeVC {
    
    func rowClick(_ text: String) {
        
        switch text {
            
        case "UIStackView":
            let vc = HanggeStackViewVC()
            self.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "ScratchView":
            let vc = HanggeScratchVC()
            self.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Other":
            let vc = HanggeOtherVC()
            self.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
            
        }
        
    }
    
}

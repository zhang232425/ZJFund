//
//  RxExampleVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RxExampleVC: BaseVC {
    
    private let datas = BehaviorRelay(value: [SectionModel(model: "", items: ["Adding numbers", "Simple validation", "GitHubSignup", "WikipediaSearch"])])
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>!
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.registerCell(UITableViewCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindData()
    }

}

private extension RxExampleVC {
    
    func setupViews() {
        
        tableView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func bindData() {
        
        bindListDataSource()
        
        tableView.rx.modelSelected(String.self).subscribeNext(weak: self, RxExampleVC.rowClick).disposed(by: disposeBag)
        
    }
    
    func bindListDataSource() {
        
        dataSource = .init(configureCell: { _, tableView, index, item in
            let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: index)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = item
            return cell
        })
        
        datas.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
}

private extension RxExampleVC {
    
    func rowClick(_ text: String) {
        
        switch text {
            
        case "Adding numbers":
            let vc = AddingNumbersVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Simple validation":
            let vc = SimpleValidationVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "GitHubSignup":
            let vc = GitHubSignupVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "WikipediaSearch":
            let vc = WikipediaSearchVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
            
        }
        
    }
    
}



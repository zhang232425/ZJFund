//
//  ZJFundViewController.swift
//  Pods-ZJFund_Example
//
//  Created by Jercan on 2023/9/9.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import RxSwiftExt

class ZJFundVC: BaseVC {
    
    enum Row {
        
        case swift
        case rxSwift
        case hangge
        case algorithm
        
        var title: String {
            switch self {
            case .swift:
                return "Swift"
            case .rxSwift:
                return "RxSwift"
            case .hangge:
                return "Hangge"
            case .algorithm:
                return "Algorithm"
            }
        }
        
        var vc: UIViewController {
            switch self {
            case .swift:
                return SwiftVC()
            case .rxSwift:
                return RxSwiftVC()
            default:
                return UIViewController()
            }
        }
        
    }

    private let items = BehaviorRelay<[SectionModel<Void, Row>]>(value: .init())
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.registerCell(ZJFundCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
        bindData()
    }

}

private extension ZJFundVC {
    
    func config() {
        
        self.navigationItem.title = "Fund"
        
    }
    
    func setupViews() {
        
        tableView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func bindData() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Void, Row>>(configureCell: { (_, tableView, index, row) in
            let cell: ZJFundCell = tableView.dequeueReuseableCell(forIndexPath: index)
            cell.setRow(row)
            return cell
        })
        
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Row.self)
            .subscribe(weak: self, onNext: ZJFundVC.rowClick)
            .disposed(by: disposeBag)
        
        items.accept([.init(model: (), items: [.swift, .rxSwift, .hangge, .algorithm])])
        
    }
    
    func rowClick(_ row: Row) {
        
        self.navigationController?.pushViewController(row.vc, animated: true)
        
    }
    
    
}


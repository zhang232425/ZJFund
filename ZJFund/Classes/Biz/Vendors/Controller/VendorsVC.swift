//
//  VendorsVC.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class VendorsVC: BaseListVC {
    
    /**
     private let items = BehaviorRelay<[SectionModel<Void, Row>]>(value: .init())
     private lazy var items = BehaviorRelay(value: [SectionModel(model: "", items: titles)])
     */
    
    private lazy var items = ["SwiftDate", "SideMenu", "AAInfographics", "Charts", "FMDB", "SwipeCellKit", "ObjectMapper", "Alamofire", "RxAlamofire", "Moya", "PromiseKit"]
    
    private lazy var datas = BehaviorRelay(value: [SectionModel(model: "", items: items)])
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>!

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupViews()
        bindData()
    }

}

private extension VendorsVC {
    
    func config() {
        self.navigationItem.title = "VendorsVC"
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
        
        tableView.rx.modelSelected(String.self).subscribeNext(weak: self, VendorsVC.listClick).disposed(by: disposeBag)
        
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

private extension VendorsVC {
    
    func listClick(text: String) {
        
        switch text {
            
        case "SwiftDate":
            let vc = SwiftDateVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "SideMenu":
            let vc = SideMenuVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "AAInfographics":
            let vc = AAInfographicsVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Charts":
            let vc = ChartsVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "FMDB":
            let vc = FMDBVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "SwipeCellKit":
            let vc = SwipeVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "ObjectMapper":
            let vc = ObjectMapperVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Alamofire":
            let vc = AlamofireVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "RxAlamofire":
            let vc = RxAlamofireVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Moya":
            let vc = MoyaVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "PromiseKit":
            let vc = PromiseVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
            
        }
        
    }
    
}

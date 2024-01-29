//
//  HanggeRxVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/18.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HanggeRxVC: BaseVC {
    
    private let datas = BehaviorRelay(value: [SectionModel<String, String>]())
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>!
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.registerCell(UITableViewCell.self)
        $0.rowHeight = 45
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindDatas()
        
        /// 监听通知
        let notificationName = Notification.Name(rawValue: "Download.image.success")
        NotificationCenter.default.addObserver(self, selector: #selector(downloadImage), name: notificationName, object: nil)
        
        NotificationCenter.default.rx
            .notification(notificationName)
            .take(until: self.rx.deallocated) // 页面销毁自动移除监听
            .subscribe(onNext: { notification in
                let info = notification.userInfo as! [String: AnyObject]
                let username = info["username"] as! String
                let password = info["password"] as! String
                print("通知内容【\(username) - \(password)】")
            }).disposed(by: disposeBag)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

private extension HanggeRxVC {
    
    func setupViews() {
        
        tableView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func bindDatas() {
        
        bindListDataSource()
        
        tableView.rx.modelSelected(String.self).subscribeNext(weak: self, HanggeRxVC.listClick).disposed(by: disposeBag)
        
        datas.accept([SectionModel(model: "", items: ["Observable（序列）", "Observer（订阅者）", "Subjects", "Operator操作符", "Traits特征序列", "View扩展", "HanggeList", "URLSession+Rx"])])
        
    }
    
    func bindListDataSource() {
        
        dataSource = .init(configureCell: { (dataSource, tableView, indexPath, element) in
            let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = element
            return cell
        })
        
        datas.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }

}

private extension HanggeRxVC {
    
    func listClick(_ text: String) {
        
        switch text {
        case "Observable（序列）":
            let vc = HanggeObservableVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
        case "Observer（订阅者）":
            let vc = HanggeObserverVC()
            vc.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
        case "Subjects":
            let vc = HanggeSubjectsVC()
            self.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
        case "Operator操作符":
            let vc = HanggeOperatorVC()
            self.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
        case "Traits特征序列":
            let vc = HanggeTraitsVC()
            self.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
        case "View扩展":
            let vc = HanggeViewVC()
            self.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
        case "URLSession+Rx":
            let vc = HanggeSessionVC()
            self.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
        case "HanggeList":
            let vc = HanggeListVC()
            self.navigationItem.title = text
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
    
}

private extension HanggeRxVC {

    @objc func downloadImage(_ notification: Notification) {
    
        let info = notification.userInfo as! [String: AnyObject]
        let username = info["username"] as! String
        let password = info["password"] as! String

        print("获取到通知，用户数据 [\(username),\(password)]")
        
    }
    
}

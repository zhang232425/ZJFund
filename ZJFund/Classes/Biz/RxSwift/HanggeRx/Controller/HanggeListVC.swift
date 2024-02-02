//
//  HanggeListVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HanggeListVC: BaseVC {
    
    private let itemWidth = (UIScreen.main.bounds.width - 40.0) / 3.0
    
    private let width = UIScreen.main.bounds.width
    
    private lazy var refreshBtn = UIButton(type: .system).then {
        $0.setTitle("刷新", for: .normal)
    }
    
    private lazy var stopBtn = UIButton(type: .system).then {
        $0.setTitle("停止", for: .normal)
    }
    
    private lazy var searchBar = UISearchBar()
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.registerCell(UITableViewCell.self)
    }
    
    private lazy var layout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: itemWidth, height: itemWidth)
        $0.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        $0.headerReferenceSize = CGSizeMake(200, 40)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout).then {
        $0.registerCell(UICollectionViewCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        headerCollectionList()
    }
    
}

// MARK: - UITableView+Rx
private extension HanggeListVC {
    
    func bindListDatas() {
        
        let datas = Observable.just(["学习", "锻炼", "泡妞"])
        
        datas.bind(to: tableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReuseableCell(forIndexPath: IndexPath(row: row, section: 0))
            cell.textLabel?.text = "\(row): \(element)"
            return cell
        }
        .disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("选中项indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)

        tableView.rx.modelSelected(String.self).subscribe(onNext: { item in
            print("选中项的标题为：\(item)")
        }).disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .bind { indexPath, item in
                print("indexPath ==== \(indexPath)")
                print("item ==== \(item)")
            }
            .disposed(by: disposeBag)
        
    }
    
}

// MARK: - RxDataSources
private extension HanggeListVC {
    
    /**
     RxDataSources 是以 section 来做为数据结构的。所以不管我们的 tableView 是单分区还是多分区，在使用 RxDataSources 的过程中，都需要返回一个 section 的数组
     */
    
    func bindListDataSources() {
        
        let datas = Observable.just([SectionModel(model: "", items: ["学习", "锻炼", "泡妞"])])
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, tableView, indexPath, element) in
            let cell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.textLabel?.text = element
            return cell
        })
        
        datas.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
    // 刷新数据
    func reloadDatas() {
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: refreshBtn), UIBarButtonItem(customView: stopBtn)]
        
        let randomResult = refreshBtn.rx.tap.asObservable()
            .startWith(())
            .flatMapLatest {
                self.getRandomResult().take(until: self.stopBtn.rx.tap)
            }
            .share(replay: 1)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { (dataSource, tableView, indexPath, element) in
            let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.textLabel?.text = "条目\(indexPath.row)：\(element)"
            return cell
        })
        
        randomResult.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }

    func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        let items = (0 ..< 10).map { _ in
            Int(arc4random())
        }
        let observable = Observable.just([SectionModel(model: "", items: items)])
        return observable.delay(.seconds(2), scheduler: MainScheduler.instance)
    }
    
}

// MARK: - 表格数据过滤
private extension HanggeListVC {
    
    func filterActions() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: refreshBtn)
        
        searchBar.add(to: view).snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        tableView.add(to: view).snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
        
        let randomResult = refreshBtn.rx.tap.asObservable()
            .startWith(())
            .flatMapLatest(getRandomResult)
            .flatMap(filterResult)
            .share(replay: 1)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { (dataSource, tableView, indexPath, element) in
            let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.textLabel?.text = "条目\(indexPath.row)：\(element)"
            return cell
        })
        
        randomResult.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
    // 过滤数据
    func filterResult(data: [SectionModel<String, Int>]) -> Observable<[SectionModel<String, Int>]> {
        
        return self.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { query -> Observable<[SectionModel<String, Int>]> in
                if query.isEmpty {
                    return Observable.just(data)
                } else {
                    var newData: [SectionModel<String, Int>] = []
                    for sectionModel in data {
                        let items = sectionModel.items.filter { "\($0)".contains(query) }
                        newData.append(SectionModel(model: sectionModel.model, items: items))
                    }
                    return Observable.just(newData)
                }
            }
        
    }
    
}

// MARK: - 不同类型单元格混用
private extension HanggeListVC {
    
    func differentCell() {
        
        tableView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 数据
        let data = Observable.just([
            SectionModel(model: "第一分区", items: [
                SectionItem.title("张云峰"),
                SectionItem.titleImage("王滕", UIImage())
            ]),
            SectionModel(model: "第二分区", items: [
                SectionItem.titleImage("孙丽雯", UIImage()),
                SectionItem.image(UIImage())
            ])
        ])
        
        // 数据源
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, SectionItem>>(configureCell: { ( dataSource, tableView, indexPath, element) in
            
            switch element {
                
            case .title(let title):
                let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.textLabel?.text = title
                return cell
                
            case .titleImage(let title, _):
                let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.textLabel?.text = title
                return cell
                
            case .image:
                let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
                cell.textLabel?.text = "未知名"
                return cell
                
            }
            
        })
        
        // 数据绑定
        data.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
}

private enum SectionItem {
    case title(String)
    case titleImage(String, UIImage)
    case image(UIImage)
}

// MARK: - UICollectionView+Rx
private extension HanggeListVC {
    
    func collectionList() {
        
        collectionView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 数据
        let datas = Observable.just([
            "王滕",
            "陈铭",
            "龙蓉",
            "黄英",
            "黄渺渺",
            "孙丽雯",
            "周湘"
        ])
        
        // 绑定
        datas.bind(to: collectionView.rx.items) { (collectionView, row, element) in
            let cell: UICollectionViewCell = collectionView.dequeueReuseableCell(forIndexPath: IndexPath(row: row, section: 0))
            cell.contentView.backgroundColor = .red
            return cell
        }.disposed(by: disposeBag)
        
    }
    
    func dataSourceCollectionList() {
        
        collectionView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 数据
        let datas = Observable.just([
            SectionModel(model: "", items: ["王滕", "陈铭", "龙蓉", "黄英", "黄渺渺", "孙丽雯", "周湘"])
        ])
        
        // 数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, collectionView, indexPath, element) in
            let cell: UICollectionViewCell = collectionView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.contentView.backgroundColor = .orange
            return cell
        })
        
        // 绑定
        datas.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
    func headerCollectionList() {
        
        collectionView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 数据
        let datas = Observable.just([
            SectionModel(model: "漂亮", items: ["陈铭", "彭敏", "黄英"]),
            SectionModel(model: "一般", items: ["王滕", "孙丽雯", "龙蓉"])
        ])
        
        // 数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { ( dataSource, collectionView, indexPath, element) in
            let cell: UICollectionViewCell = collectionView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.contentView.backgroundColor = .yellow
            return cell
        }, configureSupplementaryView: { (dataSource, collectionView, kind, element) in
            let header = HeaderView()
//            header.backgroundColor = .black
            return header
        })
        
        // 绑定
        datas.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
}

fileprivate class HeaderView: UICollectionReusableView {
    
    
    
}

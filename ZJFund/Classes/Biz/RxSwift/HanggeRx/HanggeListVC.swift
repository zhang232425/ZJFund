//
//  HanggeListVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/16.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct MySection {
    var header: String
    var items: [Item]
}

extension MySection: AnimatableSectionModelType {
    
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [String]) {
        self = original
        self.items = items
    }
    
}

class HanggeListVC: BaseVC {
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>!
    
    private lazy var loadBtn = UIButton(type: .system).then {
        $0.setTitle("刷新", for: .normal)
    }
    
    private lazy var stopBtn = UIButton(type: .system).then {
        $0.setTitle("停止", for: .normal)
    }

    private lazy var searchBar = UISearchBar()
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.registerCell(UITableViewCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindGroupedListDataSources()
    }

}

private extension HanggeListVC {
    
    func setupViews() {
        
        self.navigationItem.title = "Hangge List"
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: loadBtn), UIBarButtonItem(customView: stopBtn)]
        
//        searchBar.add(to: view).snp.makeConstraints {
//            $0.left.top.right.equalToSuperview()
//            $0.height.equalTo(45)
//        }
        
        tableView.add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.bottom.right.equalToSuperview()
        }
        
    }
    
    func bindListDatas() {
        
        let datas = Observable.just(["张大春", "王滕", "彭敏", "黄英", "龙蓉", "孙丽雯"])
        
        datas.bind(to: tableView.rx.items) { tableView, index, element in
    
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "\(index)：\(element)"
            return cell
            
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("indexPath ==== \(indexPath)")
        }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: { item in
            print("item ==== \(item)")
        }).disposed(by: disposeBag)
        
        /// merge ：合并多个Observable，任何一个序列发出新事件都会输出
        /// zip：合并多个Observable，一一对应之后再一起发出
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self)).subscribe(onNext: { indexPath, item in
            print("zip ==== indexPath ==== \(indexPath)")
            print("zip ==== item ==== \(item)")
        }).disposed(by: disposeBag)
        
        /// 删除
        tableView.rx.itemDeleted.subscribe(onNext: { _ in
            print("删除了")
        }).disposed(by: disposeBag)
        
        /// 移动
//        tableView.rx.itemMoved.subscribe(onNext: { _, _ in
//            print("移动了")
//        })
//
        /// 单元格将要显示
        tableView.rx.willDisplayCell.subscribe(onNext: { cell, indexPath in
            print("cell ==== \(cell)")
            print("indexPath ==== \(indexPath)")
        }).disposed(by: disposeBag)
        
    }

    /** RxDataSources 介绍
     1）如果我们的 tableView 需要显示多个 section、或者更加复杂的编辑功能时，可以借助 RxDataSource 这个第三方库帮我们完成
     2）RxDataSource 的本质就是使用 RxSwift 对 UITableView 和 UICollectionView 的数据源做了一层包装。使用它可以大大减少工作量
     */
    
    /**
     注意：
     RxDataSources 是以 section 来做为数据结构的。所以不管我们的 tableView 是单分区还是多分区，在使用 RxDataSources 的过程中，都需要返回一个 section 的数组
     */
    
    func bindListDataSources() {
        
        // 1.初始化数据
        /*
        let items = Observable.just([
            SectionModel(model: "", items: [
                "张大春",
                "陈铭",
                "王滕",
                "彭敏",
                "黄英",
                "龙蓉",
                "孙丽雯"
            ])
        ])
         */
        
        let items = Observable.just([
            MySection(header: "", items: [
                "张大春",
                "陈铭",
                "王滕",
                "彭敏",
                "黄英",
                "龙蓉",
                "孙丽雯"
            ])
        ])
        
        // 2.创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<MySection>(configureCell: { (dataSource, tableView, indexPath, element) in
            let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "\(indexPath.row)：\(element)"
            return cell
        })
        
        // 3.绑定单元格
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
    func bindGroupedListDataSources() {
        
        // 1.初始化数据
        let items = Observable.just([
            SectionModel(model: "分组一", items: ["张", "王", "李", "赵", "钱", "孙"]),
            SectionModel(model: "分组二", items: ["刘", "郑", "黄", "孙", "周", "吴"]),
            SectionModel(model: "分组三", items: ["冯", "蒋", "韩", "杨", "何", "朱"])
        ])
        
        // 2.创建数据源
        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, tableView, indexPath, item) in
            let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.textLabel?.text = "\(indexPath.row + 1) --- \(item)"
            return cell
        })
        
        //
        /**
         //设置分区头标题
                 dataSource.titleForHeaderInSection = { ds, index in
                     return ds.sectionModels[index].model
                 }
         */
        
//        dataSource.titleForHeaderInSection = { dataSource, index in
//            return dataSource.sectionModels[index].model
//        }
        
        // 3.绑定数据
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }
    
    func bindLoadDataSources() {
        
        /**
         throttle：在主线程中操作，1秒内值若多次改变，取最后一次
         startWith：开始时自动请求一次数据
         flatMapLatest：可请求多次，但是只取最后一次
         .flatMap(filterResult) //筛选数据
         */
        let randomResult = loadBtn.rx.tap.asObservable()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .startWith(())
            .flatMapLatest {
                self.getRandomResult().take(until: self.stopBtn.rx.tap)
            }
            .flatMap(filterResult)
            .share(replay: 1)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { (dataSource, tableView, indexPath, element) in
            let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
            cell.textLabel?.text = "条目\(indexPath.row)：\(element)"
            return cell
        })
        
        randomResult.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
}

private extension HanggeListVC {
    
    /**
     arc4random：产生一个十位数的随机数
     arc4random % 100 + 1 (包含0到100的随机数)
     */
    func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        
        let items = (0 ..< 30).map { _ in
            Int(arc4random() % 1000) + 1
        }
        
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(.seconds(1), scheduler: MainScheduler.instance)
        
    }

    func filterResult(_ data: [SectionModel<String, Int>]) -> Observable<[SectionModel<String, Int>]> {
        
        return self.searchBar.rx.text.orEmpty.flatMapLatest { query -> Observable<[SectionModel<String, Int>]> in
            
            print("正在筛选数据（条件为：\(query)）")
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

extension HanggeListVC: UITableViewDelegate {
    
    //返回分区头部视图
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int)
            -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.black
            let titleLabel = UILabel()
            titleLabel.text = self.dataSource?[section].model
            titleLabel.textColor = UIColor.white
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint(x: self.view.frame.width/2, y: 20)
            headerView.addSubview(titleLabel)
            return headerView
        }
         
        //返回分区头部高度
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int)
            -> CGFloat {
            return 40
        }
    
}

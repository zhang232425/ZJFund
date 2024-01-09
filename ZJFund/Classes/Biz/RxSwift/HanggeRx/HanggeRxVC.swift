//
//  HanggeRxVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/8.
//

import UIKit
import RxSwift


/*

class HanggeRxVC: BaseVC {
    
    private let viewModel = MusicListVM()
    
    private lazy var tableView = UITableView().then {
        $0.registerCell(UITableViewCell.self)
//        $0.dataSource = self
//        $0.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
}

private extension HanggeRxVC {
    
    func setupViews() {
        
        tableView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func bindViewModel() {
        
        // 将数据绑定到tableView上
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "UITableViewCell")) { _, music, cell in
            cell.textLabel?.text = music.name
            cell.detailTextLabel?.text = music.singer
        }.disposed(by: disposeBag)
        
        // 点击响应
        tableView.rx.modelSelected(Music.self).subscribe(onNext: { music in
            print("你选中的歌曲信息【\(music)】")
        }).disposed(by: disposeBag)
        
    }
    
    
}

/*
extension HanggeRxVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
        let music = viewModel.data[indexPath.row]
        cell.textLabel?.text = music.name
        cell.detailTextLabel?.text = music.singer
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("你选中的歌曲信息【\(viewModel.data[indexPath.row])】")
    }
    
}
 */

fileprivate struct Music {

    /// 歌名
    let name: String
    /// 演唱者
    let singer: String
    
    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
    
}

extension Music: CustomStringConvertible {
    
    var description: String {
        return "name：\(name) singer：\(singer)"
    }
    
}

fileprivate struct MusicListVM {
    
    /*
    let data = [
        Music(name: "海阔天空", singer: "黄家驹"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "心如刀割", singer: "张学友"),
        Music(name: "在木星", singer: "朴树")
    ]
     */
    
    let data = Observable.just([
        Music(name: "海阔天空", singer: "黄家驹"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "心如刀割", singer: "张学友"),
        Music(name: "在木星", singer: "朴树")
    ])
    
}
*/

/**
 Observable<T>：可观察序列
 Observer：订阅者（观察者）
 Event事件：
 case next(Element)
 case error(Swift.Error)
 case completed
 */

class HanggeRxVC: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
}

private extension HanggeRxVC {
    
    func setupViews() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(testClick))
        
    }
    
    @objc func testClick() {
        
        test1()
        
    }
    
}

private extension HanggeRxVC {
    
    /**
     创建Observable序列
     */
    func test1() {
        
        let observable = Observable.of("a", "b", "c")
        
        observable.subscribe { event in
            print(event)
        }
        
    }
    
}

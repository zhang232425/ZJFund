//
//  RxAlamofireVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/2/2.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire

class RxAlamofireVC: BaseVC {
    
    private lazy var startBtn = UIButton(type: .system).then {
        $0.setTitle("开始请求", for: .normal)
    }
    
    private lazy var stopBtn = UIButton(type: .system).then {
        $0.setTitle("取消请求", for: .normal)
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.registerCell(UITableViewCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupViews()
//        bindActions()
//        model1()
//        model2()
        model3()
    }

}

private extension RxAlamofireVC {
    
    func setupViews() {
        
        startBtn.add(to: view).snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(20)
        }
        
        stopBtn.add(to: view).snp.makeConstraints {
            $0.left.equalTo(startBtn.snp.right).offset(30)
            $0.centerY.equalTo(startBtn)
        }
        
    }
    
    func bindActions() {
        
//        startBtn.rx.tap.subscribe(onNext: { [weak self] in
//            self?.test2()
//        }).disposed(by: disposeBag)
        
        let url = URL(string: "https://www.douban.com/j/app/radio/channels")!
        
        startBtn.rx.tap.asObservable()
            .flatMap {
                request(.get, url).responseString().take(until: self.stopBtn.rx.tap)
            }
            .subscribe(onNext: { response, data in
                print("请求成功！返回的数据是：", data)
            }, onError: { error in
                print("请求失败", error)
            }).disposed(by: disposeBag)
        
        
    }
    
}

private extension RxAlamofireVC {
    
    /// 1.使用request请求数据
    func test1() {
        
        let url = URL(string: "https://www.douban.com/j/app/radio/channels")!
        
        request(.get, url)
            .data()
            .subscribe(onNext: { data in
                let string = String(data: data, encoding: .utf8)
                print("请求到的数据：", string ?? "")
            }, onError: { error in
                print("请求失败原因：", error)
            }).disposed(by: disposeBag)
    
    }
    
    /// 2.使用requestData请求数据
    func test2() {
        
        let url = URL(string: "https://www.douban.com/j/app/radio/channels")!
        
        requestData(.get, url)
            .subscribe(onNext: { response, data in
//                print("code = ", response.statusCode)
//                let string = String(data: data, encoding: .utf8)
//                print("请求到的数据：", string ?? "")
                
                if 200 ..< 300 ~= response.statusCode {
                    let string = String(data: data, encoding: .utf8)
                    print("请求到的数据：", string ?? "")
                } else {
                    print("请求失败")
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    /// 3. requestString, responseString
    
}

/// 转json对象，转自定义数据模型
private extension RxAlamofireVC {
    
    func model1() {
        
        tableView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let url = URL(string: "https://www.douban.com/j/app/radio/channels")!
        
        // 获取数据
        let data = requestJSON(.get, url)
            .map { response, data -> [[String: Any]] in
                if let json = data as? [String: Any], let channels = json["channels"] as? [[String: Any]] {
                    print("json ==== \(json)")
                    print("channels ==== \(channels)")
                    return channels
                } else {
                    return []
                }
            }
        
        // 将数据绑定到表格
        data.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: IndexPath(row: row, section: 0))
            cell.textLabel?.text = "\(row)：\(element["name"]!)"
            return cell
        }.disposed(by: disposeBag)
        
        
    }
    
    func model2() {
        
        let url = URL(string: "https://www.douban.com/j/app/radio/channels")!
        
        requestJSON(.get, url)
            .map { $1 }
            .mapObject(Douban.self)
            .subscribe(onNext: { douban in
                if let channels = douban.channels {
                    print("--- 共\(channels.count)个频道 ---")
                    for channel in channels {
                        if let name = channel.name, let channelId = channel.channelId {
                            print("\(name) id:\(channelId)")
                        }
                    }
                }
            }).disposed(by: disposeBag)
    
    }
    
    func model3() {
        
        tableView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let url = URL(string: "https://www.douban.com/j/app/radio/channels")!
        
        // 获取列表数据
        let data = requestJSON(.get, url)
            .map { $1 }
            .mapObject(Douban.self)
            .map { $0.channels ?? [] }
        
        // 将数据绑定到表格
        data.bind(to: tableView.rx.items) { tableView, row, element in
            let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: IndexPath(row: row, section: 0))
            cell.textLabel?.text = "\(row)：\(element.name!)"
            return cell
        }.disposed(by: disposeBag)
        
    }
    
}

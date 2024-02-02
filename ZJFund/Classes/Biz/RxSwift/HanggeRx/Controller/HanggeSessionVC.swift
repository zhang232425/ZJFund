//
//  HanggeSessionVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import Reachability

class HanggeSessionVC: BaseVC {
    
    private lazy var startBtn = UIButton(type: .system).then {
        $0.setTitle("开始请求", for: .normal)
    }
    
    private lazy var stopBtn = UIButton(type: .system).then {
        $0.setTitle("结束请求", for: .normal)
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.registerCell(UITableViewCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }

}

private extension HanggeSessionVC {
    
    func setupViews() {
        
        startBtn.add(to: view).snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(20)
        }
//
//        stopBtn.add(to: view).snp.makeConstraints {
//            $0.left.equalTo(startBtn.snp.right).offset(30)
//            $0.centerY.equalTo(startBtn)
//        }
        
//        tableView.add(to: view).snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
        
    }
    
    func bindActions() {
        
        /*
        let url = URL(string: "https://www.douban.com/j/app/radio/channels")!
        
        let request = URLRequest(url: url)
        
        // 发起请求
        startBtn.rx.tap.asObservable()
            .flatMap {
                URLSession.shared.rx.data(request: request)
                    .take(until: self.stopBtn.rx.tap)
            }
            .subscribe(onNext: { data in
                let string = String(data: data, encoding: String.Encoding.utf8)
                print("请求成功：", string ?? "")
            }, onError: { error in
                print("请求失败！", error)
            }).disposed(by: disposeBag)
         */
        
        startBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.objectMapper()
        }).disposed(by: disposeBag)
        
    }
    
}

// MARK: - 网络请求
private extension HanggeSessionVC {
    
    // 1.原始使用
    func session() {
        
        let request = URLRequest(url: URL(string: "https://www.douban.com/j/app/radio/channels")!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {
                let jsonString = String(data: data!, encoding: String.Encoding.utf8)
                print("请求数据 ==== ", jsonString ?? "")
            }
        }.resume()
        
    }
    
    // 2.通过rx.response请求数据
    func session1() {
    
        /*
        // 创建url对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)!
        
        // 创建请求对象
        let request = URLRequest(url: url)
        
        // 发起请求
        URLSession.shared.rx.response(request: request).subscribe(onNext: { (response, data) in
            let string = String(data: data, encoding: String.Encoding.utf8)
            print("返回的数据是：", string ?? "")
        }).disposed(by: disposeBag)
         */
        
        let url = URL(string: "https://www.douban.com/xxxxxxxxxx/app/radio/channels")!
        
        let request = URLRequest(url: url)
        
        URLSession.shared.rx.response(request: request).subscribe(onNext: { (response, data) in
            // 判断响应状态码
            if 200 ..< 300 ~= response.statusCode {
                let string = String(data: data, encoding: String.Encoding.utf8)
                print("请求成功！返回的数据是：", string ?? "")
            } else {
                print("请求失败！")
            }
        }).disposed(by: disposeBag)
        
    }
    
    // 3.通过rx.data请求数据
    func session2() {
    
        let url = URL(string: "https://www.douban.com/j/app/radio/channels")!
        
        let request = URLRequest(url: url)
        
        URLSession.shared.rx.data(request: request).subscribe(onNext: { data in
            let string = String(data: data, encoding: String.Encoding.utf8)
            print("请求成功！返回的数据是：", string ?? "")
        }).disposed(by: disposeBag)
        
    }
    
    
    
}

// MARK: - 将请求结果转化成JSON对象
private extension HanggeSessionVC {
    
    func jsonObject1() {
        
        let url = URL(string: "https://www.douban.com/j/app/radio/channels")!
        
        let request = URLRequest(url: url)
        
        URLSession.shared.rx.data(request: request).subscribe(onNext: { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            print("--- 请求成功！返回的如下数据 ---")
            print(json!)
        }).disposed(by: disposeBag)
        
    }
    
    func jsonObject2() {
        
        let url = URL(string: "https://www.douban.com/j/app/radio/channels")!
        
        let request = URLRequest(url: url)
        
        URLSession.shared.rx.json(request: request).subscribe(onNext: { data in
            let json = data as! [String: Any]
            print("氢气数据 ==== \(json)")
        }).disposed(by: disposeBag)
        
    }
    
}

// MARK: - 转模型，绑定tableView
private extension HanggeSessionVC {
    
    func test1() {
        
        /**
         //创建URL对象
                 let urlString = "https://www.douban.com/j/app/radio/channels"
                 let url = URL(string:urlString)
                 //创建请求对象
                 let request = URLRequest(url: url!)
         
         //获取列表数据
                 let data = URLSession.shared.rx.json(request: request)
                     .map{ result -> [[String: Any]] in
                         if let data = result as? [String: Any],
                             let channels = data["channels"] as? [[String: Any]] {
                                 return channels
                         }else{
                                 return []
                         }
                 }
                  
                 //将数据绑定到表格
                 data.bind(to: tableView.rx.items) { (tableView, row, element) in
                     let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                     cell.textLabel?.text = "\(row)：\(element["name"]!)"
                     return cell
                 }.disposed(by: disposeBag)
         */
        
        let url = URL(string: "https://www.douban.com/j/app/radio/channels")!
        let request = URLRequest(url: url)
        
        let data = URLSession.shared.rx.json(request: request).map { result -> [[String: Any]] in
            if let data = result as? [String: Any], let channels = data["channels"] as? [[String: Any]] {
                return channels
            } else {
                return []
            }
        }
        
        data.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: IndexPath(row: row, section: 0))
            cell.textLabel?.text = "\(row)：\(element["name"]!)"
            return cell
        }.disposed(by: disposeBag)
        
    }
    
}

// MARK: - ObjectMapper转数据模型
private extension HanggeSessionVC {
    
    func objectMapper() {
        
        tableView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        /*
        let url = URL(string: "https://www.douban.com/j/app/radio/channels")!
        let request = URLRequest(url: url)
        
        URLSession.shared.rx.json(request: request)
            .mapObject(Douban.self)
            .subscribe(onNext: { douban in
                if let channels = douban.channels {
                    print("--- 共\(channels.count)个频道 ---")
                    for channel in channels {
                        if let name = channel.name, let channelId = channel.channelId {
                            print("\(name) (id:\(channelId)")
                        }
                    }
                }
            }).disposed(by: disposeBag)
         */
        
        // 获取数据 -> 转化模型 -> 绑定list
        
        let url = URL(string: "https://www.douban.com/j/app/radio/channels")!
        let request = URLRequest(url: url)
        
        let data = URLSession.shared.rx.json(request: request)
            .mapObject(Douban.self)
            .map { $0.channels ?? [] }
        
        data.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: IndexPath(row: row, section: 0))
            cell.textLabel?.text = "\(row)：\(element.name!)"
            return cell
        }.disposed(by: disposeBag)
        
    }
    
}

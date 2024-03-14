//
//  PromiseFoundationVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/3/12.
//

import UIKit
import RxSwift
import RxCocoa
import PromiseKit

class PromiseFoundationVC: BaseVC {
    
    @objc dynamic var message = "hangge.com"
    
    @objc private lazy var tableView = UITableView()
    
    private lazy var testBtn = UIButton(type: .system).then {
        $0.setTitle("开始测试", for: .normal)
    }
    
    private lazy var textField = UITextField().then {
        $0.placeholder = "请输入"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
        observeMessage()
    }

}

private extension PromiseFoundationVC {
    
    func setupViews() {
        
        self.navigationItem.title = "Promise Foundation"
        
        testBtn.add(to: view).snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(50)
        }
        
        textField.add(to: view).snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(50)
            $0.top.equalTo(testBtn.snp.bottom).offset(30)
        }
    
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.alamofire1()
        }).disposed(by: disposeBag)
        
    }
    
    func session() {
        
        // 1.请求数据
        /**
        self.dataTask()
         */
        
        // 2.请求数据返回对象
        /**
        fetchData(args: "foo=bar")
            .done { data in
                print("--- 请求数据 ---")
                print(data)
            }.catch { error in
                print("--- 请求失败 ---")
                print(error)
            }
         */
        
        // 3.使用 Download Task 下载文件
        /**
        self.sessionSimpleDownload()
        */
        
        // 4.使用 Upload Task 来上传文件
        self.sessionUpload()
        
    }
    
    func notification() {
        
        self.keyboard()
        
    }
    
    func kvo() {
        kvoExtension()
    }

}

// MARK: - URLSession的扩展
private extension PromiseFoundationVC {
    
    /// 1、Data Task 请求数据
    func dataTask() {
        let url = URL(string: "https://httpbin.org/get?foo=bar")!
        let request = URLRequest(url: url)
        let _ = URLSession.shared.dataTask(.promise, with: request)
            .validate() // 这个是PromiseKit提供的扩展方法，比如自动将 404 转成错误
            .done { data, response in
                let string = String(data: data, encoding: .utf8)
                print("--- 请求结果如下 ---")
                print(string ?? "")
            }
    }
    
    func fetchData(args: String) -> Promise<Any> {
        let url = URL(string: "https://httpbin.org/get?\(args)")!
        let request = URLRequest(url: url)
        return URLSession.shared.dataTask(.promise, with: request)
            .validate()
            .map {
                try JSONDecoder().decode(HttpBin.self, from: $0.data)
            }
    }
    
    struct HttpBin: Codable {
        var origin: String
        var url: String
    }
    
    func sessionSimpleDownload() {
        let url = URL(string: "http://hangge.com/blog/images/logo.png")!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let savePath = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/1.png")
        let _ = session.downloadTask(.promise, with: request, to: savePath)
            .done { saveLocation, response in
                print("下载成功！保存地址如下：")
                print(savePath)
            }.catch { error in
                print("下载失败！错误信息如下：")
                print(error.localizedDescription)
            }
    }
    
    func sessionUpload() {
        let url = URL(string: "http://hangge.com/upload.php")!
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = "POST"
        let session = URLSession.shared
        // 上传数据流
        let documents = NSHomeDirectory() + "/Documents/1.png"
        let imgData = try! Data(contentsOf: URL(fileURLWithPath: documents))
        // 上传任务
        let _ = session.uploadTask(.promise, with: request, from: imgData)
            .done { data, response in
                print("上传成功！")
            }.catch { error in
                print("下载失败！错误信息如下：")
                print(error.localizedDescription)
            }
    }
    
    
}

// MARK: - NotificationCenter的扩展
private extension PromiseFoundationVC {
    
    /** 注意
     通知响应后，PromiseKit会自动将相应的通知注册给取消，也就是说每个监听通知都是一次性的，为了让通知反复多次监听，这里在响应后继续调用方法进行观察
     */
    func beginObserve() {
        
        // 监听程序进入后台的通知
        NotificationCenter.default.observe(once: NSNotification.Name.UIApplicationDidEnterBackground).done { notification in
            print("程序已经进入后台")
            self.beginObserve()
        }

    }
    
    func keyboard() {
        
        /**
         //监听键盘弹出通知
         NotificationCenter.default.observe(once:
             UIResponder.keyboardWillShowNotification).done { notification in
                 print("键盘出现了")
         }
          
         //监听键盘隐藏通知
         NotificationCenter.default.observe(once:
             UIResponder.keyboardWillHideNotification).done { notification in
                 print("键盘消失了")
         }
         */
        
        // 监听键盘弹出
        NotificationCenter.default.observe(once: NSNotification.Name.UIKeyboardDidShow).done { notification in
            print("键盘出现了")
        }
        
        NotificationCenter.default.observe(once: NSNotification.Name.UIKeyboardDidHide).done { notification in
            print("键盘消失了")
        }
        
    }
    
    func customNotification() {
        
        let _ = [CustomObserver(name: "张云峰"), CustomObserver(name: "王滕")]
        
        print("发送通知")
        let notificationName = Notification.Name(rawValue: "DownloadImageNotification")
        NotificationCenter.default.post(name: notificationName, object: self, userInfo: ["value1": "hangge.com", "value2": "123456"])
        print("通知发送完毕")
        
    }
    
}

fileprivate class CustomObserver: NSObject {
    
    var name: String = ""
    
    init(name: String) {
        super.init()
        self.name = name
        beginObserve()
    }
    
    func beginObserve() {
        let notificationName = Notification.Name(rawValue: "DownloadImageNotification")
        NotificationCenter.default.observe(once: notificationName).done { notification in
            let userInfo = notification.userInfo as! [String: AnyObject]
            let value1 = userInfo["value1"] as! String
            let value2 = userInfo["value2"] as! String
            print("\(self.name) 获取到通知，用户数据是 [\(value1),\(value2)]")
            sleep(3)
            print("\(self.name) 执行完毕")
            // 继续观察
            self.beginObserve()
        }
    }
    
}

// MARK: - KVO扩展
private extension PromiseFoundationVC {
    
    func kvoExtension() {
    
        // 监听基本属性
        // 定时器（1秒执行一次）
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PromiseFoundationVC.changeMessage), userInfo: nil, repeats: true)
        observeMessage()
        
    }
        
    @objc func changeMessage() {
        self.message.append("!")
    }
    
    func observeMessage() {
        self.observe(.promise, keyPath: #keyPath(PromiseFoundationVC.message)).done { value in
            print(value ?? "")
            self.observeMessage()
        }
    }
    
    // 监听view.frame变化
    func observeViewFrame() {
        self.observe(.promise, keyPath: #keyPath(view.frame)).done { frame in
            print("--- 视图尺寸变化了 ---")
            print(frame!)
            self.observeViewFrame()
        }
    }
    
    // 监听tableView.contentOffset变化
    func observeTableViewContentOffset() {
        self.observe(.promise, keyPath: #keyPath(tableView.contentOffset)).done { oldOffset in
            var delta = self.tableView.contentOffset.y / CGFloat(64) + 1
            delta = CGFloat.maximum(delta, 0)
            self.view.alpha = CGFloat.minimum(delta, 1)
            self.observeTableViewContentOffset()
        }
    }
    
}

// MARK: - Alamofire扩展
private extension PromiseFoundationVC {
    
    // 基本用法
    func alamofire1() {
        
//        let _ = Alamofire.request("https://httpbin.org/get", parameters: ["foo": "bar"])
//            .responseString()
//            .done { string, response in
//                print(" --- 请求结果 ---")
//                print(string)
//            }.catch { error in
//                print("--- 请求失败 ---")
//                print(error)
//            }
        
    }
    
}

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
import Alamofire
import CoreLocation

class PromiseFoundationVC: BaseVC {
    
    @objc dynamic var message = "hangge.com"
    
    @objc private lazy var tableView = UITableView()
    
    private lazy var testBtn = UIButton(type: .system).then {
        $0.setTitle("开始测试", for: .normal)
    }
    
    private lazy var textField = UITextField().then {
        $0.placeholder = "请输入"
    }
    
    private lazy var block = UIView().then {
        $0.backgroundColor = .red
        $0.alpha = 0
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
        
        block.frame = CGRect(x: 0, y: 300, width: 40, height: 40)
        self.view.addSubview(block)
    
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.gecoder2()
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
            
        let _ = AF.request("https://httpbin.org/get", parameters: ["foo": "bar"])
            .responseString()
            .done { string, response in
                print("--- 请求结果 ---")
                print(string)
            }.catch { error in
                print("--- 请求失败 ---")
                print(error)
            }
        
        let _ = AF.request("https://httpbin.org/get", parameters: ["foo": "bar"])
            .responseData()
            .done { data, response in
                if let string = String(data: data, encoding: .utf8) {
                    print(string)
                }
            }.catch { error in
                print(error)
            }
        
    }
    
    // 自动解析json数据
    func alamofire2() {
        
        let _ = AF.request("https://httpbin.org/get", parameters: ["foo": "bar"])
            .responseDecodable(HttpBin.self)
            .done { httpBin in
                print("url：", httpBin.url)
                print("origin：", httpBin.origin)
            }.catch { error in
                print(error)
            }
        
    }
    
    // 结合when多个请求
    func alamofire3() {
        
        when(fulfilled: fetchData(parameters: ["foo": "bar"]),
                        fetchData(parameters: ["name": "hangge"]))
        .done { str1, str2 in
            print(str1)
            print(str2)
        }.catch { error in
            print(error)
        }
        
    }
    
    // 请求数据
    func fetchData(parameters: [String: String]) -> Promise<String> {
        return AF.request("https://httpbin.org/get", parameters: parameters)
            .responseString()
            .map { $0.string }
    }
    
    // 结合 ensure() 方法隐藏活动指示器
    /**
     ensure 与 finally 比较：
     相同点在于：它们都是不管前面是成功（fulfilled）还是失败（rejected）都会被执行
     不同点在于：ensure 是链式的，后面可以继续跟其他的操作，而 finally 不是
     */
    func alamofire4() {
    
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let _ = AF.request("https://httpbin.org/get", parameters: ["foo": "bar"])
            .responseString()
            .ensure {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            .done { string, response in
                print(string)
            }.catch { error in
                print(error)
            }
        
    }
    
}

// 请求结果
fileprivate struct HttpBin: Codable {
    var origin: String
    var url: String
}

// MARK: - 动画的扩展
private extension PromiseFoundationVC {
    
    func animation1() {
        
        UIView.animate(.promise, duration: 1, delay: 0.4, options: [.curveEaseOut]) {
            self.block.frame.origin.x = self.view.bounds.width - self.block.frame.width
            self.block.alpha = 1
        }.done { success in
            print("动画结束")
        }
        
    }
    
}

// MARK: - 位置信息扩展
private extension PromiseFoundationVC {
    
    func location1() {
        
        // 获取当前的定位信息
        let _ = CLLocationManager.requestLocation().done { locations in
            // 获取最新的坐标
            let currLocation: CLLocation = locations.last!
            print("经度：", currLocation.coordinate.longitude)
            print("纬度：", currLocation.coordinate.latitude)
            print("海拔：", currLocation.altitude)
            print("水平精度：", currLocation.horizontalAccuracy)
            print("垂直精度：", currLocation.verticalAccuracy)
            print("方向：", currLocation.course)
            print("速度：", currLocation.speed)
        }
            
        let _ = CLLocationManager.requestLocation(authorizationType: .automatic) { loaction -> Bool in
            // 只有等到水平精度小于50的时候才返回结果
            return loaction.horizontalAccuracy < 50 ? true : false
        }.done { locations in
            let currLocation: CLLocation = locations.last!
            print("经度：", currLocation.coordinate.longitude)
            print("纬度：", currLocation.coordinate.latitude)
            print("海拔：", currLocation.altitude)
            print("水平精度：", currLocation.horizontalAccuracy)
            print("垂直精度：", currLocation.verticalAccuracy)
            print("方向：", currLocation.course)
            print("速度：", currLocation.speed)
        }
        
    }
    
}

// MARK: - CLGecoder 的扩展
private extension PromiseFoundationVC {
    
    /// 根据经纬度输出地址信息
    func gecoder1() {
        
        // 根据经纬度获取地址信息
        let currentLocation = CLLocation(latitude: 22.53291, longitude: 113.93029)
        CLGeocoder().reverseGeocode(location: currentLocation)
            .done { placemarks in
                // 强制转成中文
                let array = NSArray(object: "zh-hans")
                UserDefaults.standard.set(array, forKey: "AppleLanguages")
                // 显示所有信息
                let p = placemarks[0]
                print(p)
                if let country = p.country {
                    print("国家：", country)
                }
                if let administrativeArea = p.administrativeArea {
                    print("省份：", administrativeArea)
                }
                if let subAdministrativeArea = p.subAdministrativeArea {
                    print("行政区（自治区）：", subAdministrativeArea)
                }
                if let locality = p.locality {
                    print("城市：", locality)
                }
                if let subLocaity = p.subLocality {
                    print("区划：", subLocaity)
                }
                if let thoroughfare = p.thoroughfare {
                    print("街道：", thoroughfare)
                }
                if let subThoroughfare = p.subThoroughfare {
                    print("门牌：", subThoroughfare)
                }
                if let name = p.name {
                    print("地名：", name)
                }
                if let isoCountryCode = p.isoCountryCode {
                    print("国家编码：", isoCountryCode)
                }
                if let postalCode = p.postalCode {
                    print("邮编：", postalCode)
                }
            }.catch { error in
                print(error)
            }
        
    }
    
    /// 根据地址输出经纬度
    func gecoder2() {
        
        CLGeocoder().geocode("深圳市龙华区深圳北站")
            .done { placemarks in
                let p = placemarks[0]
                print("经度 longitude：", p.location!.coordinate.longitude)
                print("纬度 latitude：", p.location!.coordinate.latitude)
            }.catch { error in
                print(error)
            }
        
        
    }
    
}

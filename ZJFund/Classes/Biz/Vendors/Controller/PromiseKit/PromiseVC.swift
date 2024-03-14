//
//  PromiseVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/3/8.
//

import UIKit
import RxCocoa
import RxSwift
import PromiseKit

class PromiseVC: BaseVC {
    
    private lazy var testBtn = UIButton(type: .system).then {
        $0.setTitle("开始测试", for: .normal)
    }
    
    private lazy var foundationBtn = UIButton(type: .system).then {
        $0.setTitle("Foundation", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }
    
}

private extension PromiseVC {
    
    func setupViews() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: foundationBtn)
        
        testBtn.add(to: view).snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(30)
        }
        
    }
    
    func bindActions() {
        
        foundationBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.foundationClick()
        }).disposed(by: disposeBag)
        
        testBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.sessionUpload()
        }).disposed(by: disposeBag)
        
    }
    
    func foundationClick() {
        
        let vc = PromiseFoundationVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

/// 备注
/***
 1、then()、done() 方法：
 2、catch() 方法：
 3、finally() 方法：
 4、map()、compactMap() 方法：
 5、get()、tap() 方法：
 6、when() 方法：
 7、race() 方法：
 8、Guarantee：
 9、after() 方法：
 */

private extension PromiseVC {
    
    func promise() {
        
        // 1.then()、done()方法
        /*
         let _ = cook()
         .then { data -> Promise<String> in
         return self.eat(data: data)
         }.then { data -> Promise<String> in
         return self.wash(data: data)
         }.done { data in
         print(data)
         }
         */
        
        // 简写
        /*
         _ = cook()
         .then(eat)
         .then(wash)
         .done { data in
         print(data)
         }
         */
        
        // 2.catch()方法
        /*
         _ = cook()
         .then(eat)
         .then(wash)
         .done { data in
         print(data)
         }.catch { error in
         print(error.localizedDescription + "没发吃！")
         }
         */
        
        // 3.finally方法：不管是执行完then还是catch，最终都会走finally
        /*
         let _ = cook()
         .then(eat)
         .done { data in
         print(data)
         }.catch { error in
         print(error.localizedDescription + "没法吃！")
         }.finally {
         print("出门上班")
         }
         */
        
        // 4.map()、compactMap()：
        /**
         then() 方法要求输入一个 promise 值并返回一个 promise，而 map() 是根据先前 promise 的结果，然后返回一个新的对象或值类型
         compactMap() 与 map() 类似，不过它是返回 Optional。比如我们返回 nil，则整个链会产生 PMKError.compactMap 错误
         */
        
        /*
         let _ = cook()
         .map { data -> String in
         return data + "，配上一碗汤"
         }.then(eat)
         .done { data in
         print(data)
         }
         */
        
        // 5. get()，tap() 方法
        /**
         如果想要在链路中获取值用于其他操作，比如输出调试，那么可以使用 get()、tap() 这两个方法，它们都不会影响到原有链路逻辑
         1）get() 只有在前面是完成状态（fulfilled）时才会调用，它得到的是具体结果对象
         2）tap() 方法是不管前面是完成（fulfilled）还是失败（rejected）都会调用，同时它得到的是 Result<T>：
         */
        
        /*
         let _ = cook()
         .get { data in
         print("---> \(data)")
         }
         .then(eat)
         .then(wash)
         .done { data in
         print(data)
         }
         */
        
        /*
         let _ = cook()
         .tap { result in
         print("---> \(result)")
         }
         .then(eat)
         .done { data in
         print(data)
         }.catch { error in
         print(error.localizedDescription + "没法吃！")
         }
         */
        
        // 6.when() 方法
        /**
         when 方法提供了并行执行异步操作的能力，并且只有在所有的异步操作执行完成后才执行回调
         和其他的 promise 链一样，when 方法中任一异步操作发生错误，都会进入到下一个 catch 方法中
         */
        
        /*
         let _ = when(fulfilled: cutup(), boil())
         .done { cut, boil in
         print("结果：\(cut)、\(boil)")
         }
         */
        
        // 7. race方法：赛跑 只要有异步完成就执行then
        /*
         let _ = race(cutup(), boil())
         .done { data in
         print(data)
         }
         */
        
        // 8.Guarantee
        /**
         guarantee 是 promise 的变种、或者补充，其用法和 promise 一样，大多数情况下二者可以相互替换使用
         与 promise 状态可以是成功失败不同， Guarantee 要确保永不失败，因此语法更简单些
         */
        
        // 9.after()方法：延时调用
        after(.seconds(3)).done {
            print("准备好，我的人生刚刚开始......")
        }
        
    }
    
}


////////// ----------- Promise example ----------

private extension PromiseVC {
    
    // 做饭
    func cook() -> Promise<String> {
        print("开始做饭...")
        let p = Promise<String> { resolver in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("做饭完毕！")
                resolver.fulfill("小炒黄牛肉")
        
//                let error = NSError(domain: "PromiseKitTutorial", code: 0, userInfo: [NSLocalizedDescriptionKey: "烧焦的米饭"])
//                resolver.reject(error)
                
            }
        }
        return p
    }
    
    // 吃饭
    func eat(data: String) -> Promise<String> {
        print("开始吃饭：" + data)
        let p = Promise<String> { resolver in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("吃饭完毕！")
                resolver.fulfill("一个碗和一双筷子")
            }
        }
        return p
    }
    
    // 洗碗
    func wash(data: String) -> Promise<String> {
        print("开始洗碗：" + data)
        let p = Promise<String> { resolver in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("洗碗完毕！")
                resolver.fulfill("干净的碗筷")
            }
        }
        return p
    }
    
    // 切菜
    func cutup() -> Promise<String> {
        print("开始切菜...")
        let p = Promise<String> { resolver in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("切菜完毕！")
                resolver.fulfill("切好的菜")
            }
        }
        return p
    }
    
    func boil() -> Promise<String> {
        print("开始烧水...")
        let p = Promise<String> { resolver in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("烧水完毕！")
                resolver.fulfill("烧好的水")
            }
        }
        return p
    }
    
    
}

////////// ----------- URLSession的扩展 ----------

private extension PromiseVC {
    
    func fetchData() {
        
        /*
        let url = URL(string: "https://httpbin.org/get?foo=bar")!
        let request = URLRequest(url: url)
        
        let _ = URLSession.shared.dataTask(.promise, with: request)
            .validate() // 这个也是PromiseKit提供的扩展方法，比如自动将 404 转成错误
            .done { data, response in
                let string = String(data: data, encoding: .utf8)
                print("--- 请求结果如下 ---")
                print(string ?? "")
            }
         */
        
        /*
        fetchData(args: "foo=bar")
            .done { data in
                print("--- 请求结果 ---")
                print(data)
            }.catch { error in
                print("--- 请求失败 ---")
                print(error)
            }
         */
        
        // 多个请求
        when(fulfilled: fetchData(args: "foo=bar"), fetchData(args: "name=hangge"))
            .done { data1, data2 in
                print("---- 请求结果1 ----")
                print(data1)
                print("---- 请求结果2 ----")
                print(data2)
            }.catch { error in
                print("---- 请求失败 ----")
                print(error)
            }
        
        // 使用Download Task 来下载文件
        
        
    }
    
    func fetchData(args: String) -> Promise<Any> {
        let string = "https://httpbin.org/get?\(args)"
        let url = URL(string: string)!
        let request = URLRequest(url: url)
        return URLSession.shared.dataTask(.promise, with: request)
            .validate()
            .map {
                try JSONDecoder().decode(HttpBin.self, from: $0.data)
            }
    }
    
    // 下载文件
    /**
     func sessionSimpleDownload(){
         //下载地址
         let url = URL(string: "http://hangge.com/blog/images/logo.png")
         //请求
         let request = URLRequest(url: url!)
          
         let session = URLSession.shared
          
         //文件保存路径
         let savePath = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/1.png")
          
         //下载任务
         _ = session.downloadTask(.promise, with: request, to: savePath)
             .done { saveLocation, response in
                 print("下载成功!保存地址如下：")
                 print(saveLocation)
             }.catch { error in
                 print("下载失败!错误信息如下：")
                 print(error.localizedDescription)
             }
     }
     */
    
    func sessionSimpleDownload() {
        let url = URL(string: "http://hangge.com/blog/images/logo.png")!
        let request = URLRequest(url: url)
        let session  = URLSession.shared
        // 文件保存路径
        let savePath = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/1.png")
        // 下载任务
        let _ = session.downloadTask(.promise, with: request, to: savePath)
            .done { saveLocation, response in
                print("下载成功！保存地址如下：")
                print(saveLocation)
            }.catch { error in
                print("下载失败！错误信息如下：")
                print(error.localizedDescription)
            }
    }
    
    // 使用uploadTask来上传文件
    func sessionUpload() {
        let url = URL(string: "http://hangge.com/upload.php")!
        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
        request.httpMethod = "POST"
        let session = URLSession.shared
        // 上传数据流
        let documents = NSHomeDirectory() + "/Documents/1.png"
        let imageData = try! Data(contentsOf: URL(fileURLWithPath: documents))
        // 上传任务
        let _ = session.uploadTask(.promise, with: request, from: imageData)
            .done { data, response in
                print("上传成功！")
            }.catch { error in
                print("下载失败！错误信息如下：")
                print(error.localizedDescription)
            }
    }
    
}

fileprivate struct HttpBin: Codable {
    var origin: String
    var url: String
}

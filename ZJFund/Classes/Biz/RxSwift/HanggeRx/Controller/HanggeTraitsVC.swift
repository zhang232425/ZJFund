//
//  HanggeTraitsVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/22.
//

import UIKit
import RxSwift
import RxCocoa

class HanggeTraitsVC: BaseVC {
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont.bold16
        $0.textColor = .red
        $0.text = "特征序列Traits：特定性质的Observable"
    }
    
    private lazy var desLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "Single：\nCompletable：\nMaybe：\nDriver：\nControlEvent"
    }
    
    private lazy var testBtn = UIButton(type: .custom).then {
        $0.setTitle("Test", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }

}

private extension HanggeTraitsVC {
    
    func setupViews() {
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: testBtn)
        
        titleLabel.add(to: view).snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(15)
        }
        
        desLabel.add(to: view).snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.single()
        }).disposed(by: disposeBag)
        
    }
    
}


/// 一、Single：只发出一个元素或者error，主要用于网络请求，返回一个应答或者错误，提供 SingleEvent
/**
 enum SingleEvent<Element> {
    case success(Element)
    case error(Swift.Error)
 }
 observable.asSingle()
 */
private extension HanggeTraitsVC {
    
    enum DataError: Error {
        case cantParseJSON
    }

    func single() {
        
        /*
        getPlaylist("0")
            .subscribe { event in
                switch event {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
         */
        
        getPlaylist("0")
            .subscribe(onSuccess: { json in
                print(json)
            }, onFailure: { error in
                print(error)
            }).disposed(by: disposeBag)
        
    }

    func getPlaylist(_ channel: String) -> Single<[String: Any]> {
        return Single<[String: Any]>.create { single in
            let url = "https://douban.fm/j/mine/playlist?" + "type=n&channel=\(channel)&from=mainsite"
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
                if let error = error {
                    single(.failure(error))
                }
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                        let result = json as? [String: Any] else {
                    single(.failure(DataError.cantParseJSON))
                    return
                }
                
                single(.success(result))
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
    
}

/// 二、Completable：只产生一个completed事件或者一个error，应用缓存数据只关心成功失败

/// 三、Maybe：要不发出一个元素，要么发出一个completed，要不发出一个error (只发出一个)

/**：重点：这个算是RxCocoa Traits
 Driver：UI层的操作，一定是在主线程
 ControlProperty：是专门用于描述 UI 属性
 ControlEvent：是专门用于描述 UI 所产生的事件
 */



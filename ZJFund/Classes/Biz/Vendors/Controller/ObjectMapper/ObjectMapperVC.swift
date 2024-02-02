//
//  ObjectMapperVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/30.
//

import UIKit
import RxCocoa
import RxSwift
import ObjectMapper

class ObjectMapperVC: BaseVC {
    
    private lazy var testBtn = UIButton(type: .system).then {
        $0.setTitle("测试按钮", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindActions()
    }

}

private extension ObjectMapperVC {
    
    func setupViews() {
        
        testBtn.add(to: view).snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(30)
        }
        
    }
    
    func bindActions() {
        
        testBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.test5()
        }).disposed(by: disposeBag)
        
    }
    
}

// MARK: - Mappable协议
private extension ObjectMapperVC {
    
    /// 模型 <-> 字典
    func test() {
        
        let wang = User()
        wang.username = "王滕"
        wang.age = 21
        
        let chen = User()
        chen.username = "陈铭"
        wang.age = 21
        
        let peng = User()
        peng.username = "彭敏"
        peng.age = 25
        peng.weight = 90.3
        
        /**
         let meimeiDic:[String: Any] = meimei.toJSON()
         print(meimeiDic)
         */
        
        let dict1 = wang.toJSON()
        let dict2 = chen.toJSON()
        
        print("dict1 = \(dict1)")
        print("dict2 = \(dict2)")
        
        let users = [wang, chen, peng]
        let usersDict = users.toJSON()
        
        print("usersDict = \(users)")
        
    }
    
    /// 字典 <-> 模型
    func test1() {
        
        let dict: [String: Any] = ["age": 21, "username": "王滕", "best_friend": ["age": 34, "username": "张云峰"]]
        let user = User(JSON: dict)
        print("user ==== \(user!)")
        
        
        let userArray = [
            ["age": 21, "username": "王滕"],
            ["age": 22, "username": "陈铭"],
            ["age": 27, "username": "龙蓉"]
        ]
        
        // Mapper<User>().mapArray(JSONArray: usersArray)
        let models: [User] = Mapper<User>().mapArray(JSONArray: userArray)
        
        print("models ==== \(models)")
        
    }
    
    /// 模型 <-> JSON字符串
    func test2() {
        
        let zhang = User()
        zhang.username = "张云峰"
        zhang.age = 34
        zhang.weight = 77.0
        
        let wang = User()
        wang.username = "王滕"
        wang.age = 21
        wang.weight = 90.0
        wang.bestFriend = zhang
        
        let userString = wang.toJSONString()
        
        if let str = userString {
            print("str === \(str)")
            
            /// JSON -> 模型
            let model = Mapper<User>().map(JSONString: str)
            print("model ==== \(model)")
            
        }
    
    }
    
    func test3() {
        
        let json = "[{\"age\":18,\"username\":\"王滕\"},{\"age\":21}]"
        let users:[User] = Mapper<User>().mapArray(JSONString: json)!
        print(users.count)
        
    }
    
}

// MARK: - StaticMappable
private extension ObjectMapperVC {
    
    func test4() {
        
        let json = [["type": "car", "name": "奇瑞QQ"],
                    ["type": "bus", "fee": 2],
                    ["type": "vehicle"]]
          
        let vehicles = Mapper<Vehicle>().mapArray(JSONArray: json)
        print("交通工具数量：\(vehicles.count)")
        
        if let car = vehicles[0] as? Car {
            print("小汽车名字：\(car.name!)")
        }
        
        if let bus = vehicles[1] as? Bus {
            print("公交车费用：\(bus.fee!) 元")
        }
        
    }
    
}

// MARK: - ObjectMapper的高级用法
private extension ObjectMapperVC {
    
    // 1.嵌套对象的映射
    func test5() {
        
        let json: [String: Any] = [
            "type": "s1",
            "distance": [
                ["text": "120 ft", "value": 31],
                ["text": "110 ft", "value": 21]
            ]
        ]
        
        let result = DistanceResult(JSON: json)
        
        guard let model = result, let type = model.type else { return }
        print("model.type = \(type)")
        
        guard let distance = model.distance, let text = distance.text, let value = distance.value else { return }
        print("model.distance = \(distance)")
        print("model.distance.text = \(text)")
        print("model.distance.value = \(value)")
        
        
    }
    
}

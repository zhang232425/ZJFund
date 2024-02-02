//
//  User.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/30.
//

import Foundation
import ObjectMapper

// MARK: - 模型定义
class User: Mappable {

    var username: String?
    var age: Int?
    var weight: Double!
    var bestFriend: User?
    var friends: [User]?
    var birthday: Date?
    var array: [AnyObject]?
    var dictionary: [String: AnyObject] = [:]
    
    init() {}
    
    required init?(map: Map) {
        // 检查JSON中是否有"username"属性
        if map.JSON["username"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        
        username   <- map["username"]
        age        <- map["age"]
        weight     <- map["wight"]
        bestFriend <- map["best_friend"]
        friends    <- map["friends"]
        birthday   <- (map["birthday"], DateTransform())
        array      <- map["arr"]
        dictionary <- map["dict"]
    
    }
    
}


// MARK: - StaticMappable
class Vehicle: StaticMappable {
    
    var type: String?
    
    init() {}
    
    class func objectForMapping(map: Map) -> BaseMappable? {
            if let type: String = map["type"].value() {
                switch type {
                case "car":
                    return Car()
                case "bus":
                    return Bus()
                default:
                    return Vehicle()
                }
            }
            return nil
        }
    
    func mapping(map: Map) {
        type <- map["type"]
    }

}

class Car: Vehicle {
    var name: String?
    override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
    }
}

class Bus: Vehicle {
    var fee: Int?
    override func mapping(map: Map) {
        super.mapping(map: map)
        fee <- map["fee"]
    }
}

// MARK: - 嵌套解析
class DistanceResult: Mappable {
    
    var type: String?
    
    var distance: Distance?
    
    /// 校验必须属性
    required init?(map: Map) {
        if map.JSON["type"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        distance <- map["distance.1"]
    }
    
}

class Distance: Mappable {
    
    var text: String?
    
    var value: Int?
    
    // 校验必须属性
    required init?(map: Map) {
        if map.JSON["text"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        text <- map["text"]
        value <- map["value"]
    }
    
}

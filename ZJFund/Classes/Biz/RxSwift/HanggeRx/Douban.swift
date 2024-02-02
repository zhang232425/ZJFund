//
//  Douban.swift
//  ZJFund
//
//  Created by Jercan on 2024/2/1.
//

import ObjectMapper

class Douban: Mappable {

    var channels: [Channel]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        channels <- map["channels"]
    }
    
}

class Channel: Mappable {
    
    var name: String?
    var nameEn: String?
    var channelId: String?
    var seqId: Int?
    var abbrEn: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name      <- map["name"]
        nameEn    <- map["name_en"]
        channelId <- map["channel_id"]
        seqId     <- map["seq_id"]
        abbrEn    <- map["abbr_en"]
    }
    
}

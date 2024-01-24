//
//  WikipediaPage.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/23.
//

import Foundation
import RxSwift

struct WikipediaPage {
    
    /**
     throws：https://www.jianshu.com/p/7a16d0721a2f
     as as? as!
     Any AnyObject
     */
    
    let title: String
    let text: String
    
    /// throws用在方法声明处，表示本方法不处理异常
    static func parseJSON(_ json: NSDictionary) throws -> WikipediaPage {
        
        guard let parse = json.value(forKey: "parse"),
              let title = (parse as AnyObject).value(forKey: "title") as? String,
              let t = (parse as AnyObject).value(forKey: "text"),
              let text = (t as AnyObject).value(forKey: "*") as? String else {
            throw apiError("Error parsing page content")
        }
        
        return WikipediaPage(title: title, text: text)
        
    }
    
}

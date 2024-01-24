//
//  WikipediaSearchResult.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/23.
//

import Foundation
import RxSwift

struct WikipediaSearchResult: CustomDebugStringConvertible {
    
    let title: String
    let description: String
    let URL: URL

    static func parseJOSN(_ json: [AnyObject]) throws -> [WikipediaSearchResult] {
        
        let rootArrayType = json.compactMap { $0 as? [AnyObject] }
        
        guard rootArrayType.count == 3 else {
            throw WikipediaParseError
        }
        
        let (titles, decsriptions, urls) = (rootArrayType[0], rootArrayType[1], rootArrayType[2])
        
        let titleDescriptionAndUrl: [((AnyObject, AnyObject), AnyObject)] = Array(zip(zip(titles, decsriptions), urls))
        
        return try titleDescriptionAndUrl.map { result -> WikipediaSearchResult in
            
            let ((title, description), url) = result
            
            guard let titleString = title as? String,
                  let descriptionString = description as? String,
                  let urlString = url as? String,
                  let URL = Foundation.URL(string: urlString) else {
                throw WikipediaParseError
            }
            
            return WikipediaSearchResult(title: titleString, description: descriptionString, URL: URL)
        }
        
    }
    
    
}

extension WikipediaSearchResult {
    var debugDescription: String {
        "[\(title)](\(URL)"
    }
}

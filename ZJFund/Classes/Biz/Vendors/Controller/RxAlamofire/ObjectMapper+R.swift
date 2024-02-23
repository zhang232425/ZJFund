//
//  ObjectMapper+Rx.swift
//  ZJFund
//
//  Created by Jercan on 2024/2/22.
//

import ObjectMapper
import RxSwift

enum RxObjectMapperError: Error {
    case parsingError
}

extension Observable where Element: Any {
    
    // 将JSON数据转成对象
    func mapObjc<T>(_ type: T.Type) -> Observable<T> where T: Mappable {
        
        let mapper = Mapper<T>()
        
        return self.map { element -> T in
            guard let parsedElement = mapper.map(JSONObject: element) else {
                throw RxObjectMapperError.parsingError
            }
            
            return parsedElement
        }
        
    }
    
    // 将JSON数据转成数组
    func mapArr<T>(_ type: T.Type) -> Observable<[T]> where T: Mappable {
        
        let mapper = Mapper<T>()
        
        return self.map { element -> [T] in
            guard let parsedArray = mapper.mapArray(JSONObject: element) else {
                throw RxObjectMapperError.parsingError
            }
            
            return parsedArray
        }
        
    }
    
}

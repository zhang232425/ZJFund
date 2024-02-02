//
//  ObjectMapper+Rx.swift
//  ZJFund
//
//  Created by Jercan on 2024/2/1.
//

import RxSwift
import ObjectMapper

enum ObjectMapperError: Error {
    case parsingError
}

extension Observable where Element: Any {
    
    // MARK: - 将JSON -> Model
    func mapObject<T>(_ type: T.Type) -> Observable<T> where T: Mappable {
        let mapper = Mapper<T>()
        return self.map { element -> T in
            guard let parsedElement = mapper.map(JSONObject: element) else {
                throw ObjectMapperError.parsingError
            }
            return parsedElement
        }
    }
    
    // MARK: - JSON -> [Model]
    func mapArray<T>(_ type: T.Type) -> Observable<[T]> where T: Mappable {
        let mapper = Mapper<T>()
        return self.map { element in
            guard let parsedArray = mapper.mapArray(JSONObject: element) else {
                throw ObjectMapperError.parsingError
            }
            return parsedArray
        }
    }
    
}

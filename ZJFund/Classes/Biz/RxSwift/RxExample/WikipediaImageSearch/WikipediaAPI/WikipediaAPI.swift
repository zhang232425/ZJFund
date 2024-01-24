//
//  WikipediaAPI.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/23.
//

import Foundation
import RxSwift

func apiError(_ error: String) -> NSError {
    return NSError(domain: "WikipediaAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: error])
}

public let WikipediaParseError = apiError("Error during parsing")

protocol WikipediaAPI {
    func getSearchResults(_ query: String) -> Observable<[WikipediaSearchResult]>
    func articleContent(_ searchResult: WikipediaSearchResult) -> Observable<WikipediaPage>
}

class DefaultWikipediaAPI: WikipediaAPI {
    
    private let bag = DisposeBag()
    
    static let sharedAPI = DefaultWikipediaAPI()
    
    let `$`: Dependencies = Dependencies.sharedDependencies
    
    let loadingWikipediaData = ActivityIndicator()
    
    private init() {}
    
    private func JSON(_ url: URL) -> Observable<Any> {
//        return `$`.URLSession.rx.json(url: url).trackActivity(loadingWikipediaData)
        return URLSession.shared.rx.json(url: url).trackActivity(loadingWikipediaData)
    }
    
    func getSearchResults(_ query: String) -> RxSwift.Observable<[WikipediaSearchResult]> {
        
        /**
         let escapedQuery = query.URLEscaped
         let urlContent = "http://en.wikipedia.org/w/api.php?action=opensearch&search=\(escapedQuery)"
         let url = URL(string: urlContent)!
             
         return JSON(url)
             .observe(on:`$`.backgroundWorkScheduler)
             .map { json in
                 guard let json = json as? [AnyObject] else {
                     throw exampleError("Parsing error")
                 }
                 
                 return try WikipediaSearchResult.parseJSON(json)
             }
             .observe(on:`$`.mainScheduler)
         */
        
        let escapedQuery = query.URLEscaped
        let urlContent = "http://en.wikipedia.org/w/api.php?action=opensearch&search=\(escapedQuery)"
        let url = URL(string: urlContent)!
        
        let request = URLRequest(url: url)
        
        URLSession.shared.rx.response(request: request).subscribe { event in
            print("event ==== ", event)
        }.disposed(by: bag)
        
        return JSON(url)
            .map { json in
                print(json)
                guard let json = json as? [AnyObject] else {
                    throw exampleError("Parsing error")
                }
                print("请求数据 === \(json)")
                return try WikipediaSearchResult.parseJOSN(json)
            }
        
    }
    
    func articleContent(_ searchResult: WikipediaSearchResult) -> RxSwift.Observable<WikipediaPage> {
        
        /**
         let escapedPage = searchResult.title.URLEscaped
         guard let url = URL(string: "http://en.wikipedia.org/w/api.php?action=parse&page=\(escapedPage)&format=json") else {
             return Observable.error(apiError("Can't create url"))
         }
         
         return JSON(url)
             .map { jsonResult in
                 guard let json = jsonResult as? NSDictionary else {
                     throw exampleError("Parsing error")
                 }
                 
                 return try WikipediaPage.parseJSON(json)
             }
             .observe(on:`$`.mainScheduler)
         */
        
        let escapedPage = searchResult.title.URLEscaped
        guard let url = URL(string: "http://en.wikipedia.org/w/api.php?action=parse&page=\(escapedPage)&format=json") else {
            return Observable.error(apiError("Can't create url"))
        }
        return JSON(url).map { jsonResult in
            guard let json = jsonResult as? NSDictionary else {
                throw exampleError("Parsing error")
            }
            return try WikipediaPage.parseJSON(json)
        }
        
    }
    
    
    
    
}

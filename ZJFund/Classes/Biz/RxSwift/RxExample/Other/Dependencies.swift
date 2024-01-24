//
//  Dependencies.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/24.
//

import Foundation
import RxSwift

func exampleError(_ error: String, location: String = "\(#file):\(#line)") -> NSError {
    return NSError(domain: "ExampleError", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(location): \(error)"])
}

class Dependencies {
    
    /**
     static let sharedDependencies = Dependencies() // Singleton
     
     let URLSession = Foundation.URLSession.shared
     let backgroundWorkScheduler: ImmediateSchedulerType
     let mainScheduler: SerialDispatchQueueScheduler
     let wireframe: Wireframe
     let reachabilityService: ReachabilityService
     
     private init() {
         wireframe = DefaultWireframe()
         
         let operationQueue = OperationQueue()
         operationQueue.maxConcurrentOperationCount = 2
         operationQueue.qualityOfService = QualityOfService.userInitiated
         backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)
         
         mainScheduler = MainScheduler.instance
         reachabilityService = try! DefaultReachabilityService() // try! is only for simplicity sake
     }
     
     */
    
    static let sharedDependencies = Dependencies()
    
    let URLSession = Foundation.URLSession.shared
    
    
}

//
//  URLSessionHelper.swift
//  LCFramework
//
//  Created by Luc CASIMIR on 09/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

public protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

open class URLSessionStub : URLSessionProtocol {
    
    private let task : URLSessionDataTaskHelper
    
    let data : Data?
    let reponse : URLResponse?
    let apiError : Error?
        
    public init(Data:Data?=nil, Reponse:URLResponse?=nil, Error:Error?=nil, Delay:Int=0) {
        self.data = Data
        self.reponse = Reponse
        self.apiError = Error
        self.task = URLSessionDataTaskHelper(Data: Data, Reponse: Reponse, APIError: Error, Delay: Delay)
    }
    
    public func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.task.completion = completionHandler
        return self.task
    }
    
    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.task.completion = completionHandler
        return self.task
    }
    
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    private final class URLSessionDataTaskHelper: URLSessionDataTask {
    
        let data : Data?
        let reponse : URLResponse?
        let apiError : Error?
        
        var completion : CompletionHandler?
        let delayQueue = DispatchQueue(label: "Stub Task")
        let delay : Int
        
        var randomDelay : Int {
            return Int(arc4random_uniform(UInt32(self.delay)))
        }
        
        init(Data:Data?=nil, Reponse:URLResponse?=nil, APIError:Error?=nil, Delay:Int=10) {
            self.data = Data
            self.reponse = Reponse
            self.apiError = APIError
            self.delay = Delay
        }
        
        override func resume() {
            
            self.delayQueue.asyncAfter(deadline: .now() + .milliseconds(randomDelay)) {
                self.completion?(self.data, self.reponse, self.apiError)
            }
            
        }
    }
    
}

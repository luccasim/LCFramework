//
//  SequenceLoader.swift
//  LCFramework
//
//  Created by owee on 28/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

// TODO: Develop a class for manager download sequence (order, delay, page)
protocol SequenceLoaderInterface {
    
    func listTask(
        Option:SequenceLoader.Option,
        List:[URLRequest],
        Completion:@escaping ((Result<(URLRequest, Data),Error>) -> Void),
        OnFinish:@escaping ((Int) -> Void)
    )
}

final class SequenceLoader {
    
    public var session : URLSession
    
    public init(Session:URLSession = URLSession.shared) {
        self.session = Session
    }
    
    enum APIErrors : Error {
        case requestIsAlreadyTask
    }
    
    public enum Option {
        case Simultaneous
        case Order
        case Group(Page:Int)
        case Delay(Page:Int,Interval:TimeInterval)
    }

    public func listTask(Option:SequenceLoader.Option = .Order, List:[URLRequest], Completion:@escaping ((Result<(URLRequest, Data),Error>) -> Void), OnFinish:@escaping ((Int) -> Void)) {
        
        switch Option {
        case .Simultaneous:
            self.listTask(Limit: 0, Time: 0, List: List, Completion: Completion, OnFinish: OnFinish)
        case .Order:
            self.listTask(Limit: 1, Time: 0, List: List, Completion: Completion, OnFinish: OnFinish)
        case .Group(Page: let limit):
            self.listTask(Limit: limit, Time: 0, List: List, Completion: Completion, OnFinish: OnFinish)
        case .Delay(Page: let limit, Interval: let time):
            self.listTask(Limit: limit, Time: time, List: List, Completion: Completion, OnFinish: OnFinish)
        }
    }
    
    private let listQueue = DispatchQueue(label: "List Queue")
    private let group = DispatchGroup()
    private(set) var isProcess = false
    
    private func listTask(Limit:Int, Time:TimeInterval, List:[URLRequest], Completion:@escaping ((Result<(URLRequest, Data),Error>) -> Void), OnFinish:@escaping ((Int) -> Void)) {
                
        self.listQueue.async {
            
            guard !self.isProcess else {
                print("[\(type(of: self))] : Is already download sequence.")
                return OnFinish(0)
            }
            
            self.isProcess = true
            
            let limit = Limit == 0 ? List.count : Limit
            
            // Remove duplicates
            var dict = [URLRequest:Bool]()
            var list = List.filter({dict.updateValue(true, forKey: $0) == nil})
            
            var success = 0
                        
            while (!list.isEmpty) {
                
                let page = (0..<limit).compactMap { _ in
                    return list.isEmpty ? nil : list.removeFirst()
                }
                                
                if Time > 0 {
                    
                    let timer = DispatchQueue.init(label: "Timer \(list.count)")
                    
                    timer.async {
                        print("[\(type(of: self))] : Time start : \(Date())")
                        self.group.enter()
                    }
                    
                    timer.asyncAfter(deadline: .now() + Time) {
                        print("[\(type(of: self))] : Time end: \(Date())")
                        self.group.leave()
                    }
                }
                
                page.forEach { (request) in
                    
                    self.group.enter()
                    
                    DispatchQueue.init(label: "\(request)").async {
                        
                        self.dataTask(Request: request) { (res) in
                            
                            switch res {
                            case .success(let data):
                                success += 1
                                Completion(.success((request, data)))
                            case .failure(let error):
                                Completion(.failure(error))
                            }
                            
                            self.group.leave()
                        }
                    }
                }
                
                self.group.wait()
            }
            
            self.group.notify(queue: .main) {
                self.isProcess = false
                OnFinish(success)
                print("[\(type(of: self))] : Finish with \(success) success.")
            }
        }
    }
    
    private var requests = Set<URLRequest>()
    private var requestQueue = DispatchQueue(label: "Download Queue")
    
    public func dataTask(Request: URLRequest, Completion: @escaping ((Result<Data, Error>) -> Void)) {
        
        self.requestQueue.async {
                        
            guard !self.requests.contains(Request) else {
                return Completion(.failure(APIErrors.requestIsAlreadyTask))
            }
            
            self.session.dataTask(with: Request) { [weak self] (Data, Rep, Error) in
                
                if let error = Error {
                    Completion(.failure(error))
                }
                    
                else if let data = Data {
                    Completion(.success(data))
                }
                
                let _ = self?.requestQueue.async {
                    self?.requests.remove(Request)
                }
                
            }.resume()
            
            self.requests.insert(Request)
        }
    }
}

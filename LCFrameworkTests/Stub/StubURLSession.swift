//
//  StubURLSession.swift
//  LCFrameworkTests
//
//  Created by owee on 09/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import LCFramework
import Combine

final class StubSession : URLSessionStub {

}

class FakePublish {
    
    let session = StubSession(Data: "1".data(using: .utf8)!, Reponse: nil, Error: nil, Delay: 10)
    
    func ten(Number:Int) -> Future<Int,Never> {
        
        let futur = Future<Int,Never> { promise in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) {
                promise(.success(Number * 10))
            }
            
        }
        return futur
    }
    
    func seven(Number:Int) -> Future<Int,Never> {
        
        let futur = Future<Int,Never> { promise in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(15)) {
                promise(.success(Number * 7))
            }
        }
        return futur
    }
    
    func four(Number:Int) -> Future<Int,Never> {
        
        let futur = Future<Int,Never> { promise in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(15)) {
                promise(.success(Number * 4))
            }
        }
        return futur
    }
    
    func combine(Number:Int) -> AnyPublisher<Int,Never> {
        
        return self.ten(Number: Number)
            .print()
            .flatMap {self.four(Number: $0)}
            .print()
            .flatMap {self.seven(Number: $0)}
            .print()
            .eraseToAnyPublisher()
    }
    
    var random : [AnyPublisher<Int,Never>] {
        (0...10).map({Int(arc4random_uniform(UInt32($0)))}).map({self.combine(Number: $0)})
    }

}

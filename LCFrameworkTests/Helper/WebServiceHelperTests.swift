//
//  WebServiceHelperTests.swift
//  LCFrameworkTests
//
//  Created by owee on 09/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import XCTest
import LCFramework
import Combine

class WebServiceHelperTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    var stub = StubSession(Data: "123456789".data(using: .utf8), Reponse: nil, Error: nil, Delay: 70)
    var requestNumber = 15
    
    func testDownloadListOrder() {
        
        let ws = WebService(Session: stub)
        
        let requests = (1...requestNumber)
            .compactMap {URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\($0).png")}
            .map {URLRequest(url: $0)}
        
        let exp = expectation(description: "Download list")
        
        let list = requests + requests
        
        ws.listTask(List: list, Completion: { (res) in
            switch res {
            case .failure(let error): print(error.localizedDescription)
            case .success(let tuple): print("[\(tuple.0.url!)] with \(tuple.1)")
            }
        }) { (Number) in
            print("Success request \(Number)")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        
    }
    
    func testDownloadListSimultaneous() {
        
        let ws = WebService(Session: stub)
        
        let requests = (1...requestNumber)
            .compactMap {URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\($0).png")}
            .map {URLRequest(url: $0)}
        
        let exp = expectation(description: "Download list")
        
        let list = requests + requests
        
        ws.listTask(Option: .Simultaneous, List: list, Completion: { (res) in
            switch res {
            case .failure(let error): print(error.localizedDescription)
            case .success(let tuple): print("[\(tuple.0.url!)] with \(tuple.1)")
            }
        }) { (Number) in
            print("Success request \(Number)")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        
    }
    
    func testDownloadListPage() {
        
        let ws = WebService(Session: stub)
        
        let requests = (1...requestNumber)
            .compactMap {URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\($0).png")}
            .map {URLRequest(url: $0)}
        
        let exp = expectation(description: "Download list")
        
        let list = requests + requests
        
        ws.listTask(Option: .Group(Page: 2), List: list, Completion: { (res) in
            switch res {
            case .failure(let error): print(error.localizedDescription)
            case .success(let tuple): print("[\(tuple.0.url!)] with \(tuple.1)")
            }
        }) { (Number) in
            print("Success request \(Number) !")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testDownloadListTimer() {
        
        let ws = WebService(Session: stub)
        
        let requests = (1...requestNumber)
            .compactMap {URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\($0).png")}
            .map {URLRequest(url: $0)}
        
        let exp = expectation(description: "Download list")
        
        let list = requests + requests
        
        ws.listTask(Option: .Delay(Page: 20, Interval: 5), List: list, Completion: { (res) in
            switch res {
            case .failure(let error): print(error.localizedDescription)
            case .success(let tuple): print("[\(tuple.0.url!)] with \(tuple.1)")
            }
        }) { (Number) in
            print("Success request \(Number) !")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 50, handler: nil)
    }
    
    var bag = Set<AnyCancellable>()
    
    func testSequence() {
        
        let ws = WebService(Session: stub)
        let exp = expectation(description: "Sequence")
        
        let requests = (1...requestNumber)
            .compactMap {URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\($0).png")}
            .map {URLRequest(url: $0)}
            .map {request -> Future<String,Never> in
                return Future<String,Never> { promise in
                    self.stub.dataTask(with: request) { (Data, Rep, Err) in
                        promise(.success(String(request.url!.absoluteString.suffix(10))))
                    }.resume()
                }
            }
        
        var s = 0

        ws.sequence(List: requests) { (result) in
            switch result {
            case .success(let success):
                success.forEach({print($0)})
                s = success.count
            default: break
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        
        XCTAssert(s == requests.count)
    }
}

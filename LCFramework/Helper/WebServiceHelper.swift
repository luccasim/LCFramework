//
//  WebServiceHelper.swift
//  Pokedex
//
//  Created by Luc CASIMIR on 08/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import Combine


public protocol WebServiceHelper {
    
    func task<Reponse:Codable>(Request:URLRequest, Completion:@escaping (Result<Reponse,Error>) -> Void)
    
}

/// Step To Make a WebService :
/// 0 - Look API Doc, if you need and API key, or manage a token
/// 1 - Try and get one http reponse (on your brother) save as file on xcode project.
/// 2 - Build and Endpoint with the url path and parameter
/// 3 - Build an Enum Error for manage yours API Errors (i.e bad parameter input or server reponse Error)
/// 4 - Build a request method for get URLRequest class
/// 5 - Build a Codable Struct for parse your local file (use XCTests is the best)
/// 6 - Implement your task (you could copy this task<Reponse:Codable>)
public extension WebServiceHelper {
    
    func task<Reponse:Codable>(Request:URLRequest, Completion:@escaping (Result<Reponse,Error>) -> Void) {
        
        URLSession.shared.dataTask(with: Request) { (Data, Rep, Err) in
            
            if let error = Err {
                return Completion(.failure(error))
            }
            
            else if let data = Data {
                
                do {
                    
                    let reponse = try JSONDecoder().decode(Reponse.self, from: data)
                    Completion(.success(reponse))
                    
                } catch let error  {
                    Completion(.failure(error))
                }
            }
            
        }.resume()
    }
}

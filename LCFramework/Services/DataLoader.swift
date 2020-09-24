//
//  DataLoaderHelper.swift
//  Pokedex
//
//  Created by Luc CASIMIR on 06/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

protocol DataLoaderInterface {
    
    associatedtype DataMapped
    
    func load(Url:URL, Callback:@escaping((Result<DataMapped,Error>) -> Void))
    func load(Request:URLRequest, Callback:@escaping((Result<DataMapped,Error>) -> Void))
    
    func cleanCache()
    func removeAllStorage()
    
}

/// This generic implement the DataLoaderHelperProtocol.
/// For use we recommand to inherit with the appropiate Data.
/// This class use NSCache and FileManager for manage the data.
open class DataLoader<T:AnyObject> : DataLoaderInterface {
    
    private var session : URLSession
    private var cache = NSCache<NSString,T>()
    private var requests = Set<URLRequest>()
    
    var convertData : ((Data) -> T?)
    
    public var trace : Bool = false
        
    public init(Session:URLSession, Tracable:Bool=false, Convert: @escaping((Data)->T?)) {
        self.session = Session
        self.convertData = Convert
        self.trace = Tracable
    }
    
    func trace(_ str:String) {
        if self.trace {
            print("[\(DataLoader.Type.self)] : \(str)")
        }
    }
    
    enum Errors : Error {
        case invalidFileName
        case missingStorageURL
        case fileIsNotStored
        case failingRetrieveData
        case isPending
        case cantReadFile
    }
}

// MARK: - Implementation

public extension DataLoader {
    
    /// Load a ressource asynchrony. First check if the ressource is cached,
    /// else try to reload from the local file, else download it.
    /// - Parameters:
    ///   - Url: The remote uri, use this only if you have a valid and none credential url.
    /// The fileName delete / and take the 30 last caractere from this url. If you have collision use item instead.
    ///   - Callback:A completion to work when task finish.
    func load(Request:URLRequest, Callback:@escaping((Result<T,Error>) -> Void)) {

        guard let name = Request.url?.absoluteString.replacingOccurrences(of: "/", with: "") else {
            return Callback(.failure(Errors.invalidFileName))
        }
        
        let item = LoaderItem(fileName: name, request: Request)
        
        // Check if cached
        if let obj = self.cache.object(forKey: NSString(string: item.fileName)) {
            self.trace("Load \(item.fileName) from Cache")
            Callback(.success(obj))
        }
        
        // Check if stored
        else if let obj = self.retrieve(item: item) {
            self.cache.setObject(obj, forKey: NSString(string: item.fileName))
            self.trace("Load \(item.fileName) from File")
            Callback(.success(obj))
        }
        
        // Else Download
        else {
            self.download(item: item) { (result) in
                
                switch result {
                case .failure(let err):
                    
                    self.trace("Error Download \(item.fileName) => \(err.localizedDescription)")
                    Callback(.failure(err))
                    
                case .success(_):
                    
                    if let obj = self.retrieve(item: item) {
                        
                        self.cache.setObject(obj, forKey: NSString(string: item.fileName))
                        self.trace("Load \(item.fileName) from Remote")
                        Callback(.success(obj))
                        
                    } else {
                        
                        self.trace("Cant read \(item.fileName) file format")
                        Callback(.failure(Errors.cantReadFile))
                    }
                }
            }
        }
    }
    
    func load(Url:URL, Callback:@escaping((Result<T,Error>) -> Void)) {
        let request = URLRequest(url: Url)
        self.load(Request: request, Callback: Callback)
    }
    
    /// Clean the cache
    func cleanCache() {
        self.cache.removeAllObjects()
    }
    
    /// Remove storage directory.
    func removeAllStorage() {
        
        let manager = FileManager.default
        
        let dir = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Loader")
        
        do {
            try manager.removeItem(at: dir)
        } catch let err {
            print(err.localizedDescription)
        }
    }
}

// If your source need credential to access,
// you should use this protocol for retrieve your data
private protocol LoaderItemProtocol {
    var fileName: String {get}
    var request: URLRequest {get}
}

/// Standart struct for send a specifique request.
/// You could set the file name to save.
private struct LoaderItem : LoaderItemProtocol {
    public let fileName: String
    public let request: URLRequest

    public init(fileName: String, request: URLRequest){
        self.fileName = fileName
        self.request = request
    }
}

fileprivate extension DataLoader {
    
    func cache(item:LoaderItemProtocol) {
    
        if let object = self.retrieve(item: item) {
            self.cache.setObject(object, forKey: NSString(string: item.fileName))
        }
    }
    
    func couldDownload(request:URLRequest) -> Bool {

        guard self.requests.contains(request) else {
            self.requests.insert(request)
            return true
        }
        
        return false
    }
    
    func download(item:LoaderItemProtocol, Callback:@escaping (Result<URL,Error>) -> Void) {
        
        guard self.couldDownload(request: item.request) else {
            return Callback(.failure(Errors.isPending))
        }
        
        self.session.downloadTask(with: item.request) { (tmp, rep, err) in
            if let error = err {
                Callback(.failure(error))
            } else if let local = tmp {
                Callback(self.store(item: item, AtUrl: local))
            }
            self.requests.remove(item.request)
        }.resume()
    }
    
    func retrieve(item:LoaderItemProtocol) -> T? {
        
        let manager = FileManager.default
        
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Loader")
            .appendingPathComponent(item.fileName)
        
        do {
            
            let data = try Data(contentsOf: url)
            return self.convertData(data)
            
        } catch {
            return nil
        }
    }
    
    func delete(item:LoaderItemProtocol) {
        
        let manager = FileManager.default
        
        let file = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Loader")
            .appendingPathComponent(item.fileName)
        
        if manager.fileExists(atPath: file.path) {
            try? manager.removeItem(at: file)
        }
    }
    
    func store(item:LoaderItemProtocol, AtUrl:URL) -> Result<URL,Error> {
        
        let manager = FileManager.default
        
        let dir = manager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Loader")
        
        let file = dir.appendingPathComponent(item.fileName)
        let dirExist = manager.fileExists(atPath: dir.path)
        
        do {
            
            if !dirExist {
                try manager.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
            }
            
            try manager.replaceItem(at: file, withItemAt: AtUrl, backupItemName: nil, options: [], resultingItemURL: nil)
            return .success(file)
            
        } catch let err {
            return .failure(err)
        }
    }
}

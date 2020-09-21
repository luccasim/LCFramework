//
//  CoreDataManager.swift
//  Pokedex
//
//  Created by Luc CASIMIR on 05/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import CoreData

/// Help to Manage CoreData Entities with basic operations :
/// Fetch, Create, Get, Delete, Save and Clear.
///
/// Fetching uses NSPredicate with The String Format.
///
/// Each operations (except save) **did'nt save the commit change**,
/// its recommend to implement them.
///
/// If you crash with create, check you entity class module
/// and turn it on *Current Product Module*
protocol CoreDataStoreHelper {
    
    associatedtype Entity : NSManagedObject
    
    var context: NSManagedObjectContext {get}
    
    static func register(ContainerName:String)
    
    func create() -> Entity
    func fetch(Predicate:NSPredicate?, Limit:Int?) -> Result<[Entity],Error>
    func first(Predicate:NSPredicate?) -> Entity?
    func delete(Entity:Entity)
    func save()
    func removeAll()
    
}

/// Generique implementation of CoreDataHelperProtocol,
/// This generic shared the registed PersistentContaint for
/// each Entity his support.
///
/// To avoid loading delay from the persistentContainer,
/// its recommend to regist the .xcdatamodel under the SceneDelegate.
public class CoreDataStore<T:NSManagedObject> : CoreDataStoreHelper {
    
    public typealias Entity = T
    
    public init(Traceable:Bool=false){
        self.trace = Traceable
    }
    
    public var trace : Bool
    
    public static func register(ContainerName:String) {
        SharedContainer.shared.setContainer(Name: ContainerName)
        print("[CoreStore] : Register for \(ContainerName)")
    }
    
    var persistentContainer: NSPersistentCloudKitContainer {
        return SharedContainer.shared.persistentContainer
    }
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func trace(_ str:String) {
        if self.trace {
            print("[CoreStore] : \(str)")
        }
    }
    
    public func create() -> T {
        return T(context: self.persistentContainer.viewContext)
    }
    
    public func fetch(Predicate:NSPredicate?=nil, Limit:Int?=nil) -> Result<[T],Error> {
        
        let request = T.fetchRequest()
        
        if let predicate = Predicate {
            request.predicate = predicate
        }
        
        if let limit = Limit {
            request.fetchLimit = limit
        }
        
        do {
            
            let result = try self.persistentContainer.viewContext.fetch(request)
            let res = result as? [T] ?? []
            self.trace("Fetch {\(Predicate?.description ?? "All") \(T.self) and get \(res.count) results}")
            return .success(res)
            
        } catch let error {
            self.trace("Fetch failed with error -> \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    public func first(Predicate:NSPredicate?=nil) -> T? {
        
        let request = T.fetchRequest()
        request.fetchLimit = 1
        
        if let predicate = Predicate {
            request.predicate = predicate
        }

        let result = try? (self.persistentContainer.viewContext.fetch(request) as? [T])?.first
        self.trace("First {\(Predicate?.description ?? "") of \(T.self) \(result == nil ? "not found" : "found")")
        return result
    }
    
    public func delete(Entity:T) {
        self.persistentContainer.viewContext.delete(Entity)
        self.trace("Delete \(Entity.objectID)")
    }
    
    public func save() {
        do {
            if self.persistentContainer.viewContext.hasChanges {
                try self.persistentContainer.viewContext.save()
                self.trace("Save Context.")
            } else {
                self.trace("No Change for save Context.")
            }
        } catch let error {
            self.trace(error.localizedDescription)
        }
    }
    
    public func removeAll() {
                
        do {
            
            let result = try self.fetch().get()
            result.forEach({self.delete(Entity: $0)})
            self.save()
            self.trace("RemoveAll \(T.self), succed operation.")
            
        } catch let error {
            self.trace("RemoveAll \(T.self), failed -> \(error)")
        }
    }
}

private class SharedContainer {
    
    private init() {}
    static let shared = SharedContainer()
    
    var persistentContainer : NSPersistentCloudKitContainer!
    
    func setContainer(Name:String) {
        
        let container = NSPersistentCloudKitContainer(name: Name)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                print("[CoreStore] : Success to load CoreDataModel \(Name).xcdatamodel.")
            }
        })
        
        self.persistentContainer = container
    }
}

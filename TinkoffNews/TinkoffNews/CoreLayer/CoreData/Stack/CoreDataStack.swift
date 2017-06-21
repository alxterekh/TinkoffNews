//
//  CoreDataStack.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStackContextProvider {
    var mainContext : NSManagedObjectContext? { get }
    var saveContext : NSManagedObjectContext? { get }
    func deleteEntities(with name: String)
    func performSave(context: NSManagedObjectContext, completionHandler: @escaping (String?) -> Void)
}

class CoreDataStack : CoreDataStackContextProvider {
    
    fileprivate let managedObjectModelName = "Model"
    
    fileprivate var _managedObjectModel : NSManagedObjectModel?
    fileprivate var managedObjectModel : NSManagedObjectModel? {
        get {
            if _managedObjectModel == nil {
                if let modelURL = getModelURL() {
                    _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
                }
            }
            
            return _managedObjectModel
        }
    }
    
    fileprivate var _persistentStoreCoordinator : NSPersistentStoreCoordinator?
    fileprivate var persistentStoreCoordinator : NSPersistentStoreCoordinator? {
        get {
            if _persistentStoreCoordinator == nil {
                guard let model = self.managedObjectModel else {
                    print("No managed object model!")
                    
                    return nil
                }
                
                _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                do {
                    try _persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType,
                                                                        configurationName: nil,
                                                                        at: getStoreURL(),
                                                                        options: nil)
                }
                catch {
                    assert(false, "error adding store to coordinator: \(error)")
                }
            }
            
            return _persistentStoreCoordinator
        }
    }
    
    fileprivate var _masterContext : NSManagedObjectContext?
    fileprivate var masterContext : NSManagedObjectContext? {
        get {
            if _masterContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let persistentStoreCoordinator = self.persistentStoreCoordinator else {
                    print("No store coordinator!")
                    
                    return nil
                }
                
                context.persistentStoreCoordinator = persistentStoreCoordinator
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _masterContext = context
            }
            
            return _masterContext
        }
    }
    
    fileprivate var _mainContext : NSManagedObjectContext?
    var mainContext : NSManagedObjectContext? {
        get {
            if _mainContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                guard let parentContext = self.masterContext else {
                    print("No master context!")
                    
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _mainContext = context
            }
            
            return _mainContext
        }
    }
    
    fileprivate var _saveContext : NSManagedObjectContext?
    var saveContext : NSManagedObjectContext? {
        get {
            if _saveContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let parentContext = self.mainContext else {
                    print("No main context!")
                    
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _saveContext = context
            }
            
            return _saveContext
        }
    }
    
    // MARK: -
    
    func deleteEntities(with name: String) {
        if let context = saveContext {
            context.performAndWait {
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                do {
                    try context.execute(deleteRequest)
                    try context.save()
                } catch {
                    print (error.localizedDescription)
                }
            }
        }
    }
    
    func performSave(context: NSManagedObjectContext, completionHandler: @escaping (String?) -> Void) {
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                DispatchQueue.main.async { completionHandler(error.localizedDescription) }
                print("Context save error: \(error)")
            }
            
            if let parent = context.parent {
                self.performSave(context: parent, completionHandler: completionHandler)
            }
            else {
                DispatchQueue.main.async { completionHandler(nil) }
            }
        }
        else {
            completionHandler(nil)
        }
    }
    
    // MARK: - Paths
    
    fileprivate func getStoreURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("Model.sqlite")
    }
    
    fileprivate func getModelURL() -> URL? {
        guard let modelURL = Bundle.main.url(forResource:"Model",
                                             withExtension:"momd") else {
                                                return nil
        }
        
        return modelURL
    }
    
    fileprivate func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

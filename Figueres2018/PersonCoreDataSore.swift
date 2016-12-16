//
//  PersonCoreDataSore.swift
//  Figueres2018
//
//  Created by Javier Jara on 12/7/16.
//  Copyright © 2016 Data Center Consultores. All rights reserved.
//

import CoreData

class PersonCoreDataSore: PersonStoreProtocol {

    // MARK: - Managed object contexts
    
    var mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext
    
    // MARK: - Object lifecycle
    
    init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "CoreDataDemo", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.appendingPathComponent("CoreDataDemo.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
        
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = mainManagedObjectContext
    }
    
    deinit
    {
        do {
            try self.mainManagedObjectContext.save()
        } catch {
            fatalError("Error deinitializing main managed object context")
        }
    }
    
    // MARK: - CRUD operations - Optional error
    
    func fetchPerson(_ id: String, completionHandler: @escaping (_ person: PersonModel?, _ error: PersonStoreError?) -> Void)
    {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [Person]
                
                if let person = results.first?.toPersonModel() {
                    completionHandler(person,nil)
                } else {
                    completionHandler(nil, PersonStoreError.cannotFetch("Cannot fetch Person with id \(id)"))
                }
            } catch {
                completionHandler(nil, PersonStoreError.cannotFetch("Cannot fetch Person with id \(id)"))
            }
        }
    }
    

    // MARK: - CRUD operations - Generic enum result type

    
    func fetchPerson(_ id: String, completionHandler: @escaping PersonStoreFetchPersonCompletionHandler)
    {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [Person]
                if let person = results.first?.toPersonModel() {
                    completionHandler(PersonStoreResult.success(result: person))
                } else {
                    completionHandler(PersonStoreResult.failure(error: PersonStoreError.cannotFetch("Cannot fetch Person with id \(id)")))
                }
            } catch {
                completionHandler(PersonStoreResult.failure(error: PersonStoreError.cannotFetch("Cannot fetch Person with id \(id)")))
            }
        }
    }
    
    // MARK: - CRUD operations - Inner closure
    
    func fetchPerson(_ id: String, completionHandler: @escaping (_ p: () throws -> PersonModel?) -> Void)
    {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [Person]
                if let person = results.first?.toPersonModel() {
                    completionHandler { return person }
                } else {
                    throw PersonStoreError.cannotFetch("Cannot fetch preson with id \(id)")
                }
            } catch {
                completionHandler { throw PersonStoreError.cannotFetch("Cannot fetch person with id \(id)") }
            }
        }
    }
}

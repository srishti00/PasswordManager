//
//  PersistenceController.swift
//  PasswordManager
//
//  Created by srisshar on 01/08/24.
//

import CoreData

// A singleton class responsible for managing the Core Data stack
class PersistenceController {
    // Shared instance for accessing the PersistenceController
    static let shared = PersistenceController()

    // The NSPersistentContainer used for managing the Core Data stack
    let container: NSPersistentContainer

    // Initialize the PersistenceController with optional in-memory store for testing
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PasswordManager")
        
        // Configure the container to use an in-memory store if specified
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Load the persistent stores and handle any errors
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    // Access the view context for performing Core Data operations
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
}



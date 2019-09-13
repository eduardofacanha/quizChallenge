//
//  CoreDataManager.swift
//  Quiz
//
//  Created by Eduardo Façanha on 10/09/19.
//  Copyright © 2019 Facanha. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack: NSObject {
  static let shared = CoreDataStack()
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Quiz")
    
    container.loadPersistentStores(completionHandler: { (_, error) in
      guard let error = error as NSError? else { return }
      fatalError("Unresolved error: \(error), \(error.userInfo)")
    })
    
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.undoManager = nil
    container.viewContext.shouldDeleteInaccessibleFaults = true
    
    container.viewContext.automaticallyMergesChangesFromParent = true
    
    return container
  }()
  public var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
}

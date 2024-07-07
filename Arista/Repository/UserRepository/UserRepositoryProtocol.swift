//
//  UserRepositoryProtocol.swift
//  Arista
//
//  Created by Tristan Géhanne on 26/06/2024.
//

import Foundation
import CoreData

protocol FetchRequestContext {
    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T]
}

class CoreDataFetchRequestContext: FetchRequestContext {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult {
        return try context.fetch(request)
    }
}

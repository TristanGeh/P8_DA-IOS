//
//  UserRepository.swift
//  Arista
//
//  Created by Tristan Géhanne on 13/06/2024.
//

import Foundation
import CoreData

struct UserRepository {
    private let fetchRequestContext: FetchRequestContext
    
    init(fetchRequestContext: FetchRequestContext) {
        self.fetchRequestContext = fetchRequestContext
    }
    
    /*let viewContext: NSManagedObjectContext
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }*/
    
    func getUser() throws -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let users = try fetchRequestContext.fetch(request)
            return users.first
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
            throw error
        }
    }
}

//
//  UserRepository.swift
//  Arista
//
//  Created by Tristan Géhanne on 13/06/2024.
//

import Foundation
import CoreData

struct UserRepository {
    let viewContext: NSManagedObjectContext
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func getUser() throws -> User? {
        let request = User.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let users = try viewContext.fetch(request)
            return users.first
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
            throw error
        }
    }
}

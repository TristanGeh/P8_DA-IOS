//
//  UserRepositoryTests.swift
//  AristaTests
//
//  Created by Tristan Géhanne on 24/06/2024.
//

import XCTest
import CoreData
@testable import Arista

final class UserRepositoryTests: XCTestCase {

    // MARK: - Utility Functions

    private func emptyEntities(context: NSManagedObjectContext) {
        
        let fetchRequest = Sleep.fetchRequest()
        
        let objects = try! context.fetch(fetchRequest)
        
        
        
        for sleep in objects {
            
            context.delete(sleep)
            
        }
        
        try! context.save()
        
    }
    
    private func addUser(context: NSManagedObjectContext, firstName: String, lastName: String) {
        let newUser = User(context: context)
        
        newUser.firstName = firstName
        newUser.lastName = lastName
        
        try! context.save()
    }
    
    // MARK: - User Tests
    
    /*
     Fonction à tester :
     
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
     */
    
    func test_WhenNoUserInDatabase_GetUser_ReturningEmptyList() {
        
        // Clean manually all data
        
        let persistenceController = PersistenceController(inMemory: true)
        
        emptyEntities(context: persistenceController.container.viewContext)
        
        // Arrange
        
        let data = UserRepository(viewContext: persistenceController.container.viewContext)
        
        // Act
        
        var user: User?
            do {
                user = try data.getUser()
            } catch {
                XCTFail("Unexpected error: \(error.localizedDescription)")
            }
        
        // Test
        
        XCTAssertNil(user, "Expected no user to be returned")
    }
    
    func test_WhenOneUserInDatabase_GetUser_ReturnListContainingOneUser() {
        
        // Clean manually all data
        
        let persistenceController = PersistenceController(inMemory: true)
        
        emptyEntities(context: persistenceController.container.viewContext)
        
        // Arrange
        let context = persistenceController.container.viewContext
        let data = UserRepository(viewContext: context)
        
        // Act
        
        addUser(context: context, firstName: "Jeremy", lastName: "Clarkson")
        
        let user = try! data.getUser()
        
        // Tests
        
        XCTAssert(user?.firstName == "Jeremy")
        
        XCTAssert(user?.lastName == "Clarkson")
    }
}



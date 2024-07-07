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
        
        let fetchRequest = User.fetchRequest()
        
        let objects = try! context.fetch(fetchRequest)
        
        
        
        for user in objects {
            
            context.delete(user)
            
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
     */
    
    func test_WhenNoUserInDatabase_GetUser_ReturningEmptyList() {
        
        // Clean manually all data
        
        let persistenceController = PersistenceController(inMemory: true)
        
        emptyEntities(context: persistenceController.container.viewContext)
        
        // Arrange
        let fetchRequestContext = CoreDataFetchRequestContext(context: persistenceController.container.viewContext)
        let data = UserRepository(fetchRequestContext: fetchRequestContext)
        
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
        let fetchRequestContext = CoreDataFetchRequestContext(context: context)
        let data = UserRepository(fetchRequestContext: fetchRequestContext)
        
        // Act
        
        addUser(context: context, firstName: "Jeremy", lastName: "Clarkson")
        
        let user = try! data.getUser()
        
        // Tests
        
        XCTAssert(user?.firstName == "Jeremy")
        
        XCTAssert(user?.lastName == "Clarkson")
    }
    
    func test_WhenMockContextUsed_GetUser_ReturnningError() {
        
        // Arrange
        
        let mockFetchRequestContext = UserRepositoryMock()
        let data = UserRepository(fetchRequestContext: mockFetchRequestContext)
        
        // Act & Tests
        
        do {
           _ = try data.getUser()
            XCTFail("Expected fetch to fail, but it succeed")
        } catch {
            XCTAssertEqual((error as NSError).domain, "MockError")
            XCTAssertEqual((error as NSError).code, 1)
        }
        
    }
}



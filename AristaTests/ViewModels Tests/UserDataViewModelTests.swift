//
//  UserDataViewModelTests.swift
//  AristaTests
//
//  Created by Tristan Géhanne on 01/07/2024.
//

import XCTest
import CoreData
import Combine

@testable import Arista

final class UserDataViewModelTests: XCTestCase {
    
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
    
    var cancellables = Set<AnyCancellable>()
    
    /**Fonction à tester
     func fetchUserData() {
         do {
             guard let user = try UserRepository(fetchRequestContext: fetchRequestContext).getUser() else {
                 print("User not found")
                 return
             }
             firstName = user.firstName ?? ""
             lastName = user.lastName ?? ""
         } catch {
             print("Failed to fetch user's data: \(error.localizedDescription)")
         }
     }
     **/
    
    // MARK: - User Tests

    
    func test_WhenNoUserInDatabase_GetUser_ReturningEmptyList() {
        
        // Clean manually all data
        
        let persistenceController = PersistenceController(inMemory: true)
        
        emptyEntities(context: persistenceController.container.viewContext)
        
        // Arrange
        let fetchRequestContext = CoreDataFetchRequestContext(context: persistenceController.container.viewContext)
        let viewModel = UserDataViewModel(fetchRequestContext: fetchRequestContext)
        
        let expectation = XCTestExpectation(description: "Porperties should remain empty")
        
        // Act
        
        viewModel.$firstName
            .combineLatest(viewModel.$lastName)
            .sink { firstName, lastName in
                
                XCTAssert(firstName.isEmpty == true)
                
                XCTAssert(lastName.isEmpty == true)
                
                expectation.fulfill()
            }
        
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenOneUserInDatabase_GetUser_ReturnListContainingOneUser() {
        // Clean manually all data
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        // Arrange
        let context = persistenceController.container.viewContext
        let fetchRequestContext = CoreDataFetchRequestContext(context: context)
        
        addUser(context: context, firstName: "Jeremy", lastName: "Clarkson")
        
        // Check if user is added
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let users = try! context.fetch(fetchRequest)
        print("Users in context: \(users)")
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.firstName, "Jeremy")
        XCTAssertEqual(users.first?.lastName, "Clarkson")
        
        let viewModel = UserDataViewModel(fetchRequestContext: fetchRequestContext)
        
        let expectation = XCTestExpectation(description: "Properties should be fulfilled")
        
        // Act
        viewModel.$firstName
            .combineLatest(viewModel.$lastName)
            .sink { firstName, lastName in
                print("FirstName: \(firstName), LastName: \(lastName)")
                XCTAssertEqual(firstName, "Jeremy")
                XCTAssertEqual(lastName, "Clarkson")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }

}

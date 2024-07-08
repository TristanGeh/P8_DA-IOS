//
//  SleepHistoryViewModelTests.swift
//  AristaTests
//
//  Created by Tristan Géhanne on 01/07/2024.
//

import XCTest
import CoreData
@testable import Arista
import Combine

final class SleepHistoryViewModelTests: XCTestCase {
    // MARK: - Utilities functions
    
    private func emptyEntities(context: NSManagedObjectContext) {
        
        let fetchRequest = Sleep.fetchRequest()
        
        let objects = try! context.fetch(fetchRequest)
        
        
        
        for sleep in objects {
            
            context.delete(sleep)
            
        }
        
        
        
        try! context.save()
        
    }
    
    private func addSleep(context: NSManagedObjectContext, duration: Int, quality: Int, startDate: Date ) {
        
        let newSleep = Sleep(context: context)
        
        newSleep.duration = Int64(duration)
        newSleep.quality = Int64(quality)
        newSleep.startDate = startDate
        
        try! context.save()
    }
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - fetchSleepSession tests
    
    func test_WhenNoSleepInDatabase_FetchSleepSessions_ReturnEmptyList() {
        // Clean manually all data
        
        let persistenceController = PersistenceController(inMemory: true)
        
        emptyEntities(context: persistenceController.container.viewContext)

        let context = persistenceController.container.viewContext
        
        let viewModel = SleepHistoryViewModel(context: context)
        
        let expectation = XCTestExpectation(description: "Empty list of Sleep")
        
        viewModel.$sleepSessions
        
            .sink { sleep in
                
                XCTAssert(sleep.isEmpty)
                
                expectation.fulfill()
            }
        
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenAddingOneSleepInDatabase_FetchSleepSessions_ReturnAListContainingOneSleep() {
        // Clean manually all data
        
        let persistenceController = PersistenceController(inMemory: true)
        
        emptyEntities(context: persistenceController.container.viewContext)
        
        
        // Arrange
        
        let context = persistenceController.container.viewContext
        let date = Date()
        
        addSleep(context: context, duration: 320, quality: 8, startDate: date)
        
        let viewModel = SleepHistoryViewModel(context: context)
        let expectation = XCTestExpectation(description: "List of a sleep")
        
        // Act & tests
        
        viewModel.$sleepSessions
            .sink { sleep in
                
                print("Sleep sessions : \(sleep)")
                
                XCTAssert(sleep.isEmpty == false)
                
                XCTAssert(sleep.first?.duration == 320)
                
                XCTAssert(sleep.first?.quality == 8)
                
                XCTAssert(sleep.first?.startDate == date)
                
                expectation.fulfill()
            }
        
            .store(in: &cancellables)
    
        wait(for: [expectation], timeout: 10)
    }

    func test_WhenAddingMultipleSleepsInDatabase_FetchSleepSessions_ReturningAListContainingMultipleSleeps() {
        // Clean manually all data
        
        let persistenceController = PersistenceController(inMemory: true)
        
        emptyEntities(context: persistenceController.container.viewContext)
        
        // Arrange
        
        let context = persistenceController.container.viewContext
        
        let date1 = Date()
        
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addSleep(context: context, duration: 420, quality: 3, startDate: date1)
        
        addSleep(context: context, duration: 120, quality: 9, startDate: date2)
        
        addSleep(context: context, duration: 810, quality: 6, startDate: date3)
        
        // Act & tests
        
        let viewModel = SleepHistoryViewModel(context: context)
        
        let expectation = XCTestExpectation(description: "List of sleeps")
        
        viewModel.$sleepSessions
            .sink { sleeps in
                
                XCTAssert(sleeps.count == 3)
                
                XCTAssert(sleeps[0].duration == 420)
                
                XCTAssert(sleeps[1].duration == 120)
                
                XCTAssert(sleeps[2].duration == 810)
                
                expectation.fulfill()
            }
        
            .store(in: &cancellables)
        
        
        
        wait(for: [expectation], timeout: 10)
        
    }

}

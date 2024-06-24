//
//  SleepRepositoryTests.swift
//  AristaTests
//
//  Created by Tristan Géhanne on 24/06/2024.
//

import XCTest
import CoreData
@testable import Arista

final class SleepRepositoryTests: XCTestCase {
    
    // MARK: - Utility Functions

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
    
    // MARK: - Sleep tests
    
    /*
        Fonction à tester
     
     func getSleepSessions() throws -> [Sleep] {
     let request = Sleep.fetchRequest()
     request.sortDescriptors = [NSSortDescriptor(SortDescriptor<Sleep>(\.startDate, order:.reverse))]
     return try viewContext.fetch(request)
 }*/
    func test_WhenNoSleepInDatabase_GetSleepSessions_ReturnEmptyList() {
        // Clean manually all data
        
        let persistenceController = PersistenceController(inMemory: true)
        
        emptyEntities(context: persistenceController.container.viewContext)
        
        let data = SleepRepository(viewContext: persistenceController.container.viewContext)
        
        let sleep = try! data.getSleepSessions()
        
        XCTAssert(sleep.isEmpty == true)
    }
    
    func test_WhenAddingOneSleepInDatabase_GetSleepSessions_ReturnAListContainingOneSleep() {
        // Clean manually all data
        
        let persistenceController = PersistenceController(inMemory: true)
        
        emptyEntities(context: persistenceController.container.viewContext)
        
        // Arrange
        
        let context = persistenceController.container.viewContext
        let date = Date()
        
        addSleep(context: context, duration: 320, quality: 8, startDate: date)
        
        // Act
        
        let data = SleepRepository(viewContext: context)
        
        let sleep = try! data.getSleepSessions()
        
        // Tests
        
        XCTAssert(sleep.count == 1)
        
        XCTAssert(sleep[0].duration == 320)
        
        XCTAssert(sleep[0].quality == 8)
        
        XCTAssert(sleep[0].startDate == date)
    
        
    }

    func test_WhenAddingMultipleSleepsInDatabase_GetSleepSessions_ReturningAListContainingMultipleSleeps() {
        // Clean manually all data
        
        let persistenceController = PersistenceController(inMemory: true)
        
        emptyEntities(context: persistenceController.container.viewContext)
        
        // Arrange
        
        let context = persistenceController.container.viewContext
        let date = Date()
        
        addSleep(context: context, duration: 420, quality: 3, startDate: date)
        addSleep(context: context, duration: 120, quality: 9, startDate: date)
        addSleep(context: context, duration: 810, quality: 6, startDate: date)
        
        // Act
        
        let data = SleepRepository(viewContext: context)
        
        let sleeps = try! data.getSleepSessions()
        
        // Tests
        
        XCTAssert(sleeps.count == 3)
        
        XCTAssert(sleeps[0].duration == 420)
        
        XCTAssert(sleeps[1].duration == 120)
        
        XCTAssert(sleeps[2].duration == 810)
    }
}

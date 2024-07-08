//
//  AddExerciseListViewModelTests.swift
//  AristaTests
//
//  Created by Tristan Géhanne on 30/06/2024.
//

import XCTest
import CoreData
@testable import Arista



final class AddExerciseListViewModelTests: XCTestCase {
    
    // MARK: - Utilities functions
    
    private func emptyEntities(context: NSManagedObjectContext) {
        
        let fetchRequest = Exercise.fetchRequest()
        
        let objects = try! context.fetch(fetchRequest)
        
        
        
        for exercice in objects {
            
            context.delete(exercice)
            
        }
        
        
        
        try! context.save()
        
    }
    
    
    // MARK: - Type Conversion Tests
    func test_StartTimeStringConversion() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let testDate = dateFormatter.date(from: "10:30")!
        
        let viewModel = AddExerciseViewModel(context: PersistenceController(inMemory: true).container.viewContext)
        
        viewModel.startTime = testDate
        XCTAssertEqual(viewModel.startTimeString, "10:30")
        
        viewModel.startTimeString = "14:45"
        XCTAssertEqual(dateFormatter.string(from: viewModel.startTime), "14:45")
    }
    
    func test_DurationStringConversion() {
        let viewModel = AddExerciseViewModel(context: PersistenceController(inMemory: true).container.viewContext)
        
        viewModel.duration = 60
        XCTAssertEqual(viewModel.durationString, "60")
        
        viewModel.durationString = "90"
        XCTAssertEqual(viewModel.duration, 90)
        
        viewModel.durationString = "invalid"
        XCTAssertEqual(viewModel.duration, 0)
    }
    
    func test_IntensityStringConversion() {
        let viewModel = AddExerciseViewModel(context: PersistenceController(inMemory: true).container.viewContext)
        
        viewModel.intensity = 5
        XCTAssertEqual(viewModel.intensityString, "5")
        
        viewModel.intensityString = "7"
        XCTAssertEqual(viewModel.intensity, 7)
        
        viewModel.intensityString = "invalid"
        XCTAssertEqual(viewModel.intensity, 0)
    }
    
    // MARK: - Validation Tests
    
    func test_Validate_AllFieldsValid() {
        let viewModel = AddExerciseViewModel(context: PersistenceController(inMemory: true).container.viewContext)
        
        viewModel.category = "Running"
        viewModel.startTimeString = "10:30"
        viewModel.durationString = "60"
        viewModel.intensityString = "5"
        
        XCTAssertTrue(viewModel.validate())
        XCTAssertNil(viewModel.validationError)
    }
    
    func test_Validate_CategoryEmpty() {
        let viewModel = AddExerciseViewModel(context: PersistenceController(inMemory: true).container.viewContext)
        
        viewModel.category = ""
        viewModel.startTimeString = "10:30"
        viewModel.durationString = "60"
        viewModel.intensityString = "5"
        
        XCTAssertFalse(viewModel.validate())
        XCTAssertEqual(viewModel.validationError, "La catégorie est requise.")
    }
    
    func test_Validate_StartTimeStringInvalidFormat() {
        let viewModel = AddExerciseViewModel(context: PersistenceController(inMemory: true).container.viewContext)
        
        viewModel.category = "Running"
        viewModel.startTimeString = "25:30"
        viewModel.durationString = "60"
        viewModel.intensityString = "5"
        
        XCTAssertFalse(viewModel.validate())
        XCTAssertEqual(viewModel.validationError, "Le format de l'heure de démarrage est incorrect. Utilisez HH:mm.")
    }
    
    func test_Validate_DurationInvalid() {
        let viewModel = AddExerciseViewModel(context: PersistenceController(inMemory: true).container.viewContext)
        
        viewModel.category = "Running"
        viewModel.startTimeString = "10:30"
        viewModel.durationString = "0"
        viewModel.intensityString = "5"
        
        XCTAssertFalse(viewModel.validate())
        XCTAssertEqual(viewModel.validationError, "La durée doit être supérieure à 0.")
    }
    
    func test_Validate_IntensityOutOfRange() {
        let viewModel = AddExerciseViewModel(context: PersistenceController(inMemory: true).container.viewContext)
        
        viewModel.category = "Running"
        viewModel.startTimeString = "10:30"
        viewModel.durationString = "60"
        viewModel.intensityString = "11"
        
        XCTAssertFalse(viewModel.validate())
        XCTAssertEqual(viewModel.validationError, "L'intensité doit être entre 0 et 10.")
    }
    
    func test_Validate_IntensityIsEmpty() {
        let viewModel = AddExerciseViewModel(context: PersistenceController(inMemory: true).container.viewContext)
        
        viewModel.category = "Running"
        viewModel.startTimeString = "10:30"
        viewModel.durationString = "60"
        viewModel.intensityString = ""
        
        XCTAssertFalse(viewModel.validate())
        XCTAssertEqual(viewModel.validationError, "L'intensité doit être entre 0 et 10.")
    }
    // MARK: - Function tests
    
    /*func addExercise() -> Bool {
     do {
     try ExerciseRepository(viewContext: viewContext).addExercise(category: category, duration: duration, intensity: intensity, startDate: startTime)
     return true
     } catch {
     print("Failed to add Exercise: \(error.localizedDescription)")
     return false
     }
     }*/
    
    func test_AddExercise_ReturningSuccess() {
        let viewModel = AddExerciseViewModel(context: PersistenceController(inMemory: true).container.viewContext)
        
        viewModel.category = "Running"
        viewModel.duration = 60
        viewModel.intensity = 5
        viewModel.startTime =  Date()
        
        let success = viewModel.addExercise()
        
        XCTAssertTrue(success, "Expected addExercise to succeed")
    }
}

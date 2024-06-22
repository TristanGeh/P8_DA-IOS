//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class AddExerciseViewModel: ObservableObject {
    @Published var category: String = ""
    @Published var startTime: Date = Date()
    @Published var duration: Int64 = 0
    @Published var intensity: Int64 = 0
    private var viewContext: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    // MARK: - Type Conversion
    private var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var startTimeString: String {
        get {
            dateFormatter.string(from: startTime)
        }
        set {
            if let date = dateFormatter.date(from: newValue){
                startTime = date
            }
        }
    }
    
    var durationString: String {
        get {
            String(duration)
        }
        set {
            if let intValue = Int64(newValue){
                duration = intValue
            }
        }
    }
    
    var intensityString: String {
        get {
            String(intensity)
        }
        set {
            if let intValue = Int64(newValue){
                intensity = intValue
            }
        }
    }
    // MARK: - Functions
    
    func addExercise() -> Bool {
        do {
            try ExerciseRepository(viewContext: viewContext).addExercise(category: category, duration: duration, intensity: intensity, startDate: startTime)
            return true
        } catch {
            print("Failed to add Exercise: \(error.localizedDescription)")
            return false
        }
    }
}

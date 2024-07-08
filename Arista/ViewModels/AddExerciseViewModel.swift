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
    @Published var startTimeString: String = ""
    @Published var durationString : String = ""
    @Published var intensityString: String = ""
    @Published var validationError: String? = nil
    
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
    
    var startTime: Date {
        get {
            dateFormatter.date(from: startTimeString) ?? Date()
        }
        set {
            startTimeString = dateFormatter.string(from: newValue)
        }
    }
    
    var duration: Int64 {
        get {
            Int64(durationString) ?? 0
        }
        set {
            durationString = String(newValue)
        }
    }
    
    var intensity: Int64 {
        get {
            Int64(intensityString) ?? 0
        }
        set {
            intensityString = String(newValue)
        }
    }
    // MARK: - Functions
    
    func validate() -> Bool {
        validationError = nil
        
        if category.isEmpty {
            validationError = "La catégorie est requise."
            return false
        }
        if !isValidTimeFormat(startTimeString) {
            validationError = "Le format de l'heure de démarrage est incorrect. Utilisez HH:mm."
            return false
        }
        
        if duration <= 0 {
            validationError = "La durée doit être supérieure à 0."
            return false
        }
        
        if intensityString.isEmpty || intensity < 0 || intensity > 10 {
            validationError = "L'intensité doit être entre 0 et 10."
            return false
        }
        
        return true
    }
    
    func addExercise() -> Bool {
        
        guard validate() else {
            return false
        }
        
        do {
            try ExerciseRepository(viewContext: viewContext).addExercise(category: category, duration: duration, intensity: intensity, startDate: startTime)
            return true
        } catch {
            print("Failed to add Exercise: \(error.localizedDescription)")
            return false
        }
    }
    
    private func isValidTimeFormat(_ time: String) -> Bool {
        let timeFormat = "^(?:[01]\\d|2[0-3]):[0-5]\\d$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", timeFormat)
        return predicate.evaluate(with: time)
    }
}

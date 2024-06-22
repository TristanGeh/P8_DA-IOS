//
//  SleepRepository.swift
//  Arista
//
//  Created by Tristan Géhanne on 13/06/2024.
//

import Foundation
import CoreData

struct SleepRepository {
    let viewContext: NSManagedObjectContext
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func getSleepSessions() throws -> [Sleep] {
        let request = Sleep.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(SortDescriptor<Sleep>(\.startDate, order:.reverse))]
        return try viewContext.fetch(request)
    }
}

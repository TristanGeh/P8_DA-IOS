//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class UserDataViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchUserData()
    }
    
    private func fetchUserData() {
        do {
            guard let user = try UserRepository(viewContext: viewContext).getUser() else {
                print("User not found")
                return
            }
            firstName = user.firstName ?? ""
            lastName = user.lastName ?? ""
        } catch {
            print("Failed to fetch user's data: \(error.localizedDescription)")
        }
    }
}

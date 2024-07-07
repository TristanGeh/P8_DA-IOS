//
//  UserRepositoryMock.swift
//  Arista
//
//  Created by Tristan Géhanne on 26/06/2024.
//

import Foundation
import CoreData

class UserRepositoryMock: FetchRequestContext {
    
    func fetch<T:NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] {
        throw NSError(domain: "MockError", code: 1, userInfo: nil)
    }
}

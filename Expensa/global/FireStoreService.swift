//
//  FireStoreService.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-24.
//

import Foundation
import FirebaseDatabase

class FireStoreService {
    
    private var email: String
    private var ref: DatabaseReference
    
    init(_ email: String) {
        self.email = email
        self.ref = Database.database(url: "https://expensa-e0ac6-default-rtdb.asia-southeast1.firebasedatabase.app").reference();
    }
    
    func loadUserDataSnapshot() async throws -> DataSnapshot {
        let emailKey = makeEmailFireStoreSafe(email)
        return try await ref.child(emailKey).getData();
    }
    
    func saveBasicBudgetDetails(_ data: BasicBudget) async throws {
        let emailKey = makeEmailFireStoreSafe(email)
        try await self.ref.child(emailKey).setValue([
            "balance": data.balance,
            "budgetForCategory": [
                "savings": (data.budgetForCategory["savings"] ?? Double(0)),
                "entertainment": (data.budgetForCategory["entertainment"] ?? Double(0)),
                "food": (data.budgetForCategory["food"] ?? Double(0)),
                "travel": (data.budgetForCategory["travel"] ?? Double(0)),
                "maintenance": (data.budgetForCategory["maintenance"] ?? Double(0)),
                "other": (data.budgetForCategory["other"] ?? Double(0)),
            ]
        ])
    }
    
    // Helper functions
    private func makeEmailFireStoreSafe(_ email: String) -> String {
        let replacements = [".", "#", "$", "[", "]"]
        var result = email
        for replaceChar in replacements {
            result = result.replacingOccurrences(of: replaceChar, with: "_")
        }
        return result
    }
    
    private func objectToDictionary<T: Encodable>(_ object: T) throws -> [String: Any] {
        let jsonData = try JSONEncoder().encode(object)
        guard let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            throw CustomError.runtimeError("Failed to convert object to dictionary")
        }
        return dictionary
    }
    
}
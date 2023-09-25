//
//  UserData.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-12.
//

import Foundation
import FirebaseDatabase

class UserData: ObservableObject {
    @Published var email :String?
    @Published var isFirstLogin :Bool = false
    @Published var isLoadingData :Bool = false
    @Published var basicBudget :BasicBudget?
    
    // Entire dataset related to user
    @Published var dataSnapshot: DataSnapshot?
    
    init() {}
    
    func loadDataForUser(_ email: String) async throws {
        print("LOADING DATA")
        let fireStore = FireStoreService(email)
        let data = try await fireStore.loadUserDataSnapshot()
        let value = data.value as? NSDictionary
        let balance = value?["balance"] as? Double ?? 0
        let dataDict = value?["budgetForCategory"] as? [String : Double] ?? [:]
        let budget = BasicBudget(balance: Double(balance), budgetForCategory: dataDict, expenseForCategory: [:])
        DispatchQueue.main.async {
            self.dataSnapshot = data
            self.basicBudget = budget
            self.isFirstLogin = (budget.budgetForCategory.isEmpty)
            self.isLoadingData = false
        }
        
        
//        // TODO: REMOVE THIS
//        DispatchQueue.main.async {
//            let budget = BasicBudget(balance: Double(10000), budgetForCategory: [
//                "savings": 4000,
//                "entertainment": 3000,
//                "food": 2000,
//                "travel": 1000,
//                "maintenance": 0,
//                "other": 500,
//            ], expenseForCategory: [:])
//            self.basicBudget = budget
//        }
    }
    
}

enum CustomError: Error {
    case runtimeError(String)
}


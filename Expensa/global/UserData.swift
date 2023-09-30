//
//  UserData.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-12.
//

import Foundation
import FirebaseDatabase
import SwiftUI

class UserData: ObservableObject {
    @Published var email :String?
    @Published var isFirstLogin :Bool = false
    @Published var isGreetDisplayed :Bool = false
    @Published var basicBudget :BasicBudget?
    
    // Entire dataset related to user
    @Published var dataSnapshot: DataSnapshot?
    
    @AppStorage("homeBudgetMode") var homeBudgetMode = "M"
    
    init() {}
    
    // Load data for user email from firestore
    func loadDataForUser(_ email: String) async throws -> DataSnapshot {
        print("LOADING DATA")
        let fireStore = FireStoreService(email)
        let data = try await fireStore.loadUserDataSnapshot()
        let value = data.value as? NSDictionary
        let balance = value?["balance"] as? Double ?? 0
        var dataDict = value?["budgetForCategory"] as? [String : Double] ?? [:]
        if (homeBudgetMode == "W") {
            for data in dataDict {
                dataDict[data.key] = (data.value / 4)
            }
        }
        let budget = BasicBudget(balance: Double(balance), budgetForCategory: dataDict, expenseForCategory: [:])
        DispatchQueue.main.async {
            self.dataSnapshot = data
            self.basicBudget = budget
            self.isFirstLogin = (budget.budgetForCategory.isEmpty)
        }
        return data
    }
    
    // load initial expenses for week or month
    func loadExpenses() async throws {
        guard let email else {
            return
        }
        let dataSnapshot = try await loadDataForUser(email)
        let fireStore = FireStoreService(email)
        let dates = fireStore.getStartAndEndDates(for: Date())
        let collectedData = fireStore.loadExpenseForDates(dates, dataSnapshot)
        await MainActor.run { [collectedData] in
            self.basicBudget?.expenseForCategory = collectedData
        }
    }
    
}

enum CustomError: Error {
    case runtimeError(String)
}


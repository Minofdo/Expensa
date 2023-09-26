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
    @Published var isGreetDisplayed :Bool = false
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
    
    func loadExpenses(_ type: String) async throws {
        guard let email else {
            return
        }
        try await loadDataForUser(email)
        if let dataSnapshot = self.dataSnapshot {
            let dates = getStartAndEndWeekNumbers(for: Date())
            var collectedData: [String : Double] = [:]
            for number in dates.startWeekNumber...dates.endWeekNumber {
                let value = dataSnapshot.value as? NSDictionary
                if let value = value {
                    let tempData = ((value["expense_records"] as? NSDictionary ?? [:])["\(number)"] ?? [:]) as? NSDictionary ?? [:]
                    for (_, object) in tempData {
                        let obj = object as? NSDictionary ?? [:]
                        if let category = obj["category"] as? String, let amount = obj["amount"] as? Double {
                            print("\(category) -> \(amount)")
                            if (collectedData[category] != nil) {
                                collectedData[category] = (collectedData[category]! + amount)
                            } else {
                                collectedData[category] = amount
                            }
                        }
                    }
                }
            }
            await MainActor.run { [collectedData] in
                self.basicBudget?.expenseForCategory = collectedData
            }
        }
    }
    
    // Helper functions
    private func getStartAndEndWeekNumbers(for date: Date) -> (startWeekNumber: Int, endWeekNumber: Int) {
        let timeDifference = TimeZone.current.secondsFromGMT()
        
        let calendar = Calendar.current
        let startOfMonthGMT = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let startOfMonth = calendar.date(byAdding: .second, value: timeDifference, to: startOfMonthGMT)!
        
        var components = DateComponents()
        components.month = 1
        components.day = -1
        let endOfMonth = calendar.date(byAdding: components, to: startOfMonth)!
        
        let startWeekNumber = calendar.component(.weekOfYear, from: startOfMonth)
        let endWeekNumber = calendar.component(.weekOfYear, from: endOfMonth)
        
        return (startWeekNumber, endWeekNumber)
    }
    
}

enum CustomError: Error {
    case runtimeError(String)
}


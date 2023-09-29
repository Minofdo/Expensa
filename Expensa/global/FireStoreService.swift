//
//  FireStoreService.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-24.
//

import Foundation
import FirebaseDatabase
import SwiftUI

class FireStoreService {
    
    @AppStorage("homeBudgetMode") var homeBudgetMode = "M"
    
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
    
    func saveRecord(_ data: Record) async throws {
        let emailKey = makeEmailFireStoreSafe(email)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: data.recordDate)
        let keyDateFormatter = DateFormatter()
        keyDateFormatter.dateFormat = "yyMMdd"
        let keyDate = keyDateFormatter.string(from: data.recordDate)
        if (data.isExpense) {
            guard let key = ref.child("/\(emailKey)/expense_records/\(keyDate)").childByAutoId().key else { return }
            let record = [
                "amount": data.amount,
                "date": dateStr,
                "description": data.description,
                "location": data.location,
                "category": data.category
            ] as [String : Any]
            try await ref.updateChildValues([
                "/\(emailKey)/balance": data.newBalance,
                "/\(emailKey)/expense_records/\(keyDate)/\(key)": record
            ])
        } else {
            guard let key = ref.child("/\(emailKey)/income_records/\(keyDate)").childByAutoId().key else { return }
            let record = [
                "amount": data.amount,
                "date": dateStr,
                "description": data.description,
                "location": data.location,
            ] as [String : Any]
            try await ref.updateChildValues([
                "/\(emailKey)/balance": data.newBalance,
                "/\(emailKey)/income_records/\(keyDate)/\(key)": record
            ])
        }
    }
    
    func loadExpenseForDates(_ dates: [String], _ data: DataSnapshot?) -> [String:Double] {
        if let data = data {
            var collectedData: [String : Double] = [:]
            for dateNumber in dates {
                let value = data.value as? NSDictionary
                if let value = value {
                    let tempData = ((value["expense_records"] as? NSDictionary ?? [:])["\(dateNumber)"] ?? [:]) as? NSDictionary ?? [:]
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
            return collectedData
        } else {
            return [:]
        }
    }
    
    func loadDetailedRecordsForDates(_ dates: [String], _ data: DataSnapshot?) -> (expenses: [Record], income: [Record]) {
        if let data = data {
            let keyDateFormatter = DateFormatter()
            keyDateFormatter.dateFormat = "yyMMdd"
            var collectedExpense: [Record] = []
            var collectedIncome: [Record] = []
            for dateNumber in dates {
                let value = data.value as? NSDictionary
                if let value = value {
                    let tempData = ((value["expense_records"] as? NSDictionary ?? [:])["\(dateNumber)"] ?? [:]) as? NSDictionary ?? [:]
                    for (_, object) in tempData {
                        let obj = object as? NSDictionary ?? [:]
                        if let category = obj["category"] as? String, let amount = obj["amount"] as? Double {
                            let expense = Record(
                                newBalance: 0,
                                isExpense: true,
                                amount: amount,
                                recordDate: keyDateFormatter.date(from: dateNumber) ?? Date(),
                                description: obj["description"] as? String ?? "",
                                location: obj["location"] as? String ?? "",
                                category: category
                            )
                            collectedExpense.append(expense)
                        }
                    }
                }
                if let value = value {
                    let tempData = ((value["income_records"] as? NSDictionary ?? [:])["\(dateNumber)"] ?? [:]) as? NSDictionary ?? [:]
                    for (_, object) in tempData {
                        let obj = object as? NSDictionary ?? [:]
                        if let amount = obj["amount"] as? Double {
                            let income = Record(
                                newBalance: 0,
                                isExpense: false,
                                amount: amount,
                                recordDate: keyDateFormatter.date(from: dateNumber) ?? Date(),
                                description: obj["description"] as? String ?? "",
                                location: obj["location"] as? String ?? "",
                                category: ""
                            )
                            collectedIncome.append(income)
                        }
                    }
                }
            }
            return (collectedExpense, collectedIncome)
        } else {
            return ([], [])
        }
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
    
    func getStartAndEndDates(for date: Date) -> [String] {
        let timeDifference = TimeZone.current.secondsFromGMT()
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        var startDate: Date
        let endDate: Date
        if homeBudgetMode == "W" {
            let startDateGMT = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            startDate = calendar.date(byAdding: .second, value: timeDifference, to: startDateGMT)!
            endDate = calendar.date(byAdding: DateComponents(day: -1, weekOfYear: 1), to: startDate)!
        } else {
            let startDateGMT = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
            startDate = calendar.date(byAdding: .second, value: timeDifference, to: startDateGMT)!
            endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        var collectedDates: [String] = []
        while (startDate <= endDate) {
            collectedDates.append(formatter.string(from: startDate))
            startDate = calendar.date(byAdding: DateComponents(day: 1), to: startDate)!
        }
        return collectedDates
    }
    
    func getDateCodesInRange(_ startDateIn: Date, _ endDateIn: Date) -> [String] {
        let timeDifference = TimeZone.current.secondsFromGMT()
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        var startDate: Date
        let endDate: Date
        
        let startDateGMT = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: startDateIn))!
        startDate = calendar.date(byAdding: .second, value: timeDifference, to: startDateGMT)!
        
        let endDateGMT = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: endDateIn))!
        endDate = calendar.date(byAdding: .second, value: timeDifference, to: endDateGMT)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        var collectedDates: [String] = []
        while (startDate <= endDate) {
            collectedDates.append(formatter.string(from: startDate))
            startDate = calendar.date(byAdding: DateComponents(day: 1), to: startDate)!
        }
        return collectedDates
    }
    
}

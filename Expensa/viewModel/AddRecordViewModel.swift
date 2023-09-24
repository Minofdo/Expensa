//
//  AddRecordViewModel.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-24.
//

import Foundation

@MainActor
class AddRecordViewModel: ObservableObject {
    
    @Published var showAlert = false
    @Published var messageBody = ""
    @Published var messageTitle = ""
    
    @Published var description = ""
    @Published var location = ""
    @Published var date = Date.now
    @Published var category = ""
    
    @Published var amount = "" {
        didSet {
            let filtered = amount.filter { "0123456789".contains($0)}
            if filtered != amount {
                self.amount = filtered
            }
        }
    }
    
    func saveIncome(_ email: String?, balance: Double, completion: @escaping (Bool) -> Void) async {
        if let amountDouble = Double(amount), let email = email {
            if (amountDouble < 1) {
                completion(false)
                messageTitle = "INVALID DATA"
                messageBody = "Please enter a valid amount."
                showAlert = true
            } else {
                let fireStore = FireStoreService(email)
                let record = Record(
                    newBalance: (balance + amountDouble),
                    isExpense: false,
                    amount: amountDouble,
                    recordDate: date,
                    description: description,
                    location: location,
                    category: category
                )
                do {
                    try await fireStore.saveRecord(record)
                    completion(true)
                } catch {
                    completion(false)
                    messageTitle = "ERROR"
                    messageBody = "Error occurred when saving data. Please try again later."
                    showAlert = true
                }
            }
        }
    }
    
    func saveExpense(_ email: String?, balance: Double, completion: @escaping (Bool) -> Void) async {
        if let amountDouble = Double(amount), let email = email {
            if (amountDouble < 1) {
                completion(false)
                messageTitle = "INVALID DATA"
                messageBody = "Please enter a valid amount."
                showAlert = true
            } else {
                let fireStore = FireStoreService(email)
                let record = Record(
                    newBalance: (balance - amountDouble),
                    isExpense: true,
                    amount: amountDouble,
                    recordDate: date,
                    description: description,
                    location: location,
                    category: category
                )
                do {
                    try await fireStore.saveRecord(record)
                    completion(true)
                } catch {
                    completion(false)
                    messageTitle = "ERROR"
                    messageBody = "Error occurred when saving data. Please try again later."
                    showAlert = true
                }
            }
        }
    }
    
}

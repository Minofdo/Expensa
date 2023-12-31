//
//  AddRecordViewModel.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-24.
//

import Foundation

@MainActor
class AddRecordViewModel: ObservableObject {
    
    @Published var isLoadingData = false
    @Published var showAlert = false
    @Published var showSuccess = false
    @Published var messageBody = ""
    @Published var messageTitle = ""
    
    @Published var description = ""
    @Published var location = ""
    @Published var date = Date.now
    @Published var category = "savings"
    
    // filter only numeric values
    @Published var amount = "" {
        didSet {
            let filtered = amount.filter { "0123456789".contains($0)}
            if filtered != amount {
                self.amount = filtered
            }
        }
    }
    
    // Save income to firebase
    func saveIncome(_ email: String?, balance: Double) {
        if (
            amount.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            description.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            location.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        ) {
            messageTitle = "INVALID DATA"
            messageBody = "Please fill all required fields.."
            showAlert = true
        } else if let amountDouble = Double(amount), let email = email {
            if (amountDouble < 1) {
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
                
                self.isLoadingData = true
                Task {
                    var success = false
                    do {
                        try await fireStore.saveRecord(record)
                        success = true
                    } catch {
                        print(error)
                        success = false
                    }
                    DispatchQueue.main.async {
                        self.isLoadingData = false
                        if (success) {
                            self.showSuccess = true
                        } else {
                            self.messageTitle = "ERROR"
                            self.messageBody = "Error occurred when saving data. Please try again later."
                        }
                        self.showAlert = true
                    }
                }
            }
        } else {
            messageTitle = "ERROR"
            messageBody = "Error occurred when parsing amount. Please try again."
            showAlert = true
        }
    }
    
    // Save expense to firebase
    func saveExpense(_ email: String?, balance: Double) {
        if (
            amount.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            category.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            description.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            location.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        ) {
            messageTitle = "INVALID DATA"
            messageBody = "Please fill all required fields.."
            showAlert = true
        } else if let amountDouble = Double(amount), let email = email {
            if (amountDouble < 1) {
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
                self.isLoadingData = true
                Task {
                    var success = false
                    do {
                        try await fireStore.saveRecord(record)
                        success = true
                    } catch {
                        print(error)
                        success = false
                    }
                    DispatchQueue.main.async {
                        self.isLoadingData = false
                        if (success) {
                            self.showSuccess = true
                        } else {
                            self.messageTitle = "ERROR"
                            self.messageBody = "Error occurred when saving data. Please try again later."
                        }
                        self.showAlert = true
                    }
                }
            }
        } else {
            messageTitle = "ERROR"
            messageBody = "Error occurred when parsing amount. Please try again."
            showAlert = true
        }
    }
    
    func resetData() {
        showSuccess = false
        description = ""
        location = ""
        date = Date.now
        category = "savings"
        amount = ""
    }
    
}

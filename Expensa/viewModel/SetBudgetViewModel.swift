//
//  SetBudgetViewModel.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-21.
//

import Foundation

@MainActor
class SetBudgetViewModel: ObservableObject {
    
    @Published var showAlert = false
    @Published var messageBody = ""
    @Published var messageTitle = ""
    
    @Published var balance: Double = 0
    
    @Published var initialAmount = "" {
        didSet {
            let filtered = initialAmount.filter { "0123456789".contains($0)}
            if filtered != initialAmount {
                self.initialAmount = filtered
            }
            updateBalance()
        }
    }
    
    @Published var savings = "" {
        didSet {
            let filtered = savings.filter { "0123456789".contains($0)}
            if filtered != savings {
                self.savings = filtered
            }
            updateBalance()
        }
    }
    @Published var savingsPeriod = "M" {
        didSet {
            updateBalance()
        }
    }
    
    @Published var entertainment = "" {
        didSet {
            let filtered = entertainment.filter { "0123456789".contains($0)}
            if filtered != entertainment {
                self.entertainment = filtered
            }
            updateBalance()
        }
    }
    @Published var entertainmentPeriod = "M" {
        didSet {
            updateBalance()
        }
    }
    
    @Published var food = "" {
        didSet {
            let filtered = food.filter { "0123456789".contains($0)}
            if filtered != food {
                self.food = filtered
            }
            updateBalance()
        }
    }
    @Published var foodPeriod = "M" {
        didSet {
            updateBalance()
        }
    }
    
    @Published var travel = "" {
        didSet {
            let filtered = travel.filter { "0123456789".contains($0)}
            if filtered != travel {
                self.travel = filtered
            }
            updateBalance()
        }
    }
    @Published var travelPeriod = "M" {
        didSet {
            updateBalance()
        }
    }
    
    @Published var maintenance = "" {
        didSet {
            let filtered = maintenance.filter { "0123456789".contains($0)}
            if filtered != maintenance {
                self.maintenance = filtered
            }
            updateBalance()
        }
    }
    @Published var maintenancePeriod = "M" {
        didSet {
            updateBalance()
        }
    }
    
    @Published var other = "" {
        didSet {
            let filtered = other.filter { "0123456789".contains($0)}
            if filtered != other {
                self.other = filtered
            }
            updateBalance()
        }
    }
    @Published var otherPeriod = "M" {
        didSet {
            updateBalance()
        }
    }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    } ()
    
    private func updateBalance() {
        balance = Double(initialAmount) ?? 0
        balance -= ((Double(savings) ?? 0) * ((savingsPeriod == "W") ? 4 : 1))
        balance -= ((Double(entertainment) ?? 0) * ((entertainmentPeriod == "W") ? 4 : 1))
        balance -= ((Double(food) ?? 0) * ((foodPeriod == "W") ? 4 : 1))
        balance -= ((Double(travel) ?? 0) * ((travelPeriod == "W") ? 4 : 1))
        balance -= ((Double(maintenance) ?? 0) * ((maintenancePeriod == "W") ? 4 : 1))
        balance -= ((Double(other) ?? 0) * ((otherPeriod == "W") ? 4 : 1))
    }
    
    func saveBasicBudgetDetails(_ email: String?, completion: @escaping (Bool) -> Void) async {
        if let initialDouble = Double(initialAmount), let email = email {
            if (initialDouble < 1) {
                completion(false)
                messageTitle = "INVALID DATA"
                messageBody = "Please enter a valid amount for initial amount"
                showAlert = true
            } else {
                let fireStore = FireStoreService(email)
                let dataDict: Dictionary<String, Double> = [
                    "savings": ((Double(savings) ?? 0) * ((savingsPeriod == "W") ? 4 : 1)),
                    "entertainment": ((Double(entertainment) ?? 0) * ((entertainmentPeriod == "W") ? 4 : 1)),
                    "food": ((Double(food) ?? 0) * ((foodPeriod == "W") ? 4 : 1)),
                    "travel": ((Double(travel) ?? 0) * ((travelPeriod == "W") ? 4 : 1)),
                    "maintenance": ((Double(maintenance) ?? 0) * ((maintenancePeriod == "W") ? 4 : 1)),
                    "other": ((Double(other) ?? 0) * ((otherPeriod == "W") ? 4 : 1))
                ]
                let basicBudget = BasicBudget(balance: initialDouble, budgetForCategory: dataDict, expenseForCategory: [:])
                do {
                    try await fireStore.saveBasicBudgetDetails(basicBudget)
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

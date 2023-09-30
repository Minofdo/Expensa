//
//  DashboardViewModel.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-25.
//

import SwiftUI

@MainActor
class DashboardViewModel: ObservableObject {
    
    @Published var isLoadingData = false
    @Published var showLogout = false
    @Published var showAlert = false
    @Published var showSetupSheet = false
    @Published var messageBody = ""
    @Published var messageTitle = ""
    
    @Published var categories = Categories().categories
    @Published var catColors = Categories().categoryColor
    @Published var catValues: [String : Double] = [:]
    @AppStorage("homeBudgetMode") var pickerOption = "M"
    
    // Calculate percentage for dashboard dials
    func calcExpensePercentage(_ userData: UserData) {
        for category in categories {
            let targetValue = userData.basicBudget?.budgetForCategory[category.id] ?? 0
            let expenseValue = userData.basicBudget?.expenseForCategory[category.id] ?? 0
            print("targetValue")
            print(targetValue)
            if (targetValue == 0) {
                catValues[category.id] = .infinity
            } else if (expenseValue > targetValue) {
                catValues[category.id] = (((expenseValue - targetValue) / targetValue) * -1)
            } else {
                catValues[category.id] = ((targetValue - expenseValue) / targetValue)
            }
        }
    }
    
}

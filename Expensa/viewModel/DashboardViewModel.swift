//
//  DashboardViewModel.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-25.
//

import Foundation

@MainActor
class DashboardViewModel: ObservableObject {
    
    @Published var showedGreet = false
    @Published var showLogout = false
    @Published var showAlert = false
    @Published var showSetupSheet = false
    @Published var messageBody = ""
    @Published var messageTitle = ""
    
    @Published var categories = Categories().categories
    @Published var catColors = Categories().categoryColor
    @Published var pickerOption = "W"
    
    
    func calcExpensePercentage(_ categoryId: String, _ userData: UserData) -> Double {
        let targetValue = userData.basicBudget?.budgetForCategory[categoryId]
        let expenseValue = userData.basicBudget?.expenseForCategory[categoryId]
        if let targetValue = targetValue, let expenseValue = expenseValue {
            if (expenseValue > targetValue) {
                return (((expenseValue - targetValue) / targetValue) * -1)
            } else {
                return ((targetValue - expenseValue) / targetValue)
            }
        } else {
            return 0
        }
    }
    
}

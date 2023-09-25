//
//  BasicBudget.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-23.
//

import Foundation

struct BasicBudget: Codable {
    
    var balance: Double
    var budgetForCategory: [String : Double]
    var expenseForCategory: [String : Double]
    
}

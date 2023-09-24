//
//  Record.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-24.
//

import Foundation

struct Record: Codable {
    
    var newBalance: Double
    var isExpense: Bool
    var amount: Double
    var recordDate: Date
    var description: String
    var location: String
    var category: String
    
}

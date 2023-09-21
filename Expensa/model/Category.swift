//
//  Category.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-15.
//

import SwiftUI

struct Category: Identifiable {
    var id: String
    var label: String
    var colour: Color
}

struct Categories {
    
    private(set) var categories: [Category]
    
    init() {
        self.categories = [
            Category(id: "savings", label: "Savings", colour: .green),
            Category(id: "entertainment", label: "Entertainment", colour: .pink),
            Category(id: "food", label: "Food & Beverage", colour: .teal),
            Category(id: "travel", label: "Travel", colour: .brown),
            Category(id: "maintenance", label: "Maintenance", colour: .indigo),
            Category(id: "other", label: "Other Expense", colour: .orange)
        ]
    }
    
}

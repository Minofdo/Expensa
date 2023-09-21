//
//  SetBudgetViewModel.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-21.
//

import Foundation

class SetBudgetViewModel: ObservableObject {
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    } ()
    
    @Published var initialAmount = "" {
        didSet {
            let filtered = initialAmount.filter { "0123456789".contains($0) }
            print(filtered)
            if filtered != initialAmount {
                self.initialAmount = filtered
            }
        }
    }
    @Published var savings = ""
    @Published var entertainment = ""
    @Published var food = ""
    @Published var travel = ""
    @Published var maintenance = ""
    @Published var other = ""
    
}

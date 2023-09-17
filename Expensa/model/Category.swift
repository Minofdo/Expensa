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
            Category(id: "", label: "", colour: .black),
            Category(id: "", label: "", colour: .black),
            Category(id: "", label: "", colour: .black),
            Category(id: "", label: "", colour: .black),
            Category(id: "", label: "", colour: .black)
        ]
    }
    
}

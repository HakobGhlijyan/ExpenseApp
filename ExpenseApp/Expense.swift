//
//  Expense.swift
//  ExpenseApp
//
//  Created by Hakob Ghlijyan on 05.03.2024.
//

import SwiftUI
import SwiftData


//MARK: - MODEL DATA
@Model
final class Expense {
    @Attribute(.unique) var name:String
    var date: Date
    var value: Double
    
    init(name: String, date: Date, value: Double) {
        self.name = name
        self.date = date
        self.value = value
    }
}

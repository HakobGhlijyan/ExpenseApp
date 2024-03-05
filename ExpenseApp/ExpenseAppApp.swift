//
//  ExpenseAppApp.swift
//  ExpenseApp
//
//  Created by Hakob Ghlijyan on 05.03.2024.
//

import SwiftUI
import SwiftData

@main
struct ExpenseAppApp: App {
    
    let container: ModelContainer = {                                                                         //2
        let schema = Schema([Expense.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)                                                                    //2
//                .modelContainer(for: [Expense.self])
        }
    }
}

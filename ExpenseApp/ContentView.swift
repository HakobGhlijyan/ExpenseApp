//
//  ContentView.swift
//  ExpenseApp
//
//  Created by Hakob Ghlijyan on 05.03.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingItemSheet: Bool = false
    @Query(sort: \Expense.date) var sortedExpenses: [Expense]
    @Query(filter: #Predicate<Expense> { $0.value > 15 }, sort: \Expense.date) var filteredExpenses: [Expense]
    @State private var expenseToEdit: Expense?

    var body: some View {
        NavigationStack {
            List {
                if !sortedExpenses.isEmpty {
                    Section("All Expense") {
                        ForEach(sortedExpenses) { expense in
                            ExpenseCell(expense: expense)
                                .onTapGesture {
                                    expenseToEdit = expense
                                }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                modelContext.delete(sortedExpenses[index])
                            }
                        }
                    }
                    Section("Filtered Expense < 15$") {
                        ForEach(filteredExpenses) { expense in
                            ExpenseCell(expense: expense)
                                .onTapGesture {
                                    expenseToEdit = expense
                                }
                        }
                    }
                }
            }
            .navigationTitle("Expenses")
            .sheet(isPresented: $isShowingItemSheet) {
                AddExpenseSheet()
            }
            .sheet(item: $expenseToEdit, content: { expense in
                UpdateExpenseSheet(expense: expense)
            })
            .toolbar {
                if !sortedExpenses.isEmpty {
                    Button("Add Expense" , systemImage: "plus") {
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay {
                if sortedExpenses.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Expense", systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Start adding expenses to see your list.")
                    }, actions: {
                        Button(action: {
                            isShowingItemSheet = true
                        }) {
                            Text("Add Expense")
                                .padding(4)
                        }
                        .buttonStyle(.borderedProminent)
                    })
                    .offset(y: -80)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct ExpenseCell: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            Text(expense.date, format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            Text(expense.name)
            Spacer()
            Text(expense.value, format: .currency(code: "USD"))
        }
    }
}

struct AddExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var value: Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value: $value, format: .currency(code: "USD"))
                    .keyboardType(.numberPad)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                    let expense = Expense(name: name, date: date, value: value)
                        modelContext.insert(expense)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

struct UpdateExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var expense: Expense
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $expense.name)
                DatePicker("Date is add", selection: $expense.date, displayedComponents: .date)
                TextField("Value", value: $expense.value, format: .currency(code: "USD"))
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

//
//  SaveRecipeSlotView.swift
//  recipetest
//
//  Created by Samriddhi Agnihotri on 13/04/23.
//

import Foundation
import SwiftUI

struct SaveRecipeSlotView: View {
    @Binding var isPresented: Bool
    var recipe: Recipe
    var onSave: (String, String) -> Void

    @State private var selectedDay: String = "Monday"
    @State private var selectedMealType: String = "Breakfast"

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Day", selection: $selectedDay) {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day).tag(day)
                        }
                    }
                }
                Section {
                    Picker("Meal Type", selection: $selectedMealType) {
                        ForEach(mealTypes, id: \.self) { mealType in
                            Text(mealType).tag(mealType)
                        }
                    }
                }
            }
            .navigationTitle("Save Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRecipeSlot()
                    }
                }
            }
        }
    }

    private func saveRecipeSlot() {
        onSave(selectedDay, selectedMealType)
        isPresented = false
    }

    private let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    private let mealTypes = ["Breakfast", "Lunch", "Dinner"]
}

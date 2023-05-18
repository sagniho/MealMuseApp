//
//  RecipeViewModal.swift
//  recipetest
//
//  Created by Samriddhi Agnihotri on 04/04/23.
//


import Foundation
import SafariServices
import CoreData

struct RecipeResponse: Codable {
    let hits: [Hit]
}

struct Hit: Codable {
    let recipe: Recipe
}

struct Recipe: Codable, Identifiable {
    let id = UUID()
    let label: String
    let image: String
    let source: String
    let calories: Double
    let url: String
    // add any other properties you need
}

class RecipeViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: String = ""
    
    func searchRecipes(query: String) {
        let appID = "03503f97"
        let appKey = "b2f51ec8a594205da4f1f20cfaac57b6"
        let encodedQuery = query.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "https://api.edamam.com/search?q=\(encodedQuery)&app_id=\(appID)&app_key=\(appKey)")!

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
                return
            }

            guard let data = data else { return }

            do {
                let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                DispatchQueue.main.async {
                    self.recipes = decodedResponse.hits.map { $0.recipe }
                }
            } catch let decodingError {
                print(decodingError.localizedDescription)
                self.errorMessage = decodingError.localizedDescription
            }
        }.resume()
    }
    
    
    func saveRecipeSlot(day: String, mealType: String, label: String, image: String, source: String, calories: Double, url: String) {
        let context = PersistenceController.shared.container.viewContext
        let recipeSlot = RecipeSlot(context: context)
        recipeSlot.day = day
        recipeSlot.mealType = mealType
        recipeSlot.label = label
        recipeSlot.image = image
        recipeSlot.source = source
        recipeSlot.calories = calories
        recipeSlot.url = url

        do {
            try context.save()
        } catch let error {
            print("Error saving recipe slot: \(error.localizedDescription)")
        }
    }


    
    func openRecipeInSafari(recipe: Recipe) {
        guard let url = URL(string: recipe.url) else { return }
        let safariVC = SFSafariViewController(url: url)
        UIApplication.shared.windows.first?.rootViewController?.present(safariVC, animated: true, completion: nil)
    }
    
}



//
//  RecipeListView.swift
//  test
//
//  Created by Samriddhi Agnihotri on 12/03/23.
//

import Foundation
import SwiftUI
import SafariServices
import CoreData

struct RecipeListView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                Text("Search Recipes")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                TextField("Search for recipes", text: $searchText, onCommit: {
                    viewModel.searchRecipes(query: searchText)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .background(Color.white)
                .cornerRadius(40)
                .padding(.top)

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                List(viewModel.recipes) { recipe in
                    Button(action: {
                        viewModel.openRecipeInSafari(recipe: recipe)
                    }, label: {
                        RecipeRow(recipe: recipe, viewContext: viewContext)
                    })
                }
            }
        }
    }
}


struct RecipeRow: View {
    var recipe: Recipe
    var viewContext: NSManagedObjectContext
    @State private var isSaveViewPresented: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    AsyncImage(url: URL(string: recipe.image)) { phase in
                        switch phase {
                        case .empty:
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 60, height: 60)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                        case .failure:
                            Image(systemName: "exclamationmark.icloud")
                                .foregroundColor(.red)
                                .frame(width: 60, height: 60)
                        @unknown default:
                            fatalError()
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(recipe.label)
                            .font(.headline)
                        Text(recipe.source)
                            .font(.subheadline)
                        Text("\(Int(recipe.calories)) calories")
                            .font(.subheadline)
                        Text("more...")
                            .font(.subheadline)
                            .italic()

                    }
                }
                .onTapGesture {
                    openRecipeInSafari(recipe: recipe)
                }
                
                Button(action: {
                    isSaveViewPresented = true
                }, label: {
                    Image(systemName: "plus.circle.fill")
                                       .foregroundColor(.blue)
                })
                .sheet(isPresented: $isSaveViewPresented) {
                    SaveRecipeSlotView(isPresented: $isSaveViewPresented, recipe: recipe) { day, mealType in
                        let recipeSlot = RecipeSlot(context: viewContext)
                        recipeSlot.day = day
                        recipeSlot.mealType = mealType
                        recipeSlot.label = recipe.label
                        recipeSlot.image = recipe.image
                        recipeSlot.source = recipe.source
                        recipeSlot.calories = recipe.calories
                        recipeSlot.url = recipe.url
                        
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                }
            }
        }
    }

    private func openRecipeInSafari(recipe: Recipe) {
        guard let url = URL(string: recipe.url) else { return }
        let safariVC = SFSafariViewController(url: url)
        UIApplication.shared.windows.first?.rootViewController?.present(safariVC, animated: true, completion: nil)
    }
}



struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
    
}

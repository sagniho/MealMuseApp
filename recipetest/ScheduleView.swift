//
//  ScheduleView.swift
//  recipetest
//
//  Created by Samriddhi Agnihotri on 04/04/23.
//

import Foundation
import CoreData
import SwiftUI
import SafariServices

// ScheduleView.swift

import SwiftUI

struct ScheduleView: View {
    
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Schedule")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack {
                        ForEach(daysOfWeek, id: \.self) { day in
                            NavigationLink(destination: RecipeSlotsView(day: day)) {
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.white)
                                    .frame(height: 60)
                                    .overlay(
                                        Text(day)
                                            .foregroundColor(Color("GradientEnd"))
                                            .fontWeight(.semibold)
                                    )
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
            .navigationBarHidden(true)
        }
    }
}

/*
import SwiftUI

struct ScheduleView: View {
    
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Schedule")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                List(daysOfWeek, id: \.self) { day in
                    NavigationLink(destination: RecipeSlotsView(day: day)) {
                        HStack {
                            Text(day)
                                .foregroundColor(Color("GradientEnd"))
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .listRowBackground(Color.white)
                    .listRowInsets(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color.white))
                }
                .listStyle(PlainListStyle())
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
            .navigationBarHidden(true)
        }
    }
}

*/
import SwiftUI
import CoreData
import SafariServices

struct RecipeSlotsView: View {
    let day: String

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) private var allRecipeSlots: FetchedResults<RecipeSlot>

    private var recipeSlots: [RecipeSlot] {
        allRecipeSlots.filter { $0.day == day }
    }

    @State private var showRecipeListView: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text(day)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Spacer()
            }
            .padding(.horizontal)

            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(mealTypes, id: \.self) { mealType in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(mealType)
                                .font(.headline)
                                .foregroundColor(.black)

                            if recipeSlots.filter({ $0.mealType == mealType }).isEmpty {
                                Text("No Data")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.leading)
                                    .frame(maxWidth: .infinity)
                            } else {
                                ForEach(recipeSlots.filter { $0.mealType == mealType }) { recipeSlot in
                                    HStack {
                                        Button(action: {
                                            openRecipeInSafari(url: recipeSlot.url!)
                                        }, label: {
                                            RecipeSlotRow(recipeSlot: recipeSlot)
                                        })

                                        Spacer()

                                        Button(action: {
                                            deleteRecipeSlot(recipeSlot: recipeSlot)
                                        }, label: {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        })
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(15)
                                }
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .frame(maxHeight: 550)
            .background(Color.white.opacity(0.40))
             // Limit the length of the ScrollView
            
            Button(action: {
                showRecipeListView = true
            }) {
                Text("+ Add Recipes")
                    .foregroundColor(.white)
                    .padding()
                
                    .frame(maxWidth: 200) 
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
            .sheet(isPresented: $showRecipeListView) {
                RecipeListView(viewModel: RecipeViewModel())
            }
            .padding()

        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }

    private func deleteRecipeSlot(recipeSlot: RecipeSlot) {
        viewContext.delete(recipeSlot)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func openRecipeInSafari(url: String) {
        guard let url = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: url)
        UIApplication.shared.windows.first?.rootViewController?.present(safariVC, animated: true, completion: nil)
    }

    private let mealTypes = ["Breakfast", "Lunch", "Dinner"]
}



struct RecipeSlotRow: View {
    var recipeSlot: RecipeSlot
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: recipeSlot.image!)) { phase in
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
                Text(recipeSlot.label!)
                    .font(.headline)
                Text(recipeSlot.source!)
                    .font(.subheadline)
                Text("\(Int(recipeSlot.calories)) calories")
                    .font(.subheadline)
                Text("more...")
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.blue)
            
            }
        }
    }
}

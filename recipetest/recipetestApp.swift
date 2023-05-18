//
//  recipetestApp.swift
//  recipetest
//
//  Created by Samriddhi Agnihotri on 04/04/23.
//

import SwiftUI

import SwiftUI

@main
struct recipetestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
            LandingView()
            
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

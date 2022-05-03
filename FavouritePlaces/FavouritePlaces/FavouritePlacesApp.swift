//
//  FavouritePlacesApp.swift
//  FavouritePlaces
//
//  Created by Ajay Girolkar on 03/05/22.
//

import SwiftUI

@main
struct FavouritePlacesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

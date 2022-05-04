//
//  FavouritePlacesApp.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Kodurion 03/05/22.
//

import SwiftUI

@main
struct FavouritePlacesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MasterView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

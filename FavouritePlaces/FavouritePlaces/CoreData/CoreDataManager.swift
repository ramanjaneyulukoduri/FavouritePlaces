//
//  CoreDataManager.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 04/05/22.
//

import Foundation
import CoreData


struct CoreDataManager {
    
    static let shared = CoreDataManager()
    let viewContext = PersistenceController.shared.container.viewContext
    
    func getFavouritePlaceModels() -> [FavouritePlaceModel]? {
        let fetchRequest: NSFetchRequest<FavouritePlaceModel> = FavouritePlaceModel.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FavouritePlaceModel.id, ascending: true)]
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func addItem() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    func deleteData(offsets: IndexSet, favouritePlaceModels: [FavouritePlaceModel]) {
        offsets.map { favouritePlaceModels[$0] }.forEach(viewContext.delete)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

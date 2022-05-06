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
    
     func getFavouritePlaceModels() -> [FavouritePlaceDataModel]? {
        let fetchRequest: NSFetchRequest<FavouritePlaceModel> = FavouritePlaceModel.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FavouritePlaceModel.id, ascending: true)]
        
        do {
            let favouritePlaceModels: [FavouritePlaceModel] = try viewContext.fetch(fetchRequest)
            let favouritePlaceDataModels = favouritePlaceModels.map { favouritePlaceModel in
                return FavouritePlaceDataModel(id: favouritePlaceModel.id ?? UUID(),
                                               imageURL: favouritePlaceModel.imageURL,
                                               latitude: favouritePlaceModel.latitude,
                                               location: favouritePlaceModel.location,
                                               enterLocationDetailsText: favouritePlaceModel.enterLocationDetailsText,
                                               locationDescription: favouritePlaceModel.locationDescription,
                                               longitude: favouritePlaceModel.longitude)
            }
            return favouritePlaceDataModels
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
    
    
     func deleteData(offsets: IndexSet, favouritePlaceDataModels: [FavouritePlaceDataModel]) {
         let favouritePlaceModels = favouritePlaceDataModels.map { favouritePlaceDataModel in
             return convertDataModelToCoreDataModel(favouritePlaceDataModel: favouritePlaceDataModel)
         }
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
    
    func convertDataModelToCoreDataModel(favouritePlaceDataModel: FavouritePlaceDataModel) -> FavouritePlaceModel {
        let favouritePlaceModel = FavouritePlaceModel()
        favouritePlaceModel.id = favouritePlaceDataModel.id
        favouritePlaceModel.imageURL = favouritePlaceDataModel.imageURL
        favouritePlaceModel.location = favouritePlaceDataModel.location
        favouritePlaceModel.latitude = favouritePlaceDataModel.latitude
        favouritePlaceModel.longitude = favouritePlaceDataModel.longitude
        favouritePlaceModel.locationDescription = favouritePlaceDataModel.locationDescription
        favouritePlaceModel.enterLocationDetailsText = favouritePlaceDataModel.enterLocationDetailsText
        return favouritePlaceModel
    }
}

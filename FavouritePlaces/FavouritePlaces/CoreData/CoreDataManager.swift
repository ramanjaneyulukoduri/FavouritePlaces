//
//  CoreDataManager.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 04/05/22.
//

import Foundation
import CoreData


/// CoreDataManager to manage core data stacks
struct CoreDataManager {
    
    static let shared = CoreDataManager()
    let viewContext = PersistenceController.shared.container.viewContext
    
    
    /// Function to retriev data from Coredata when application launches
    /// - Returns: array of model
    func getFavouritePlaceModels() -> [FavouritePlaceDataModel]? {
        let fetchRequest: NSFetchRequest<FavouritePlaceModel> = FavouritePlaceModel.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FavouritePlaceModel.location, ascending: true)]
        
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
    
    
    /// Function to add entry in core data
    /// - Parameter favouritePlaceDataModel: model containing all information.
    func addItem(favouritePlaceDataModel: FavouritePlaceDataModel) {
        let _ = convertDataModelToCoreDataModel(favouritePlaceDataModel: favouritePlaceDataModel)
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    /// Function to update any new values when user changed information
    /// - Parameter favouritePlaceDataModels: model containing all information.
    func syncCoreData(favouritePlaceDataModels: [FavouritePlaceDataModel]) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavouritePlaceModel")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try viewContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
        
        for favouritePlaceDataModel in favouritePlaceDataModels {
            addItem(favouritePlaceDataModel: favouritePlaceDataModel)
        }
    }
    
    
    /// Function to convert local structure to CoreData Model
    /// - Parameter favouritePlaceDataModel: Local stuct model
    /// - Returns: Core data model
    func convertDataModelToCoreDataModel(favouritePlaceDataModel: FavouritePlaceDataModel) -> FavouritePlaceModel {
        let favouritePlaceModel = FavouritePlaceModel(context: viewContext)
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

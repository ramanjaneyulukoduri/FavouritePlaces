//
//  MapViewModel.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 09/05/22.
//

import Combine
import CoreLocation

final class FavouritePlaceObservableModel: ObservableObject {
    
    @Published var searchBarText = ""
    @Published var favouritePlaceModels: [FavouritePlaceDataModel] = []
    
    init() {
        updateFavouritePlaceModels()
    }
   
    /// Function to get data from core data when view appears
    func updateFavouritePlaceModels() {
        if let models = CoreDataManager.shared.getFavouritePlaceModels(), models.count > 0 {
            favouritePlaceModels = models
        } else {
            favouritePlaceModels = getDemoEntries()
        }
    }
    
    func getDemoEntries() -> [FavouritePlaceDataModel] {
        let demoEntries = [FavouritePlaceDataModel(id: UUID(), imageURL: "https://picsum.photos/id/1018/200/300", location: "Amazon", enterLocationDetailsText: "Enter Location Details: ", locationDescription: "Nature", latitude: "-32.0", longitude: "151.28"),
                           FavouritePlaceDataModel(id: UUID(), imageURL: "https://picsum.photos/id/1018/200/300", location: "Wild", enterLocationDetailsText: "Enter Location Details: ", locationDescription: "Natural environment", latitude: "-32.0", longitude: "151.28"),
                           FavouritePlaceDataModel(id: UUID(), imageURL: "https://picsum.photos/id/1018/200/300", location: "Forest", enterLocationDetailsText: "Enter Location Details: ", locationDescription: "Natural environment", latitude: "-32.0", longitude: "151.28")]
        return demoEntries
    }
    
    /// Function to update coredata model
    func syncWithCoreData() {
        CoreDataManager.shared.syncCoreData(favouritePlaceDataModels: favouritePlaceModels)
    }
    
    
    /// Function to add new default entry
    func addItem() {
            favouritePlaceModels.append(FavouritePlaceDataModel(id: UUID(),
                                                                location: "New Places \(favouritePlaceModels.count) "))
        syncWithCoreData()
    }
    /// function to delete entry from screen and coredata
    /// - Parameter offsets: index of deleted item
    func deleteItems(offsets: IndexSet) {
            favouritePlaceModels.remove(atOffsets: offsets)
            syncWithCoreData()
    }

}

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
   
    /// Function to get data from core data when view appears
    func updateFavouritePlaceModels() {
        favouritePlaceModels = CoreDataManager.shared.getFavouritePlaceModels() ?? []
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

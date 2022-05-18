//
//  MapViewViewModel.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 18/05/22.
//

import SwiftUI
import MapKit

class MapViewViewModel: ObservableObject {
    var favouritePlaceModel: FavouritePlaceDataModel = FavouritePlaceDataModel(id: UUID(), imageURL: "", latitude: "", location: "", enterLocationDetailsText: "", locationDescription: "", longitude: "")
    @ObservedObject var favouritePlaceObservableModel: FavouritePlaceObservableModel = FavouritePlaceObservableModel()
    @Published var latitudeTextField: String = "35.0"
    @Published var longitudeTextField: String = "35.0"
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    /// Get initial values from master view and show in parent view
    func syncDataFromModel() {
        latitudeTextField = favouritePlaceModel.latitude ?? "0.0"
        longitudeTextField = favouritePlaceModel.longitude ?? "0.0"
        region.center.latitude = Double(latitudeTextField) ?? region.center.latitude
        region.center.longitude = Double(longitudeTextField) ?? region.center.longitude
    }
    
    func doneButtonAction() {
        region.center.latitude = Double(latitudeTextField) ?? region.center.latitude
        region.center.longitude = Double(longitudeTextField) ?? region.center.longitude
    }
    
    func syncMasterModel() {
        favouritePlaceModel.latitude = latitudeTextField
        favouritePlaceModel.longitude = longitudeTextField
        for (index, item) in favouritePlaceObservableModel.favouritePlaceModels.enumerated() {
            if item.id == favouritePlaceModel.id {
                favouritePlaceObservableModel.favouritePlaceModels[index] = favouritePlaceModel
            }
        }
    }
}

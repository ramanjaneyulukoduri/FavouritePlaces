//
//  MapViewViewModel.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 18/05/22.
//

import SwiftUI
import MapKit

class MapViewViewModel: ObservableObject {
    var favouritePlaceModel: FavouritePlaceDataModel = FavouritePlaceDataModel(id: UUID(), imageURL: "",  location: "", enterLocationDetailsText: "", locationDescription: "", latitude: "", longitude: "")
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
    
    ///Done button action
    func doneButtonAction() {
        region.center.latitude = Double(latitudeTextField) ?? region.center.latitude
        region.center.longitude = Double(longitudeTextField) ?? region.center.longitude
    }
    
    ///Update parent model when map view disappear
    func syncMasterModel() {
        favouritePlaceModel.latitude = "\(region.center.latitude)"
        favouritePlaceModel.longitude =  "\(region.center.longitude)"
        getNetworkData {
            for (index, item) in self.favouritePlaceObservableModel.favouritePlaceModels.enumerated() {
                if item.id == self.favouritePlaceModel.id {
                    self.favouritePlaceObservableModel.favouritePlaceModels[index] = self.favouritePlaceModel
                }
            }
        }
    }
    
    /// Calling API to get latest weather information for updated location
    /// - Parameter completion: return completion block after getting response from server
    func getNetworkData(completion: @escaping () -> ()) {
        NetworkManager.shared.getWeatherInformation(latitude: favouritePlaceModel.latitude ?? "",
                                                    longitude: favouritePlaceModel.longitude ?? "") { [self] weatherInformation, error in
            self.favouritePlaceModel.sunrise = weatherInformation?.sunrise ?? ""
            self.favouritePlaceModel.sunset = weatherInformation?.sunset ?? ""
            completion()
        }
    }
}

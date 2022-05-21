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
    @Published var mapView = MKMapView()
    @Published var searchText: String = ""
    @Published var places: [Place] = []
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
       // syncMasterModel()
    }
    
    ///Update parent model when map view disappear
    func syncMasterModel() {
        favouritePlaceModel.latitude = "\(region.center.latitude)"
        favouritePlaceModel.longitude =  "\(region.center.longitude)"
        getNetworkData {
            for (index, item) in self.favouritePlaceObservableModel.favouritePlaceModels.enumerated() {
                if item.id == self.favouritePlaceModel.id {
                    DispatchQueue.main.async {
                        self.favouritePlaceObservableModel.favouritePlaceModels[index] = self.favouritePlaceModel

                    }
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
    
    
    func searchQuery() {
        places.removeAll()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        MKLocalSearch(request: request).start { response, error in
            
            guard let result = response else { return }
            self.places = result.mapItems.compactMap({ item -> Place? in
                return Place(placemark: item.placemark)
            })
        }
    }
    
    func selectPlace(place: Place){
        searchText = ""
        guard let coordinates = place.placemark.location?.coordinate else { return }
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinates
        let title = place.placemark.name ?? "No Name"
        pointAnnotation.title = title
        favouritePlaceModel.location = title
        region.center.latitude = coordinates.latitude
        region.center.longitude = coordinates.longitude
        latitudeTextField = "\(coordinates.latitude)"
        longitudeTextField = "\(coordinates.longitude)"
        
    }
}

//
//  MapViewModel.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 09/05/22.
//

import Foundation
import CoreLocation

final class MapViewModel: ObservableObject {
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServiceEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
        } else {
            print("Location service in unavailable")
        }
    }
}

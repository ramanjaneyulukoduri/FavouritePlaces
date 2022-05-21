//
//  Place.swift
//  FavouritePlaces
//
//  Created by Ajay Girolkar on 21/05/22.
//

import Foundation
import MapKit

struct Place: Identifiable {
    var id = UUID().uuidString
    var placemark: CLPlacemark
}

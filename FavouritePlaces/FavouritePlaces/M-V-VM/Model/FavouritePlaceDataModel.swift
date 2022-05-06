//
//  FavouritePlaceDataModel.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 06/05/22.
//

import Foundation
import Combine

class FavouritePlaceDataModel: ObservableObject, Identifiable {
    var id: UUID
    var imageURL: String?
    var latitude: String?
    var location: String?
    var enterLocationDetailsText: String?
    var locationDescription: String?
    var longitude: String?
    
    init(id: UUID, imageURL: String? = nil, latitude: String? = nil, location: String? = nil, enterLocationDetailsText: String? = nil, locationDescription: String? = nil, longitude: String? = nil) {
        self.id = id
        self.imageURL = imageURL
        self.latitude = latitude
        self.location = location
        self.enterLocationDetailsText = enterLocationDetailsText
        self.locationDescription = locationDescription
        self.longitude = longitude
    }
}

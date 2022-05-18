//
//  FavouritePlaceDataModel.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 06/05/22.
//

import Foundation
import Combine


/// Structure to store data for master and chid view
struct FavouritePlaceDataModel: Identifiable {
    var id: UUID
    var imageURL: String?
    var location: String?
    var enterLocationDetailsText: String?
    var locationDescription: String?
    var latitude: String?
    var longitude: String?
}

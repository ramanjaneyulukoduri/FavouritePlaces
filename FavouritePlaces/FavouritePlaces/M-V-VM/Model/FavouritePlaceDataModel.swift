//
//  FavouritePlaceDataModel.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 06/05/22.
//

import Foundation
import Combine

struct FavouritePlaceDataModel: Identifiable {
    var id: UUID
    var imageURL: String?
    var latitude: String?
    var location: String?
    var enterLocationDetailsText: String?
    var locationDescription: String?
    var longitude: String?
}

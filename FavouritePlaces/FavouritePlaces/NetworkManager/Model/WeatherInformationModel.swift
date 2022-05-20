//
//  WeatherInformationModel.swift
//  FavouritePlaces
//
//  Created by Ajay Girolkar on 20/05/22.
//

import Foundation


struct WeatherResponse: Codable {
    let results: WeatherInformation?
    let status: String?
}

struct WeatherInformation: Codable {
    let sunrise: String?
    let sunset: String?
    let solar_noon: String?
    let day_length: String?
}

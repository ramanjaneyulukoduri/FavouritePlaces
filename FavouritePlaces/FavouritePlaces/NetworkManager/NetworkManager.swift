//
//  NetworkManager.swift
//  FavouritePlaces
//
//  Created by Ajay Girolkar on 20/05/22.
//

import Foundation


class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {
        
    }
    
    func getWeatherInformation(latitude: String, longitude: String, completionHandler: @escaping (WeatherInformation?, Error?) -> ()) {
        if latitude.isEmpty, longitude.isEmpty { return completionHandler(nil, nil)}
        let urlString = "https://api.sunrise-sunset.org/json?lat=\(latitude)&lng=\(longitude)"
        guard let url =  URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            
            if let data = data {
                let weatherResponse =  try? JSONDecoder().decode(WeatherResponse.self, from: data)
                completionHandler(weatherResponse?.results, nil)
            }
        })
        task.resume()
        return
    }
    
}

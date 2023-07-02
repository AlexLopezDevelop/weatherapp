//
//  Api.swift
//  weatherapp
//
//  Created by Alex Lopez on 28/6/23.
//

import Foundation

let baseUrl = "https://api.openweathermap.org/data/3.0/onecall"

func getWeatherDataByCoordinates(latitude: Double, longitude: Double, language: String, completion: @escaping (WeatherData?, Error?) -> Void) {
    
    guard !Enviroment.apiKey.isEmpty else {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No API Key"])
        completion(nil, error)
        return
    }
    
    let url = "\(baseUrl)?&lat=\(latitude)&lon=\(longitude)&lang=\(language)&units=metric&appid=\(Enviroment.apiKey)"
    
    guard let url = URL(string: url) else {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        completion(nil, error)
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Error API call: \(error?.localizedDescription ?? "")")
            completion(nil, error)
            return
        }
        
        do {
            let json = try JSONDecoder().decode(WeatherData.self, from: data)
            completion(json, nil)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil, error)
        }
    }.resume()
}


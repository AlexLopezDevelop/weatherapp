//
//  Api.swift
//  weatherapp
//
//  Created by Alex Lopez on 28/6/23.
//

import Foundation

let baseUrl = "https://api.openweathermap.org/data/3.0/onecall"

func getWeatherDataByCoordinates(latitude: Double, longitude: Double, language: String, completion: @escaping (WeatherData?, Error?) -> Void) {
    
    if Enviroment.apiKey == "" {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No API Key"])
        completion(nil, error)
        return
    }
    
    
    
    let url =  "\(baseUrl)?&lat=\(latitude)&lon=\(longitude)&lang=\(language)&units=metric&appid=\(Enviroment.apiKey)"
    
    URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
        guard let data = data, error == nil else {
            print("Error Api call")
            completion(nil, error)
            return
        }
        
        var json: WeatherData?
        
        do {
            json = try JSONDecoder().decode(WeatherData.self, from: data)
        } catch {
            print("Error \(error)")
        }
        
        guard let weatherData = json else {
            return
        }
        
        completion(weatherData, nil)
      
    }).resume()
}

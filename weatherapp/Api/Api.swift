//
//  Api.swift
//  weatherapp
//
//  Created by Alex Lopez on 28/6/23.
//

import Foundation

let baseUrl = "https://api.openweathermap.org/data/3.0/onecall?lat=33.44&lon=-94.04&units=metric&appid=5b21269625255535dd2fcb969cdf9602"

func getWeatherDataByCoordinates(latitude: Double, longitude: Double, completion: @escaping (WeatherData?, Error?) -> Void) {
    
    let url = baseUrl
    
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
    
    //let decoder = JSONDecoder()
    
    //return nil
}

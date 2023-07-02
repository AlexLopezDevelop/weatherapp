//
//  Utils.swift
//  weatherapp
//
//  Created by Alex Lopez on 29/6/23.
//

import Foundation
import UIKit
import CoreLocation

func convertUnixDateTimeToHuman(timestamp: Int) -> String? {
    guard timestamp > 0 else {
        return nil
    }
    
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h a" // Hour and AM/PM indicator
    
    return dateFormatter.string(from: date)
}

func getUIImageFromImagename(imageName: String) -> UIImage? {
    switch imageName {
    case "01n", "02n", "03n", "04n", "09n", "10n", "11n", "13n", "50n":
        let dayImageName = imageName.replacingOccurrences(of: "n", with: "d")
        return UIImage(named: dayImageName)
    default:
        return UIImage(named: imageName)
    }
}

func uppercaseFirstCharacter(string: String) -> String {
    let firstChar = string.prefix(1).uppercased()
    let remainingChars = string.dropFirst()
    
    return firstChar + remainingChars
}

func getLocationFromTimezone(timezone: String) -> String {
    // Definir la expresión regular para extraer la ciudad y reemplazar el guion bajo por un espacio
    let regex = try! NSRegularExpression(pattern: "[^/]+$")

    if let match = regex.firstMatch(in: timezone, range: NSRange(location: 0, length: timezone.utf16.count)) {
        var cityName = (timezone as NSString).substring(with: match.range)
        cityName = cityName.replacingOccurrences(of: "_", with: " ")
        return cityName
    } else {
        print("Error getting city name")
        return ""
    }
}

func getCityNameFromLocation(location: CLLocation, completion: @escaping (String?) -> Void) {
    let geocoder = CLGeocoder()

    geocoder.reverseGeocodeLocation(location) { placemarks, error in
        if let placemark = placemarks?.first {
            let cityName = placemark.locality
            completion(cityName)
        } else {
            completion(nil)
        }
    }
}

func getCurrentLanguage(codeLang: String) -> String {
    
    switch codeLang {
        case "es":
            return "es"
        case "en":
            return "en"
        case "ca":
            return "ca"
        default:
            return "en"
    }
}

func extractLanguageCode(languageCode: String) -> String? {
    let regex = try! NSRegularExpression(pattern: "^[a-z]{2}")
    let range = NSRange(location: 0, length: languageCode.count)
    if let match = regex.firstMatch(in: languageCode, options: [], range: range) {
        return (languageCode as NSString).substring(with: match.range)
    }
    return nil
}

// MARK: - Gradient Background color

func getBackgroundColor(code: String) -> (colorTop: CGColor, colorBottom: CGColor) {
    
    // default color
    var colorTop = UIColor(red: 127.0/255.0, green: 127.0/255.0, blue: 213.0/255.0, alpha: 1).cgColor
    var colorBottom = UIColor(red: 145.0/255.0, green: 234.0/255.0, blue: 228.0/255.0, alpha: 1).cgColor
    
    switch (code) {
        case "01n", "01d", "02n", "02d": // clear sky && few clouds
            // sun color
            colorTop = UIColor(red: 255.0/255.0, green: 145.0/255.0, blue: 83.0/255.0, alpha: 1).cgColor
            colorBottom = UIColor(red: 238.0/255.0, green: 201.0/255.0, blue: 82.0/255.0, alpha: 1).cgColor
            
        case "03n", "03d": // scattered clouds
            colorTop = UIColor(red: 41.0/255.0, green: 128.0/255.0, blue: 185.0/255.0, alpha: 1).cgColor
            colorBottom = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor
            break
        case "04n", "04d": // broken clouds
            colorTop = UIColor(red: 77.0/255.0, green: 84.0/255.0, blue: 84.0/255.0, alpha: 1).cgColor
            colorBottom = UIColor(red: 171.0/255.0, green: 188.0/255.0, blue: 190.0/255.0, alpha: 1).cgColor
            break
        case "10n", "10d", "09n", "09d", "11n", "11d": // rain && shower rain && thunderstorm
            // rain color
            colorTop = UIColor(red: 71.0/255.0, green: 139.0/255.0, blue: 214.0/255.0, alpha: 1).cgColor
            colorBottom = UIColor(red: 37.0/255.0, green: 216.0/255.0, blue: 221.0/255.0, alpha: 1).cgColor
            break
        
        case "13n", "13d": // snow
            // snow color
            colorTop = UIColor(red: 176.0/255.0, green: 224.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
            colorBottom = UIColor(red: 255.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 0.5).cgColor
            break
        
        case "50n", "50d": // mist
            // fog color
            colorTop = UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 133.0/255.0, alpha: 1).cgColor
            colorBottom = UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 170.0/255.0, alpha: 0.8).cgColor
            break
            
        default:
            break
            
    }
    
    return (colorTop: colorTop, colorBottom: colorBottom)
}

func addGradient(to view: UIView, colorTop: CGColor, colorBottom: CGColor) {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame = view.bounds
    
    view.layer.insertSublayer(gradientLayer, at: 0)
}

func removeGradient(from view: UIView) {
    if let sublayers = view.layer.sublayers {
        for layer in sublayers {
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
    }
}

// MARK: - Button Configuration

func filledButtonConfiguration() -> UIButton.Configuration {
    var buttonConfig = UIButton.Configuration.filled()
    buttonConfig.baseBackgroundColor = UIColor.systemBlue
    buttonConfig.cornerStyle = .medium
    buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
    
    return buttonConfig
}

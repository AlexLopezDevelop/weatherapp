//
//  Utils.swift
//  weatherapp
//
//  Created by Alex Lopez on 29/6/23.
//

import Foundation
import UIKit

func convertUnixDateTimeToHuman(timestamp: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h a" // Hour and AM/PM indicator
    return dateFormatter.string(from: date)
}

func getUIImageFromImagename(imageName: String) -> UIImage {
    switch (imageName) {
        case "01n":
            return UIImage(named: "01d")!
        case "02n":
            return UIImage(named: "02d")!
        case "03n":
            return UIImage(named: "03d")!
        case "04n":
            return UIImage(named: "04d")!
        case "09n":
            return UIImage(named: "09d")!
        case "10n":
            return UIImage(named: "10d")!
        case "11n":
            return UIImage(named: "11d")!
        case "13n":
            return UIImage(named: "13d")!
        case "50n":
            return UIImage(named: "50d")!
        default:
            return UIImage(named: imageName)!
    }
}

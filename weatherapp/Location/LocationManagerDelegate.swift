//
//  CLLocationManagerDelegate.swift
//  weatherapp
//
//  Created by Alex Lopez on 2/7/23.
//

import Foundation
import CoreLocation

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    private weak var viewController: ViewController?

    init(viewController: ViewController) {
        self.viewController = viewController
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        viewController?.checkLocationPermission()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first, viewController?.currentLocation == nil {
            viewController?.currentLocation = currentLocation
            manager.stopUpdatingLocation()
            viewController?.activityIndicator.startAnimating()
            viewController?.requestWeatherForLocation()
        }
    }
}


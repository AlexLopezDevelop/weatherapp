//
//  ViewController.swift
//  weatherapp
//
//  Created by Alex Lopez on 28/6/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var table:    UITableView!
    
    let locationManager     = CLLocationManager()
    var weatherData              = WeatherData()
    var currentLocation:    CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(HourlyTableViewCell.nib(),   forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(),  forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        table.delegate          = self
        table.dataSource        = self

        table.backgroundColor   = .white
        table.separatorStyle    = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupLocation()
    }
    
    // MARK: - Location
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        
        let longitude   = currentLocation.coordinate.longitude
        let latitude    = currentLocation.coordinate.latitude
        
        getWeatherDataByCoordinates(latitude: 37.7749, longitude: -122.4194) { weatherData, error in
            if let weatherData = weatherData {
            
                self.weatherData = weatherData
                
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            
                
            } else if let error = error {
                // TODO: Handle the error
                print(error)
            }
        }
        
        print("Current Location: \(latitude), \(longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if weatherData.timezone == nil {
            return 0
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return weatherData.hourly!.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
            
            cell.configuration(with: weatherData.current!)
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            
            cell.configuration(with: weatherData.hourly![indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        } else if indexPath.section == 1 {
            return 50
        }
        
        return 0
    }
}


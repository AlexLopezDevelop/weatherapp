//
//  ViewController.swift
//  weatherapp
//
//  Created by Alex Lopez on 28/6/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EnableLocationViewDelegate {
    
    @IBOutlet var tableView:    UITableView!
    
    let activityIndicator       = UIActivityIndicatorView(style: .large)
    var weatherData             = WeatherData()
    let enableLocationView      = EnableLocationView()
    let locationManager         = CLLocationManager()
    var locationManagerDelegate : LocationManagerDelegate?
    var currentLocation         : CLLocation?
    var cityName                : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupEnableLocationView()
        setupLocation()
        setupActivityIndicator()
    }
    
    func setupTableView() {
        tableView.register(HourlyTableViewCell.nib(),   forCellReuseIdentifier: HourlyTableViewCell.identifier)
        tableView.register(WeatherTableViewCell.nib(),  forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.backgroundColor   = .clear
        tableView.separatorStyle    = .none
        
        let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshWeatherData), for: .valueChanged)
            tableView.refreshControl = refreshControl
    }
    
    func setupEnableLocationView() {
        enableLocationView.delegate = self
        self.view.addSubview(enableLocationView)
           
        enableLocationView.translatesAutoresizingMaskIntoConstraints = false
        enableLocationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        enableLocationView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        enableLocationView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        enableLocationView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        let backgroundColors = getBackgroundColor(code: "")
        removeGradient(from: self.view)
        addGradient(to: self.view, colorTop: backgroundColors.colorTop, colorBottom: backgroundColors.colorBottom)
        
        enableLocationView.isHidden = false
    }



    func setupActivityIndicator() {
        activityIndicator.center            = self.view.center
        activityIndicator.color             = .white
        activityIndicator.hidesWhenStopped  = true
        self.view.addSubview(activityIndicator)
    }
    
    func enableLocationButtonTapped() {
            requestLocationPermissions()
        }
    
    @objc func refreshWeatherData() {
        requestWeatherForLocation()
    }
    
    // MARK: - Alerts
    
    @objc func requestLocationPermissions() {
        let alertController = UIAlertController(
            title: NSLocalizedString("LOCATION_PERMISSION_DENIED_TITLE", comment: "Location Permission Denied"),
            message: NSLocalizedString("LOCATION_PERMISSION_DENIED_MESSAGE", comment: "Please enable location permission from settings."),
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(
            title: NSLocalizedString("SETTINGS", comment: "Settings"),
            style: .default,
            handler: { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        )
        
        alertController.addAction(settingsAction)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("CANCEL", comment: "Cancel"), style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Location
    
    func setupLocation() {
        locationManagerDelegate = LocationManagerDelegate(viewController: self)
        locationManager.delegate = locationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func checkLocationPermission() {
        let status = locationManager.authorizationStatus
               
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            enableLocationView.isHidden = true
            tableView.isHidden = false
            requestWeatherForLocation()
        case .denied, .restricted:
            enableLocationView.isHidden = false
            tableView.isHidden = true
        case .notDetermined:
            enableLocationView.isHidden = false
            tableView.isHidden = true
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
           checkLocationPermission()
       }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        
        let longitude       = currentLocation.coordinate.longitude
        let latitude        = currentLocation.coordinate.latitude
        let language        = Locale.preferredLanguages.first ?? ""
        let currentLanguage = getCurrentLanguage(codeLang: extractLanguageCode(languageCode: language) ?? "")
        
        getCityNameFromLocation(location: currentLocation) { cityName in
               DispatchQueue.main.async {
                   self.cityName = cityName ?? ""
               }
           }
        
        getWeatherDataByCoordinates(latitude: latitude, longitude: longitude, language: currentLanguage) { weatherData, error in
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.refreshControl?.endRefreshing()
            }
            
            if let weatherData = weatherData,
               let currentWeather = weatherData.current,
               let weatherIcon = currentWeather.weather?.first?.icon {
                
                self.weatherData = weatherData
                
                let backgroundColors = getBackgroundColor(code: weatherIcon)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                    removeGradient(from: self.view)
                    addGradient(to: self.view, colorTop: backgroundColors.colorTop, colorBottom: backgroundColors.colorBottom)
                }
                
            } else if let error = error {
                print(error)
            }
        }
        
        print("Current Location: \(latitude), \(longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            activityIndicator.startAnimating()
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else {
                return UITableViewCell()
            }
            
            cell.backgroundColor = .clear
            cell.configuration(with: weatherData, cityName: cityName)
            
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as? HourlyTableViewCell,
                  let hourlyData = weatherData.hourly?[indexPath.row] else {
                return UITableViewCell()
            }
            
            cell.backgroundColor = .clear
            cell.configuration(with: hourlyData)
            
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


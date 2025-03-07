//
//  ViewController.swift
//  weatherapp
//
//  Created by Alex Lopez on 28/6/23.
//

import UIKit
import CoreLocation
import GoogleMobileAds
import StoreKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EnableLocationViewDelegate, BannerViewDelegate {
    
    @IBOutlet var tableView:    UITableView!
    
    let activityIndicator       = UIActivityIndicatorView(style: .large)
    var weatherData             = WeatherData()
    let enableLocationView      = EnableLocationView()
    let locationManager         = CLLocationManager()
    var locationManagerDelegate : LocationManagerDelegate?
    var currentLocation         : CLLocation?
    var cityName                : String = ""
    var bannerView              : BannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupEnableLocationView()
        setupLocation()
        setupActivityIndicator()
        setupBannerView()
        
        // Track app launches for review prompt logic
        incrementAppLaunchCount()
    }
    
    // Add this new method to setup the AdMob banner
    func setupBannerView() {
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).width
        
        // Create adaptive banner size based on current orientation
        let adaptiveSize = currentOrientationAnchoredAdaptiveBanner(width: viewWidth)
        bannerView = BannerView(adSize: adaptiveSize)
        
        bannerView.adUnitID = "ca-app-pub-5574323560669848/3764007261"
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        // Load the ad
        bannerView.load(Request())
    }
    
    // Add banner to view after receiving ad
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        print("bannerViewDidReceiveAd")
        addBannerViewToView(bannerView)
        
        // Add bottom inset to tableView to prevent banner from covering content
        let bannerHeight = bannerView.adSize.size.height
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bannerHeight, right: 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: bannerHeight, right: 0)
    }
    
    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: BannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: BannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: BannerView) {
        print("bannerViewWillDismissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: BannerView) {
        print("bannerViewDidDismissScreen")
    }
    
    func addBannerViewToView(_ bannerView: BannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        
        // Add constraints to position the banner at the bottom of the screen
        NSLayoutConstraint.activate([
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // Optional: Add animation for a smoother appearance
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
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
                    
                    // Track successful weather data load for review prompt logic
                    self.trackSuccessfulWeatherLoad()
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
    
    // MARK: - App Review Logic
    
    private func incrementAppLaunchCount() {
        let defaults = UserDefaults.standard
        let launchCount = defaults.integer(forKey: "app_launch_count") + 1
        defaults.set(launchCount, forKey: "app_launch_count")
        
        // Check if this is the first launch after an app update
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let lastVersionPromptedForReview = defaults.string(forKey: "last_version_prompted_for_review") ?? ""
        
        if currentVersion != lastVersionPromptedForReview {
            // Reset count of successful weather loads for this version
            defaults.set(0, forKey: "successful_weather_loads_count")
        }
    }
    
    private func trackSuccessfulWeatherLoad() {
        let defaults = UserDefaults.standard
        let successfulLoads = defaults.integer(forKey: "successful_weather_loads_count") + 1
        defaults.set(successfulLoads, forKey: "successful_weather_loads_count")
        
        // Check if we should request a review
        checkAndRequestReview()
    }
    
    private func checkAndRequestReview() {
        let defaults = UserDefaults.standard
        
        // Don't show if user has already rated or declined multiple times
        if defaults.bool(forKey: "user_rated_app") {
            return
        }
        
        let launchCount = defaults.integer(forKey: "app_launch_count")
        let successfulLoads = defaults.integer(forKey: "successful_weather_loads_count")
        let lastPromptDate = defaults.object(forKey: "last_review_prompt_date") as? Date
        
        // Logic conditions for showing the review prompt:
        // 1. App has been launched at least 5 times
        // 2. User has successfully loaded weather data at least 3 times
        // 3. It's been at least 14 days since the last prompt (if ever)
        // 4. No more than 3 prompts total
        let totalPrompts = defaults.integer(forKey: "review_prompt_count")
        let promptFrequencyDays = 14.0
        
        let shouldPrompt = launchCount >= 5 &&
                          successfulLoads >= 3 &&
                          totalPrompts < 3 &&
                          (lastPromptDate == nil || 
                           Date().timeIntervalSince(lastPromptDate!) / (60 * 60 * 24) >= promptFrequencyDays)
        
        if shouldPrompt {
            // Update tracking info
            defaults.set(Date(), forKey: "last_review_prompt_date")
            defaults.set(totalPrompts + 1, forKey: "review_prompt_count")
            
            // Store current version to avoid re-prompting for same version
            let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
            defaults.set(currentVersion, forKey: "last_version_prompted_for_review")
            
            // Request review
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if #available(iOS 14.0, *) {
                    if let windowScene = UIApplication.shared.windows.first?.windowScene {
                        SKStoreReviewController.requestReview(in: windowScene)
                    }
                } else {
                    SKStoreReviewController.requestReview()
                }
            }
        }
    }
}


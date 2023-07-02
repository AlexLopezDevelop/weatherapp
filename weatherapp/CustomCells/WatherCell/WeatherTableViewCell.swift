//
//  WeatherTableViewCell.swift
//  weatherapp
//
//  Created by Alex Lopez on 28/6/23.
//

import UIKit
import CoreLocation

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var tempLabel         : UILabel!
    @IBOutlet var cityLabel         : UILabel!
    @IBOutlet var humidityLabel     : UILabel!
    @IBOutlet var windLabel         : UILabel!
    @IBOutlet var descriptionLabel  : UILabel!
    @IBOutlet var iconImageView     : UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
    }
    
    static let identifier = "WeatherTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configuration(with model: WeatherData, cityName: String) {
        if let current = model.current,
           let currentData = current.weather?.first,
           let temp = current.temp,
           let icon = currentData.icon,
           let humidity = current.humidity,
           let windSpeed = current.windSpeed,
           let description = currentData.description {
            self.tempLabel.text = "\(Int(round(temp)))°"
            self.iconImageView.image = getUIImageFromImagename(imageName: icon)
            self.humidityLabel.text = "\(humidity)%"
            self.windLabel.text = "\(Int(round(windSpeed))) m/s"
            self.descriptionLabel.text = uppercaseFirstCharacter(string: description)
            self.cityLabel.text = cityName
        }
    }

}

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
        
        let current     = model.current!
        let currentData = current.weather!.first!                
        self.tempLabel.text         = " \(Int(round(current.temp!)))°"
        self.iconImageView.image    = getUIImageFromImagename(imageName: currentData.icon!)
        self.humidityLabel.text     = "\(current.humidity!)%"
        self.windLabel.text         = "\(Int(round(current.windSpeed!))) m/s"
        self.descriptionLabel.text  = uppercaseFirstCharacter(string: currentData.description!)
        self.cityLabel.text = cityName
    }
}

//
//  HourlyTableViewCell.swift
//  weatherapp
//
//  Created by Alex Lopez on 28/6/23.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
    }
    
    static let identifier = "HourlyTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configuration(with model: Hourly) {
        if let timestamp = model.dt,
           let weather = model.weather?.first,
           let description = weather.description,
           let temp = model.temp,
           let icon = weather.icon {
            self.hourLabel.text = convertUnixDateTimeToHuman(timestamp: timestamp)
            self.descriptionLabel.text = uppercaseFirstCharacter(string: description)
            self.tempLabel.text = "\(Int(round(temp)))°"
            self.iconImageView.image = getUIImageFromImagename(imageName: icon)
        }
    }

}

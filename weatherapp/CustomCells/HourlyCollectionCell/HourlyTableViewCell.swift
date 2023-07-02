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
        self.hourLabel.text = convertUnixDateTimeToHuman(timestamp: model.dt!)
        self.descriptionLabel.text = uppercaseFirstCharacter(string: model.weather!.first!.description!)
        self.tempLabel.text = "\(Int(round(model.temp!)))°"
        self.iconImageView.image = getUIImageFromImagename(imageName: model.weather!.first!.icon!)
    
    }
}

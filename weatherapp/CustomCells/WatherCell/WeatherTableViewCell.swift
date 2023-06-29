//
//  WeatherTableViewCell.swift
//  weatherapp
//
//  Created by Alex Lopez on 28/6/23.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var tempLabel         : UILabel!
    @IBOutlet var feelsLikeLabel    : UILabel!
    @IBOutlet var iconImageView     : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "WeatherTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configuration(with model: Current) {
        self.tempLabel.text      = " \(Int(round(model.temp!)))°"
        //self.feelsLikeLabel.text    = "\(model.feelsLike)"
        self.iconImageView.image = getUIImageFromImagename(imageName: model.weather!.first!.icon!)
        
    
    }
}

//
//  EnableLocationView.swift
//  weatherapp
//
//  Created by Alex Lopez on 2/7/23.
//

import Foundation
import UIKit

class EnableLocationView: UIView {
    weak var delegate: EnableLocationViewDelegate?

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Configure the layout and appearance of the enableLocationView here
        // Add labels, buttons, constraints, etc.
        // Set up the target-action for the enableLocationButton
        
        // Example:
        self.isHidden = true
        self.backgroundColor = .clear
        // Add subviews and configure constraints
        
        let enableLocationLabel = UILabel()
        enableLocationLabel.text = NSLocalizedString("ALLOW_ACCESS_TO_LOCATION", comment: "Allow access location")
        enableLocationLabel.textAlignment = .center
        enableLocationLabel.font = UIFont.boldSystemFont(ofSize: 20) // Set bold and font size
        self.addSubview(enableLocationLabel)
        
        enableLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        enableLocationLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        enableLocationLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let enableLocationButton = UIButton(type: .system)
        enableLocationButton.configuration = filledButtonConfiguration()
        enableLocationButton.setTitle(NSLocalizedString("ENABLE_LOCATION", comment: "Enable location"), for: .normal)
        enableLocationButton.addTarget(self, action: #selector(enableLocationButtonTapped), for: .touchUpInside)
        self.addSubview(enableLocationButton)
        
        enableLocationButton.translatesAutoresizingMaskIntoConstraints = false
        enableLocationButton.topAnchor.constraint(equalTo: enableLocationLabel.bottomAnchor, constant: 20).isActive = true
        enableLocationButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    @objc private func enableLocationButtonTapped() {
        delegate?.enableLocationButtonTapped()
    }
}

protocol EnableLocationViewDelegate: AnyObject {
    func enableLocationButtonTapped()
}


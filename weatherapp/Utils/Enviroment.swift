//
//  Enviroment.swift
//  weatherapp
//
//  Created by Alex Lopez on 2/7/23.
//

import Foundation

public enum Enviroment {
    enum Keys {
        static let apiKey = "API_KEY"
    }
    
    private static let infoDictironary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist not found")
        }
        
        return dict
    }()
    
    static let apiKey: String = {
        guard let apiKeyString = Enviroment.infoDictironary[Keys.apiKey] as? String else {
            fatalError("ApiKey not found in plist")
        }
        return apiKeyString
    }()
}

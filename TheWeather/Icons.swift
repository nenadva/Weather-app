//
//  Icons.swift
//  TheWeather
//
//  Created by Matthew Carroll on 12/5/16.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//

import UIKit

enum Icon: String {
    
    case clear = "clear"
    case lightClouds = "light_clouds"
    case clouds = "clouds"
    case lightRain = "light_rain"
    case rain = "rain"
    case storm = "storm"
    case snow = "snow"
    case fog = "fog"
}

enum IconStyle {
    
    case color
    case grayScale
}

extension Icon {
    
    init?(rawValue: String) {
        switch rawValue {
        case "01d", "01n": self = .clear
        case "02d", "02n": self = .lightClouds
        case "03d", "04d", "03n", "04n": self = .clouds
        case "09d", "09n": self = .lightRain
        case "10d", "10n": self = .rain
        case "11d", "11n": self = .storm
        case "13d", "13n": self = .snow
        case "50d", "50n": self = .fog
            
        default: return nil
        }
    }
    
    func image(style: IconStyle) -> UIImage? {
        let prefix: String
        switch style {
        case .color: prefix = "art_"
        case .grayScale: prefix = "ic_"
        }
        return UIImage(named: prefix + rawValue)
    }
}

 

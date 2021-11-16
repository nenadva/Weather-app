//
//  ForecastViewModel.swift
//  TheWeather
//
//  Created by Matthew Carroll on 12/5/16.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//

import UIKit

struct ForecastViewModel {
    
    let forecast: WeatherForecast
}

extension ForecastViewModel {
    
    var weekDay: String {
        guard let date = forecast.date else { return "--" }
        if Calendar.autoupdatingCurrent.isDateInToday(date) {
            return NSLocalizedString(key: "today")
        }
        if Calendar.autoupdatingCurrent.isDateInTomorrow(date) {
            return NSLocalizedString(key: "tomorrow")
        }
        let formatter = DateFormatter(dateFormat: "EEEE", timeZone: nil)
        return formatter.string(from: date)
    }
    
    var monthDay: String {
        let formatter = DateFormatter(dateFormat: "MMMM d", timeZone: nil)
        return forecast.date.map { formatter.string(from: $0) } ?? "--"
    }
    
    var hiTemp: String {
        return forecast.highTemp?.degreesString ?? "--"
    }
    
    var lowTemp: String {
        return forecast.lowTemp?.degreesString ?? "--"
    }
    
    var icon: UIImage? {
        return Icon(rawValue: forecast.skyCode ?? "")?.image(style: .color)
    }
    
    var phrase: String {
        return forecast.skyPhrase ?? "--"
    }
    
    var humidity: String {
        return forecast.humidity.map { NSLocalizedString(key: "humidity") + ": \($0.percentString)" } ?? "--"
    }
    
    var pressure: String {
        return forecast.pressure.map { NSLocalizedString(key: "pressure") + ": \($0.pressureString)" } ?? "--"
    }
    
    var wind: String {
        if let speed = forecast.windSpeed?.speedString, let direction = forecast.windDirection?.localizedDirection {
            return NSLocalizedString(key: "wind") + ": \(speed) \(direction)"
        }
        return "--"
    }
}

extension Int {
    
    var degreesString: String? {
        return "\(self)°"
    }
    
    var percentString: String {
        return "\(self)%"
    }
    
    var pressureString: String {
        return "\(self) " + NSLocalizedString(key: "pressure.units")
    }
    
    var speedString: String {
        return "\(self) " + NSLocalizedString(key: "speed.units")
    }
}

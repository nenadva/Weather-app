//
//  WeatherForecast.swift
//  TabbediOS
//
//  Created by Matthew Carroll on 8/29/16.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//

import CoreLocation


struct WeatherForecast {
    
    let highTemp: Int?
    let lowTemp: Int?
    let skyPhrase: String?
    let date: Date?
    let skyCode: String?
    
    let humidity: Int?
    let pressure: Int?
    let windSpeed: Int?
    let windDirection: CompassDirection?
}

extension WeatherForecast {
    
    init(d: JSONDictionary) {
        lowTemp = d["temp"]?["min"] as? Int ?? d["main"]?["temp_min"] as? Int
        highTemp = d["temp"]?["max"] as? Int ?? d["main"]?["temp_max"] as? Int
        let array = d["weather"] as? [JSONDictionary]
        skyPhrase = array?.first?["main"] as? String
        humidity = d["humidity"] as? Int
        pressure = d["pressure"] as? Int
        windSpeed = d["speed"] as? Int
        skyCode = (d["weather"] as? [JSONDictionary])?.first?["icon"] as? String
        windDirection = (d["deg"] as? Double).map { CompassDirection(directionDegrees: $0) }
        date = (d["dt"] as? TimeInterval).map { Date(timeIntervalSince1970: $0) }
    }
}

extension WeatherForecast {
    
    static func fiveDayForecast(coordinate: CLLocationCoordinate2D) -> Resource<[WeatherForecast]> {
        let url = fiveDayURL(coordinate: coordinate)
        return Resource<[WeatherForecast]>(url: url, parseJSON: { json in
            guard let dictionary = json as? JSONDictionary,
                let dictionaries = dictionary["list"] as? [JSONDictionary] else { return nil }
            return dictionaries.compactMap(WeatherForecast.init)
        })
    }
    
    static func currentConditions(coordinate: CLLocationCoordinate2D) -> Resource<WeatherForecast> {
        let url = currentConditionsURL(coordinate: coordinate)
        return Resource<WeatherForecast>(url: url, parseJSON: { json in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return WeatherForecast(d: dictionary)
        })
    }
    
    private static func fiveDayURL(coordinate: CLLocationCoordinate2D) -> URL {
        let path = "/forecast/daily?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=imperial&cnt=5&appid=ab298dd3d8f93043e672f412b02fac88"
        return URL(string: baseURL + path)!
    }
    
    private static func currentConditionsURL(coordinate: CLLocationCoordinate2D) -> URL {
        let path = "/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=imperial&appid=ab298dd3d8f93043e672f412b02fac88"
        return URL(string: baseURL + path)!
    }
}


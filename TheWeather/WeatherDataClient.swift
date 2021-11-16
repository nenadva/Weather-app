//
//  WeatherDataClient.swift
//  TheWeather
//
//  Created by Matthew Carroll on 1/3/17.
//  Copyright © 2017 Third Cup lc. All rights reserved.
//

import CoreLocation


let baseURL = "http://api.openweathermap.org/data/2.5"


enum WeatherDataError: String, Error {
    
    case noData = "error.message"
    case fiveDay = "error.message.5day"
    case currentConditions = "error.message.currentConditions"
    
    var message: String {
        return NSLocalizedString(key: rawValue)
    }
}


struct WeatherResponse {
    
    let currentConditions: WeatherForecast?
    let fiveDay: [WeatherForecast]?
    let error: WeatherDataError?
}


final class WeatherDataClient {
    
    private static let client = HTTPClient()
    typealias FetchWeather = (@escaping (WeatherResponse) -> ()) -> ()
    
    static func fetchWeather(coordinate: CLLocationCoordinate2D) -> FetchWeather {
        return { completion in
            var currentConditions: WeatherForecast?
            var fiveDay: [WeatherForecast]?
            let group = DispatchGroup()
            group.enter()
            let currentR = WeatherForecast.currentConditions(coordinate: coordinate)
            client.load(resource: currentR) { forecast in
                currentConditions = forecast
                group.leave()
            }
            group.enter()
            let fiveDayR = WeatherForecast.fiveDayForecast(coordinate: coordinate)
            client.load(resource: fiveDayR) { forecasts in
                fiveDay = forecasts
                group.leave()
            }
            group.notify(queue: DispatchQueue.main) {
                completion(response(currentConditions: currentConditions, fiveDay: fiveDay))
            }
        }
    }
    
    private static func response(currentConditions: WeatherForecast?, fiveDay: [WeatherForecast]?) -> WeatherResponse {
        let error: WeatherDataError?
        switch (currentConditions, fiveDay) {
        case (.none, .none): error = .noData
        case (.some, .none): error = .fiveDay
        case (.none, .some): error = .currentConditions
        default: error = nil
        }
        return WeatherResponse(currentConditions: currentConditions, fiveDay: fiveDay, error: error)
    }
}

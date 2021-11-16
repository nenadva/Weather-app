//
//  AppDelegate.swift
//  TheWeather
//
//  Created by Matthew Carroll on 12/2/16.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var segues: Segues?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window.map { segues = Segues(window: $0) }
        return true
    }
}


private final class Segues {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let navigationController: UINavigationController
    
    init(window: UIWindow) {
        navigationController = window.rootViewController as! UINavigationController
        LocationServices.instance.fetchCurrentLocation(completion: deviceLocationResponse)
        let fiveDayController = navigationController.viewControllers[0] as! FiveDayViewController
        fiveDayController.didSelect = showDetailView
        fiveDayController.didTapHeader = showDetailView
    }

    private func deviceLocationResponse(location: CLLocation?, error: LocationServicesError?) {
        guard error == nil, let location = location else {
            let message = error?.message ?? NSLocalizedString(key: "error.location.unavailable")
            return UIAlertController.show(from: navigationController, title: message, ok: nil)
        }
        let fiveDayController = navigationController.viewControllers[0] as! FiveDayViewController
        fiveDayController.fetchWeather = WeatherDataClient.fetchWeather(coordinate: location.coordinate)
        configureControllerForUITests(controller: fiveDayController)
        if fiveDayController.isViewLoaded {
            fiveDayController.fetchWeather(fiveDayController.weatherResponse)
        }
    }
    
    private func showDetailView(forecast: WeatherForecast) {
        let detail = DailyForecastViewController(forecast: forecast)
        navigationController.pushViewController(detail, animated: true)
        navigationController.isNavigationBarHidden = false
    }
    
    private func configureControllerForUITests(controller: FiveDayViewController) {
        let env = ProcessInfo.processInfo.environment
        guard let lat = env["lat"], let lon = env["lon"],
            let coordinate = CLLocationCoordinate2D(lat: lat, lon: lon) else { return }
        controller.fetchWeather = WeatherDataClient.fetchWeather(coordinate: coordinate)

    }
}

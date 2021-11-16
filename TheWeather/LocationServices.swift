//
//  LocationServices.swift
//
//  Created by Matthew Carroll on 8/26/15.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//


import CoreLocation


protocol LocationServicesDelegate {
    
    func didReceiveLocationServicesUnauthorized(error: LocationServicesError)
    func didReceiveLocationServicesAuthorized()
}


final class LocationServices: NSObject, CLLocationManagerDelegate {
    
    typealias LocationServicesCompletion = (_ location: CLLocation?, _ error: LocationServicesError?) -> ()
    
    private let locationManager = CLLocationManager()
    private var authorizationStatus: CLAuthorizationStatus
    private var locationServicesCompletion: LocationServicesCompletion?
    private var delegates = [String: LocationServicesDelegate]()
    static let instance = LocationServices()
    
    private override init() {
        authorizationStatus = CLLocationManager.authorizationStatus()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func fetchCurrentLocation(completion: @escaping LocationServicesCompletion) {
        locationServicesCompletion = completion
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted, .denied:
            locationManager.requestWhenInUseAuthorization()
            notifyDelegatesUnauthorized()
        case .authorizedWhenInUse, .authorizedAlways:
            if authorizationStatus != .authorizedAlways || authorizationStatus != .authorizedWhenInUse {
                notifyDelegatesAuthorized()
            }
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
            notifyDelegatesUnauthorized()
        }
        authorizationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        callCompletion(location: locations.last, error: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let clerror = CLError(_nsError: error as NSError)
        let message = NSLocalizedString(key: "error.location.unavailable")
        var error: LocationServicesError?
        switch clerror.code {
        case .denied: error = .authorizationDenied(description: message)
        default: error = .locationUnknown(description: message)
        }
        
        callCompletion(location: nil, error: error)
        locationServicesCompletion = nil
    }
    
    func cancelOutstandingRequests() {
        callCompletion(location: nil, error: nil)
        locationManager.stopUpdatingLocation()
    }
    
    private func callCompletion(location: CLLocation?, error: LocationServicesError?) {
        if let locationServicesCompletion = locationServicesCompletion {
            locationServicesCompletion(location, error)
        }
        locationServicesCompletion = nil
    }
    
    private func notifyDelegatesAuthorized() {
        for delegate in delegates.values {
            delegate.didReceiveLocationServicesAuthorized()
        }
    }
    
    private func notifyDelegatesUnauthorized() {
        for delegate in delegates.values {
            let error = LocationServicesError.authorizationDenied(description: NSLocalizedString(key: "error.location.unavailable"))
            delegate.didReceiveLocationServicesUnauthorized(error: error)
        }
    }
    
    func addDelegateWithName(name: String, delegate: LocationServicesDelegate) {
        mainQueue.add { self.delegates[name] = delegate }
    }
    
    func removeDelegateWithName(name: String) {
        mainQueue.add { self.delegates.removeValue(forKey: name) }
    }
}

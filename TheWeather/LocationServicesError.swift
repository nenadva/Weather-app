//
//  LocationServicesError.swift
//
//  Created by Matthew Carroll on 8/18/15.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//

import CoreLocation


enum LocationServicesError: Error {
    
    case locationUnknown(description: String)
    case authorizationDenied(description: String)
    
    var message: String {
        switch self {
        case .locationUnknown(let message): return NSLocalizedString(key: message)
        case .authorizationDenied(let message): return NSLocalizedString(key: message)
        }
    }
}

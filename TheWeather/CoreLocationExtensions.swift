//
//  CoreLocationExtensions.swift
//
//  Created by Matthew Carroll on 4/27/16.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//

import CoreLocation


extension CLLocation {
    
    var coordinateString: String { get {
        let latitude = String(format: "%.2f", coordinate.latitude)
        let longitude = String(format: "%.2f", coordinate.longitude)
        return "\(latitude),\(longitude)"
        }
    }
    
    var lat: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var lon: CLLocationDegrees {
        return coordinate.longitude
    }
}

extension CLLocationCoordinate2D {
    
    init?(string: String) {
        let components = string.components(separatedBy: ",")
        guard let lat = components.first?.trimmingCharacters(in: CharacterSet.whitespaces),
            let lon = components.last?.trimmingCharacters(in: CharacterSet.whitespaces) else { return nil }
        self.init(lat: lat, lon: lon)
    }
    
    init?(lat: String, lon: String) {
        guard let latD = CLLocationDegrees(lat), let longD = CLLocationDegrees(lon) else { return nil }
        self.init(latitude: latD, longitude: longD)
    }
}

extension CLLocationCoordinate2D {
    
    var radiansLatitude: CLLocationDirection {
        return latitude * Double.pi / 180
    }
    
    var radiansLongitude: CLLocationDirection {
        return longitude * Double.pi / 180
    }
    
    var asString: String { get {
        let _latitude = String(format: "%.2f", latitude)
        let _longitude = String(format: "%.2f", longitude)
        return "\(_latitude),\(_longitude)"
        }
    }
}

extension CLLocationCoordinate2D {
    
    func compassDirection(to coordinate: CLLocationCoordinate2D) -> CompassDirection {
        let differenceLat = log(tan(coordinate.radiansLatitude / 2 + Double.pi / 4) / tan(radiansLatitude / 2 + Double.pi / 4))
        var differenceLong = coordinate.radiansLongitude - radiansLongitude
        if abs(differenceLong) > Double.pi {
            if differenceLong > 0 {
                differenceLong = -(2 * Double.pi - differenceLong)
            }
            else {
                differenceLong = 2 * Double.pi + differenceLong
            }
        }
        let deg = rad2Deg(radians: atan2(differenceLong, differenceLat))
        let angle = (deg + 360.0).truncatingRemainder(dividingBy: 360)
        return CompassDirection(directionDegrees: angle)
    }
    
    private func rad2Deg(radians: Double) -> CLLocationDegrees {
        return radians * 180 / Double.pi
    }
}


enum CompassDirection {
    case N
    case NNE
    case NE
    case ENE
    case E
    case ESE
    case SE
    case SSE
    case S
    case SSW
    case SW
    case WSW
    case W
    case WNW
    case NW
    case NNW
}

extension CompassDirection {
    
    init(directionDegrees: CLLocationDegrees) {
        let direction = Int(round(directionDegrees / 22.5))
        switch direction {
        case 1: self = .NNE
        case 2: self = .NE
        case 3: self = .ENE
        case 4: self = .E
        case 5: self = .ESE
        case 6: self = .SE
        case 7: self = .SSE
        case 8: self = .S
        case 9: self = .SSW
        case 10: self = .SW
        case 11: self = .WSW
        case 12: self = .W
        case 13: self = .WNW
        case 14: self = .NW
        case 15: self = .NNW
        default: self = .N
        }
    }
    
    var localizedDirection: String {
        let key: String
        switch self {
        case .N: key = "direction.north"
        case .NNE: key = "direction.north-northeast"
        case .NE: key = "direction.northeast"
        case .ENE: key = "direction.east-northeast"
        case .E: key = "direction.east"
        case .ESE: key = "direction.east-southeast"
        case .SE: key = "direction.southeast"
        case .SSE: key = "direction.south-southeast"
        case .S: key = "direction.south"
        case .SSW: key = "direction.south-southwest"
        case .SW: key = "direction.southwest"
        case .WSW: key = "direction.west-southwest"
        case .W: key = "direction.west"
        case .WNW: key = "direction.west-northwest"
        case .NW: key = "direction.northwest"
        case .NNW: key = "direction.north-northwest"
        }
        return NSLocalizedString(key: key)
    }
}

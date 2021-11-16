//
//  TheWeatherUITests.swift
//  TheWeatherUITests
//
//  Created by Matthew Carroll on 12/2/16.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//

import XCTest
import CoreLocation


class TheWeatherUITests: UITestCase {
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    let client = HTTPClient()
    let baseURL = "http://api.openweathermap.org/data/2.5"
    
    override func setUp() {
        super.setUp()
        coordinate = coordinate2D()
    }
    
    func test0GrantLocationServices() {
        super.tapSystemAlertButton(buttonText: "Allow")
    }
    
    func test1CurrentConditionsHeader() {
        let formatter = DateFormatter(dateFormat: "MMMM d", timeZone: nil)
        formatter.dateFormat = "MMMM d"
        let dateString = formatter.string(from: Date())
        let monthDay = app.descendantMatchingIdentifier(id: "header.monthDay")
        XCTAssert(monthDay.label == dateString, "month day label is incorrect \(monthDay.label)")
        assertMinMaxTemps(location: coordinate)
    }
    
    func assertMinMaxTemps(location: CLLocationCoordinate2D) {
        refreshExpectation()
        let hiTemp = app.descendantMatchingIdentifier(id: "header.hiTemp")
        let currentConditionsURL = URL(string: baseURL + "/weather?lat=\(location.latitude)&lon=\(location.longitude)&units=imperial&appid=ab298dd3d8f93043e672f412b02fac88")!
        
        let currentConditions = Resource<JSONDictionary>(url: currentConditionsURL, parseJSON: { json in
            json as? JSONDictionary
        })
        client.load(resource: currentConditions) { json in
            mainQueue.add {
                guard let main = json?["main"] as? JSONDictionary, let temp = main["temp_max"] as? Double else {
                    return XCTFail("failed to fetch max temp")
                }
                let tempString = Int(temp).description
                var tempLabel = hiTemp.label
                tempLabel.dropLast()
                XCTAssertEqual(tempLabel, tempString, "max temp label is incorrect \(tempLabel)")
            }
            self.expectation.fulfill()
        }
        waitForExpectationsWithDefaultTimeout()
    }
    
    func test5DayCells() {
        refreshExpectation()
        let url = fiveDayURL(lat: coordinate.latitude, lon: coordinate.longitude)
        let fiveDay = Resource<JSONDictionary>(url: url, parseJSON: { json in
            json as? JSONDictionary
        })
        client.load(resource: fiveDay, completion: assertCellsShowCorrectData)
        waitForExpectationsWithDefaultTimeout()
    }
    
    func assertCellsShowCorrectData(json: JSONDictionary?) {
        mainQueue.add {
            guard let days = json?["list"] as? [JSONDictionary] else {
                self.expectation.fulfill()
                return XCTFail("failed to fetch forecasts")
            }
            for i in 1..<5 {
                let d = days[i]
                guard let temp = d["temp"] as? JSONDictionary, let hiTemp = temp["max"] as? Double, let lowTemp = temp["min"] as? Double else {
                    self.expectation.fulfill()
                    return XCTFail("failed to fetch temps")
                }

                let cell = self.app.tables.cells.element(boundBy: i - 1)
                self.assertCellLabel(cell: cell, labelID: "hiTemp", value: hiTemp)
                self.assertCellLabel(cell: cell, labelID: "lowTemp", value: lowTemp)
            }
            self.expectation.fulfill()
        }
    }
    
    func assertCellLabel(cell: XCUIElement, labelID: String, value: Double) {
        let temp = cell.descendantMatchingIdentifier(id: labelID)
        var tempLabel = temp.label
        tempLabel.dropLast()
        let tempInt = Int(value).description
        if tempLabel != tempInt {
            expectation.fulfill()
            XCTFail("temp label is incorrect \(tempLabel)")
        }
    }
    
    func coordinate2D() -> CLLocationCoordinate2D {
        let env = ProcessInfo.processInfo.environment
        guard let lat = env["lat"], let lon = env["lon"], let coordinate = CLLocationCoordinate2D(lat: lat, lon: lon) else {
            let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.78, longitude: -122.40)
            return defaultCoordinate
        }
        return coordinate
    }
    
    func fiveDayURL(lat: CLLocationDegrees, lon: CLLocationDegrees) -> URL {
        let fiveDayURL = URL(string: baseURL + "/forecast/daily?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=imperial&cnt=5&appid=ab298dd3d8f93043e672f412b02fac88")!
        return fiveDayURL
    }
}

//
//  UITestCase.swift
//
//  Created by Matthew Carroll on 1/25/16.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//

import XCTest


class UITestCase: XCTestCase {

    var expectation = XCTestExpectation()
    let sixtySecondDefaultTimeout = TimeInterval(60)
    var app = XCUIApplication()
    var systemAlertToken: NSObjectProtocol = NSObject()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment = ProcessInfo.processInfo.environment
        app.launch()
    }
    
    func tapSystemAlertButton(buttonText: String) {
        systemAlertToken = addUIInterruptionMonitor(withDescription: "") { alert in
            let button = alert.buttons[buttonText]
            guard button.exists else { return false }
            button.tap()
            self.removeUIInterruptionMonitor(self.systemAlertToken)
            return true
        }
        app.swipeLeft()
    }
    
    func backgroundAndForegroundTheApp() {
        XCUIDevice.shared.press(.home)
        app.launch()
    }

    func refreshExpectation() {
        expectation = expectation(description: description)
    }
    
    func waitForExpectationsWithDefaultTimeout() {
        waitForExpectations(timeout: sixtySecondDefaultTimeout) { error in
            XCTAssertNil(error, "Timeout error \(String(describing: error))")
        }
    }
    
}

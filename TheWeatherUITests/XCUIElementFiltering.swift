//
//  XCUIElementFiltering.swift
//  TheWeatherUITests
//
//  Created by Matthew Carroll on 11/24/15.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//

import XCTest
import Foundation


extension XCUIElement {

    func descendantMatchingIdentifier(id: String) -> XCUIElement {
        let predicate = NSPredicate(format: "identifier == %@", "\(id)")
        return descendants(matching: .any).element(matching: predicate)
    }

    func childMatchingIdentifier(id: String) -> XCUIElement {
        let predicate = NSPredicate(format: "identifier == %@", "\(id)")
        return children(matching: .any).element(matching: predicate)
    }
}


extension XCUIElement {
    
    func queryUntilSuccessWithExpectation(expectation: XCTestExpectation, queryInterval: TimeInterval = 0.1, success: @escaping () -> Bool) {
        OperationQueue().addOperation {
            var didSucceed = false
            while !didSucceed {
                OperationQueue.main.addOperation {
                    didSucceed = success()
                    print("\(#function) \(didSucceed)")
                }
                Thread.sleep(forTimeInterval: queryInterval)
            }
            expectation.fulfill()
        }
    }
}

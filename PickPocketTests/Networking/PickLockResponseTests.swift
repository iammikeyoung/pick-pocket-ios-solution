//
//  PickLockResponseTests.swift
//  PickPocketTests
//
//  Created by Maya Saxena on 9/17/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import XCTest
@testable import PickPocket

class PickLockResponseTests: XCTestCase {
    func testPickLockResponse() {
        let close = 2
        let correct = 1

        let serverJSON = [
            "result" : [
                "close" : close,
                "correct": correct
            ]
        ]

        guard let responseData = try? JSONSerialization.data(withJSONObject: serverJSON, options: []) else {
            XCTFail("JSON fixture incorrectly configured")
            return
        }

        if let response = try? JSONDecoder().decode(PickLockResponse.self, from: responseData) {
            XCTAssertEqual(response.result.correct, correct)
            XCTAssertEqual(response.result.misplaced, close)
        } else {
            XCTFail("Test JSON should return guess result")
        }
    }
}

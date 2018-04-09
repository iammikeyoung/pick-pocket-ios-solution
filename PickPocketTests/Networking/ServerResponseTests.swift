//
//  ServerResponseTests.swift
//  PickPocketTests
//
//  Created by Maya Saxena on 4/8/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import XCTest
import Intrepid
@testable import PickPocket

class ServerResponseTests: XCTestCase {

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

        let response = try? JSONDecoder().decode(PickLockResponse.self, from: responseData)

        if let guessResult = response?.result.value {
            XCTAssertEqual(guessResult.correct, correct)
            XCTAssertEqual(guessResult.misplaced, close)
        } else {
            XCTFail("Test JSON should return guess result")
        }
    }

    func testPickLockErrorResponse() {
        let errorMessage = "2 + 2 = fish"

        let serverJSON = [
            "result" : [
                "error" : errorMessage
            ]
        ]

        guard let responseData = try? JSONSerialization.data(withJSONObject: serverJSON, options: []) else {
            XCTFail("JSON fixture incorrectly configured")
            return
        }

        let response = try? JSONDecoder().decode(PickLockResponse.self, from: responseData)

        if let error = response?.result.error as? PickLockError {
            XCTAssertEqual(error.message, errorMessage)
        } else {
            XCTFail("Test JSON should return error message")
        }
    }
}

//
//  ServerResponseTests.swift
//  PickPocketTests
//
//  Created by Maya Saxena on 4/8/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import XCTest
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

        let responseData = try! JSONSerialization.data(withJSONObject: serverJSON, options: [])
        let response = try? JSONDecoder().decode(PickLockResponse.self, from: responseData)

        if case .guessResult(let guessResult)? = response {
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

        let responseData = try! JSONSerialization.data(withJSONObject: serverJSON, options: [])
        let response = try? JSONDecoder().decode(PickLockResponse.self, from: responseData)
        if case .error(let serverErrorMessage)? = response {
            XCTAssertEqual(serverErrorMessage, errorMessage)
        } else {
            XCTFail("Test JSON should return error message")
        }
    }
}

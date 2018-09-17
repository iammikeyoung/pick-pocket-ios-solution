//
//  RequestManagerTests.swift
//  PickPocketTests
//
//  Created by Maya Saxena on 9/17/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import XCTest
@testable import PickPocket

class RequestManagerTests: XCTestCase {
    let requestManager = RequestManager()

    func testPickLockRequest() {
        let userID = "Maya"
        let guess = "245"

        let request = requestManager.createPostRequest(userID: userID, guess: guess)

        XCTAssertEqual(request?.url?.absoluteString, "https://5gbad1ceal.execute-api.us-east-1.amazonaws.com/release/picklock/Maya")
        XCTAssertEqual(request?.httpMethod, "POST")
        XCTAssertEqual(request?.allHTTPHeaderFields?["Content-Type"], "application/json")

        guard
            let httpBody = request?.httpBody,
            let body = try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: String]
            else {
                XCTFail("Request should contain JSON body")
                return
            }

        XCTAssertEqual(body?["guess"], "[2,4,5]")
    }
}

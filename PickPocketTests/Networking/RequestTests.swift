//
//  RequestTests.swift
//  PickPocketTests
//
//  Created by Maya Saxena on 4/8/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import XCTest
@testable import PickPocket

class RequestTests: XCTestCase {

    func testPickLockRequest() {
        let guess = "245"
        let userID = "Maya"

        let request = Request.pickLock(guess: guess, userID: userID)

        XCTAssertEqual(request.urlRequest.url?.absoluteString, "https://5gbad1ceal.execute-api.us-east-1.amazonaws.com/release/picklock/Maya")
        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.contentType, "application/json")
        XCTAssertEqual(request.endpoint, "/picklock/\(userID)")

        guard let body = request.body as? PickLockRequestBody else {
            XCTFail("Body should be of type \(PickLockRequestBody.self)")
            return
        }

        XCTAssertEqual(body.guess, "[2,4,5]")
    }
}

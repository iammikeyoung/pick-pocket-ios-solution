//
//  RemoteLockTests.swift
//  PickPocketTests
//
//  Created by Maya Saxena on 9/17/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import XCTest
@testable import PickPocket

class RemoteLockTests: XCTestCase {
    let requestManager = MockRequestManager()
    func testSubmit() {
        let guess = "123"
        let userID = "Paul"

        let sut = RemoteLock(userID: userID, codeLength: 3, requestManager: requestManager)

        sut.submit(guess: guess) { _ in }

        XCTAssertEqual(requestManager.receivedPostRequest?.guess, guess)
        XCTAssertEqual(requestManager.receivedPostRequest?.userID, userID)
    }
}

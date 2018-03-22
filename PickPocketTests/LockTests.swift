//
//  LockTests.swift
//  LockTests
//
//  Created by Maya Saxena on 3/22/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import XCTest
@testable import PickPocket

class LockTests: XCTestCase {

    func testCorrectGuess() {
        let sut = Lock()
        let result = sut.submit(guess: "123")
        XCTAssertEqual(result.correct, 3)
        XCTAssertEqual(result.misplaced, 0)
    }
}

//
//  LockTests.swift
//  pick-pocket-ios
//
//  Created by Nicholas Servidio on 1/7/17.
//
//

import XCTest
@testable import pick_pocket_ios

class LockTests: XCTestCase {
    func testCorrectGuess() {
        let sut = Lock(code: "123")
        let result = sut.submit(guess: "123")
        XCTAssertEqual(result.correct, 3)
        XCTAssertEqual(result.misplaced, 0)
    }
}

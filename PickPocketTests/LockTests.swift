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
        let sut = Lock(code: "123")
        let result = sut.submit(guess: "123")
        XCTAssertEqual(result.correct, 3)
        XCTAssertEqual(result.misplaced, 0)
    }

    func testOneCorrectOneMisplaced() {
        let sut = Lock(code: "123")
        let result = sut.submit(guess: "134")
        XCTAssertEqual(result.correct, 1)
        XCTAssertEqual(result.misplaced, 1)
    }

    func testOneCorrect() {
        let sut = Lock(code: "123")
        let result = sut.submit(guess: "156")
        XCTAssertEqual(result.correct, 1)
        XCTAssertEqual(result.misplaced, 0)
    }

    func testOneMisplaced() {
        let sut = Lock(code: "123")
        let result = sut.submit(guess: "414")
        XCTAssertEqual(result.correct, 0)
        XCTAssertEqual(result.misplaced, 1)
    }

    func testNoneCorrect() {
        let sut = Lock(code: "123")
        let result = sut.submit(guess: "456")
        XCTAssertEqual(result.correct, 0)
        XCTAssertEqual(result.misplaced, 0)
    }

    func testAllMisplaced() {
        let sut = Lock(code: "123")
        let result = sut.submit(guess: "312")
        XCTAssertEqual(result.correct, 0)
        XCTAssertEqual(result.misplaced, 3)
    }

    func testDuplicatesGuess() {
        let sut = Lock(code: "123")
        let result = sut.submit(guess: "122")
        XCTAssertEqual(result.correct, 2)
        XCTAssertEqual(result.misplaced, 0)
    }

    func testDuplicateMisplaced() {
        let sut = Lock(code: "123")
        let result = sut.submit(guess: "411")
        XCTAssertEqual(result.correct, 0)
        XCTAssertEqual(result.misplaced, 1)
    }

    func testPrecedence() {
        let sut = Lock(code: "123")
        let result = sut.submit(guess: "114")
        XCTAssertEqual(result.correct, 1)
        XCTAssertEqual(result.misplaced, 0)
    }

    func testCorrectPrecedence() {
        let sut = Lock(code: "123")
        let result = sut.submit(guess: "433")
        XCTAssertEqual(result.correct, 1)
        XCTAssertEqual(result.misplaced, 0)
    }

    func testDuplicatesCode() {
        let sut = Lock(code: "2245")
        let result = sut.submit(guess: "1122")
        XCTAssertEqual(result.correct, 0)
        XCTAssertEqual(result.misplaced, 2)
    }

    func testMultiplesMisplaced() {
        let sut = Lock(code: "323")
        let result = sut.submit(guess: "232")
        XCTAssertEqual(result.correct, 0)
        XCTAssertEqual(result.misplaced, 2)
    }

    func testMultiplesMixed() {
        let sut = Lock(code: "323")
        let result = sut.submit(guess: "332")
        XCTAssertEqual(result.correct, 1)
        XCTAssertEqual(result.misplaced, 2)
    }
}

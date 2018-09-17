//
//  LocalLockTests.swift
//  LocalLockTests
//
//  Created by Maya Saxena on 3/22/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import XCTest
@testable import PickPocket

class LocalLockTests: XCTestCase {

    func testCorrectGuess() {
        let sut = LocalLock(code: "123")
        sut.submit(guess: "123") { result in
            XCTAssertEqual(result.value?.correct, 3)
            XCTAssertEqual(result.value?.misplaced, 0)
        }
    }

    func testOneCorrectOneMisplaced() {
        let sut = LocalLock(code: "123")
        sut.submit(guess: "134") { result in
            XCTAssertEqual(result.value?.correct, 1)
            XCTAssertEqual(result.value?.misplaced, 1)
        }
    }

    func testOneCorrect() {
        let sut = LocalLock(code: "123")
        sut.submit(guess: "156") { result in
            XCTAssertEqual(result.value?.correct, 1)
            XCTAssertEqual(result.value?.misplaced, 0)
        }
    }

    func testOneMisplaced() {
        let sut = LocalLock(code: "123")
        sut.submit(guess: "414") { result in
            XCTAssertEqual(result.value?.correct, 0)
            XCTAssertEqual(result.value?.misplaced, 1)
        }
    }

    func testNoneCorrect() {
        let sut = LocalLock(code: "123")
        sut.submit(guess: "456") { result in
            XCTAssertEqual(result.value?.correct, 0)
            XCTAssertEqual(result.value?.misplaced, 0)
        }
    }

    func testAllMisplaced() {
        let sut = LocalLock(code: "123")
        sut.submit(guess: "312") { result in
            XCTAssertEqual(result.value?.correct, 0)
            XCTAssertEqual(result.value?.misplaced, 3)
        }
    }

    func testDuplicatesGuess() {
        let sut = LocalLock(code: "123")
        sut.submit(guess: "122") { result in
            XCTAssertEqual(result.value?.correct, 2)
            XCTAssertEqual(result.value?.misplaced, 0)
        }
    }

    func testDuplicateMisplaced() {
        let sut = LocalLock(code: "123")
        sut.submit(guess: "411") { result in
            XCTAssertEqual(result.value?.correct, 0)
            XCTAssertEqual(result.value?.misplaced, 1)
        }
    }

    func testPrecedence() {
        let sut = LocalLock(code: "123")
        sut.submit(guess: "114") { result in
            XCTAssertEqual(result.value?.correct, 1)
            XCTAssertEqual(result.value?.misplaced, 0)
        }
    }

    func testCorrectPrecedence() {
        let sut = LocalLock(code: "123")
        sut.submit(guess: "433") { result in
            XCTAssertEqual(result.value?.correct, 1)
            XCTAssertEqual(result.value?.misplaced, 0)
        }
    }

    func testDuplicatesCode() {
        let sut = LocalLock(code: "2245")
        sut.submit(guess: "1122") { result in
            XCTAssertEqual(result.value?.correct, 0)
            XCTAssertEqual(result.value?.misplaced, 2)
        }
    }

    func testMultiplesMisplaced() {
        let sut = LocalLock(code: "323")
        sut.submit(guess: "232") { result in
            XCTAssertEqual(result.value?.correct, 0)
            XCTAssertEqual(result.value?.misplaced, 2)
        }
    }

    func testMultiplesMixed() {
        let sut = LocalLock(code: "323")
        sut.submit(guess: "332") { result in
            XCTAssertEqual(result.value?.correct, 1)
            XCTAssertEqual(result.value?.misplaced, 2)
        }
    }

    func testLengthMismatch() {
        let sut = LocalLock(code: "123")
        sut.submit(guess: "12") { result in
            XCTAssertNil(result.value)
        }
    }

    func testEmpty() {
        let sut = LocalLock(code: "123")
        sut.submit(guess: "") { result in
            XCTAssertNil(result.value)
        }
    }

    func testNonNumeric() {
        let sut = LocalLock(code: "123")
        sut.submit(guess: "abc") { result in
            XCTAssertEqual(result.value?.correct, 0)
            XCTAssertEqual(result.value?.misplaced, 0)
        }
    }
}

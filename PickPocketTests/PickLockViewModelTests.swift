//
//  PickLockViewModelTests.swift
//  PickPocketTests
//
//  Created by Maya Saxena on 4/4/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import XCTest
@testable import PickPocket

class PickLockViewModelTests: XCTestCase {

    let lock = Lock(code: "123")
    var viewModel: PickLockViewModel!

    override func setUp() {
        super.setUp()
        viewModel = PickLockViewModel(lock: lock)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialValues() {
        XCTAssertEqual(viewModel.previousGuessHintText, "")
        XCTAssertEqual(viewModel.previousGuessText, "")
        XCTAssertEqual(viewModel.codeLength, "3")
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "")
    }

    func testCorrectGuess() {
        viewModel.handleDigitAdded(digit: "1")

        XCTAssertEqual(viewModel.previousGuessHintText, "")
        XCTAssertEqual(viewModel.previousGuessText, "")
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "1")

        viewModel.handleDigitAdded(digit: "2")

        XCTAssertEqual(viewModel.previousGuessHintText, "")
        XCTAssertEqual(viewModel.previousGuessText, "")
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "12")

        viewModel.handleDigitAdded(digit: "3")

        XCTAssertEqual(viewModel.previousGuessHintText, "⚫⚫⚫")
        XCTAssertEqual(viewModel.previousGuessText, "123")
        XCTAssertEqual(viewModel.lockStatusText, "🔓")
        XCTAssertEqual(viewModel.currentGuess, "")
    }

    func testIncorrectGuess() {
        viewModel.handleDigitAdded(digit: "1")

        XCTAssertEqual(viewModel.previousGuessHintText, "")
        XCTAssertEqual(viewModel.previousGuessText, "")
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "1")

        viewModel.handleDigitAdded(digit: "3")

        XCTAssertEqual(viewModel.previousGuessHintText, "")
        XCTAssertEqual(viewModel.previousGuessText, "")
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "13")

        viewModel.handleDigitAdded(digit: "4")

        XCTAssertEqual(viewModel.previousGuessHintText, "⚫⚪")
        XCTAssertEqual(viewModel.previousGuessText, "134")
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "")
    }

    func testGuessAfterUnlock() {
        viewModel.handleDigitAdded(digit: "1")
        viewModel.handleDigitAdded(digit: "2")
        viewModel.handleDigitAdded(digit: "3")

        XCTAssertEqual(viewModel.previousGuessHintText, "⚫⚫⚫")
        XCTAssertEqual(viewModel.previousGuessText, "123")
        XCTAssertEqual(viewModel.lockStatusText, "🔓")
        XCTAssertEqual(viewModel.currentGuess, "")

        viewModel.handleDigitAdded(digit: "2")

        XCTAssertEqual(viewModel.previousGuessHintText, "")
        XCTAssertEqual(viewModel.previousGuessText, "")
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "2")
    }
}

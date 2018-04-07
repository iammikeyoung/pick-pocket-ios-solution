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


    static let code = "123"
    let lock = Lock(code: PickLockViewModelTests.code)
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
        XCTAssertEqual(viewModel.previousGuessCount, 0)
        XCTAssertEqual(viewModel.codeLength, "3")
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "")
    }

    func testCorrectGuess() {
        viewModel.handleDigitAdded(digit: "1")

        XCTAssertEqual(viewModel.previousGuessCount, 0)
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "1")

        viewModel.handleDigitAdded(digit: "2")

        XCTAssertEqual(viewModel.previousGuessCount, 0)
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "12")

        viewModel.handleDigitAdded(digit: "3")

        XCTAssertEqual(viewModel.previousGuessCount, 1)
        let (hint, guess) = viewModel.hintAndGuess(atIndex: 0)
        XCTAssertEqual(hint, "⚫⚫⚫")
        XCTAssertEqual(guess, "123")
        XCTAssertEqual(viewModel.lockStatusText, "🔓")
        XCTAssertEqual(viewModel.currentGuess, "")
    }

    func testIncorrectGuess() {
        viewModel.handleDigitAdded(digit: "1")

        XCTAssertEqual(viewModel.previousGuessCount, 0)
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "1")

        viewModel.handleDigitAdded(digit: "3")

        XCTAssertEqual(viewModel.previousGuessCount, 0)
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "13")

        viewModel.handleDigitAdded(digit: "4")

        XCTAssertEqual(viewModel.previousGuessCount, 1)
        let (hint, guess) = viewModel.hintAndGuess(atIndex: 0)
        XCTAssertEqual(hint, "⚫⚪")
        XCTAssertEqual(guess, "134")
        XCTAssertEqual(viewModel.previousGuessCount, 1)
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "")
    }

    func testGuessAfterUnlock() {
        viewModel.handleDigitAdded(digit: "1")
        viewModel.handleDigitAdded(digit: "2")
        viewModel.handleDigitAdded(digit: "3")

        XCTAssertEqual(viewModel.previousGuessCount, 1)
        XCTAssertEqual(viewModel.lockStatusText, "🔓")
        XCTAssertEqual(viewModel.currentGuess, "")

        viewModel.handleDigitAdded(digit: "2")

        XCTAssertEqual(viewModel.previousGuessCount, 0)
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "2")
    }

    func testCreateResetCodeViewModel() {
        let resetCodeViewModel = viewModel.resetCodeViewModel
        XCTAssertEqual(resetCodeViewModel.previousCode, lock.code)
    }

    func testUpdateCode() {
        viewModel.updateCode(newCode: "4567")

        XCTAssertEqual(viewModel.previousGuessCount, 0)
        XCTAssertEqual(viewModel.codeLength, "4")
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "")
    }

    func testManyIncorrectGuesses() {
        let guesses = ["152", "164", "456", "243", "124", "234", "264", "564"]
        guesses.flatMap { return $0.components(separatedBy: "") }.forEach {
            viewModel.handleDigitAdded(digit: $0)
        }

        XCTAssertEqual(viewModel.previousGuessCount, guesses.count)
    }

    func testManyGuessesWithOneCorrect() {
        let guesses = ["152", "164", "456", "123", "124", "234", "264", "564"]
        guesses.flatMap { return $0.components(separatedBy: "") }.forEach {
            viewModel.handleDigitAdded(digit: $0)
        }

        XCTAssertEqual(viewModel.previousGuessCount, 4)
    }

    func testResetWhileGuessing() {
        let firstGuesses = ["152", "164", "456", "243", "124", "234", "264", "564"]
        firstGuesses.flatMap { return $0.components(separatedBy: "") }.forEach {
            viewModel.handleDigitAdded(digit: $0)
        }

        XCTAssertEqual(viewModel.previousGuessCount, firstGuesses.count)

        viewModel.updateCode(newCode: "111")
        XCTAssertEqual(viewModel.previousGuessCount, 0)

        let secondGuesses = ["152", "164", "456"]
        secondGuesses.flatMap { return $0.components(separatedBy: "") }.forEach {
            viewModel.handleDigitAdded(digit: $0)
        }
        
        XCTAssertEqual(viewModel.previousGuessCount, secondGuesses.count)
    }

    func testClear() {
        let guesses = ["152", "164", "456", "243", "124", "234", "264", "564"]
        guesses.flatMap { return $0.components(separatedBy: "") }.forEach {
            viewModel.handleDigitAdded(digit: $0)
        }

        XCTAssertEqual(viewModel.previousGuessCount, guesses.count)

        viewModel.handlePreviousGuessesCleared()

        XCTAssertEqual(viewModel.previousGuessCount, 0)
        XCTAssertEqual(viewModel.lockStatusText, "🔒")
        XCTAssertEqual(viewModel.currentGuess, "")
    }
}

//
//  PickLockViewModelTests.swift
//  PickPocketTests
//
//  Created by Maya Saxena on 6/6/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

@testable import PickPocket
import XCTest

final class PickLockViewModelTests: XCTestCase {
    let lock = Lock(code: "123")
    var viewModel: PickLockViewModel!

    var didReceivePreviousGuessesUpdate = false
    var receivedReadoutColor: UIColor?
    var receivedLockStatusText: String?
    var receivedCodeLengthText: String?
    var receivedCurrentGuessText: String?
    var receivedIsKeypadEnabled: Bool?

    override func setUp() {
        super.setUp()
        viewModel = PickLockViewModel(lock: lock)
        viewModel.delegate = self
    }

    override func tearDown() {
        viewModel = nil

        didReceivePreviousGuessesUpdate = false
        receivedReadoutColor = nil
        receivedLockStatusText = nil
        receivedCodeLengthText = nil
        receivedCurrentGuessText = nil
        receivedIsKeypadEnabled = nil

        super.tearDown()
    }

    func testHandleViewDidLoad() {
        viewModel.handleViewDidLoad()

        XCTAssertEqual(receivedCodeLengthText, "3")
        XCTAssertEqual(receivedCurrentGuessText, "")
    }

    func testCorrectGuess() {
        viewModel.handleDigitAdded("1")
        verifyNoLockStatusUpdatesReceived()
        XCTAssertEqual(receivedCurrentGuessText, "1")

        viewModel.handleDigitAdded("2")
        verifyNoLockStatusUpdatesReceived()
        XCTAssertEqual(receivedCurrentGuessText, "12")

        viewModel.handleDigitAdded("3")

        verifyUpdatesReceived(
            expectedPreviousGuessUpdate: true,
            lockStatusText: "🔓",
            readoutColor: .unlockedReadoutColor,
            isKeypadEnabled: false,
            currentGuessText: ""
        )

        XCTAssertEqual(viewModel.previousGuessCount, 1)
        verify(expectedHint: "⚫⚫⚫", expectedGuess: "123", atIndex: 0)
    }

    func testIncorrectGuess() {
        viewModel.handleDigitAdded("1")
        verifyNoLockStatusUpdatesReceived()

        viewModel.handleDigitAdded("3")
        verifyNoLockStatusUpdatesReceived()

        viewModel.handleDigitAdded("4")

        verifyUpdatesReceived(
            expectedPreviousGuessUpdate: true,
            lockStatusText: "🔒",
            readoutColor: .lockedReadoutColor,
            isKeypadEnabled: true,
            currentGuessText: ""
        )

        XCTAssertEqual(viewModel.previousGuessCount, 1)
        verify(expectedHint: "⚫⚪", expectedGuess: "134", atIndex: 0)
    }

    func testSequentialGuesses() {
        testIncorrectGuess()

        let initialPreviousGuessCount = viewModel.previousGuessCount
        let lockStatusText = receivedLockStatusText

        viewModel.handleDigitAdded("1")

        // Verify that new guess has not been added to list
        XCTAssertEqual(viewModel.previousGuessCount, initialPreviousGuessCount)
        XCTAssertEqual(lockStatusText, receivedLockStatusText)

        viewModel.handleDigitAdded("2")
        viewModel.handleDigitAdded("3")

        verifyUpdatesReceived(
            expectedPreviousGuessUpdate: true,
            lockStatusText: "🔓",
            readoutColor: .unlockedReadoutColor,
            isKeypadEnabled: false,
            currentGuessText: ""
        )

        XCTAssertEqual(viewModel.previousGuessCount, 2)
        verify(expectedHint: "⚫⚫⚫", expectedGuess: "123", atIndex: 0)
    }

    func testGuessAfterUnlock() {
        viewModel.handleDigitAdded("1")
        viewModel.handleDigitAdded("2")
        viewModel.handleDigitAdded("3")

        verifyUpdatesReceived(
            expectedPreviousGuessUpdate: true,
            lockStatusText: "🔓",
            readoutColor: .unlockedReadoutColor,
            isKeypadEnabled: false,
            currentGuessText: ""
        )

        XCTAssertEqual(viewModel.previousGuessCount, 1)
        verify(expectedHint: "⚫⚫⚫", expectedGuess: "123", atIndex: 0)

        didReceivePreviousGuessesUpdate = false
        receivedLockStatusText = nil
        receivedIsKeypadEnabled = nil
        receivedCurrentGuessText = nil

        viewModel.handleDigitAdded("2")

        // Should not update without reset
        verifyNoLockStatusUpdatesReceived()
        XCTAssertNil(receivedCurrentGuessText)

        viewModel.handleReset()

        verifyUpdatesReceived(
            expectedPreviousGuessUpdate: true,
            lockStatusText: "🔒",
            readoutColor: .lockedReadoutColor,
            isKeypadEnabled: true,
            currentGuessText: ""
        )

        XCTAssertEqual(viewModel.previousGuessCount, 0)

        viewModel.handleDigitAdded("2")

        // Should update after reset
        XCTAssertEqual(receivedCurrentGuessText, "2")
    }

    func testManyGuesses() {
        let hintsAndGuesses = ["152", "164", "456", "243", "124", "234", "264", "564"].map {
            return (lock.submit(guess: $0).hintText, $0)
        }

        hintsAndGuesses.enumerated().forEach { (index, element) in
            let (expectedHint, expectedGuess) = element
            expectedGuess.components(separatedBy: "").forEach { viewModel.handleDigitAdded($0) }

            XCTAssertEqual(viewModel.previousGuessCount, index + 1)

            let (hint, guess) = viewModel.hintAndGuess(atIndex: 0)
            XCTAssertEqual(hint, expectedHint)
            XCTAssertEqual(guess, expectedGuess)
        }
    }

    func testManyGuessesWithOneCorrect() {
        let guesses = ["152", "164", "456", "123", "124", "234", "264", "564"]
        guesses.flatMap { return $0.components(separatedBy: "") }.forEach {
            viewModel.handleDigitAdded($0)
        }

        XCTAssertEqual(viewModel.previousGuessCount, 4)
    }

    private func verifyNoLockStatusUpdatesReceived(file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(didReceivePreviousGuessesUpdate, file: file, line: line)
        XCTAssertNil(receivedLockStatusText, file: file, line: line)
        XCTAssertNil(receivedIsKeypadEnabled, file: file, line: line)
    }

    private func verifyUpdatesReceived(expectedPreviousGuessUpdate: Bool,
                                       lockStatusText: String,
                                       readoutColor: UIColor,
                                       isKeypadEnabled: Bool,
                                       currentGuessText: String,
                                       file: StaticString = #file,
                                       line: UInt = #line) {

        XCTAssertEqual(didReceivePreviousGuessesUpdate, expectedPreviousGuessUpdate, file: file, line: line)
        XCTAssertEqual(receivedLockStatusText, lockStatusText, file: file, line: line)
        XCTAssertEqual(receivedReadoutColor, readoutColor, file: file, line: line)
        XCTAssertEqual(receivedIsKeypadEnabled, isKeypadEnabled, file: file, line: line)
        XCTAssertEqual(receivedCurrentGuessText, currentGuessText, file: file, line: line)
    }

    private func verify(expectedHint: String,
                        expectedGuess: String,
                        atIndex index: Int,
                        file: StaticString = #file,
                        line: UInt = #line) {
        let (hint, guess) = viewModel.hintAndGuess(atIndex: index)
        XCTAssertEqual(hint, expectedHint, file: file, line: line)
        XCTAssertEqual(guess, expectedGuess, file: file, line: line)
    }
}

extension PickLockViewModelTests: PickLockViewModelDelegate {
    func pickLockViewModelDidUpdatePreviousGuesses() {
        didReceivePreviousGuessesUpdate = true
    }

    func pickLockViewModelDidUpdate(readoutColor: UIColor) {
        receivedReadoutColor = readoutColor
    }

    func pickLockViewModelDidUpdate(lockStatusText: String) {
        receivedLockStatusText = lockStatusText
    }

    func pickLockViewModelDidUpdate(codeLengthText: String) {
        receivedCodeLengthText = codeLengthText
    }

    func pickLockViewModelDidUpdate(currentGuessText: String) {
        receivedCurrentGuessText = currentGuessText
    }

    func pickLockViewModelDidUpdate(isKeypadEnabled: Bool) {
        receivedIsKeypadEnabled = isKeypadEnabled
    }
}

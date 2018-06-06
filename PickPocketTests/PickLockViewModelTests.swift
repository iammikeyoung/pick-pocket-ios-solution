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

    var receivedPreviousGuessHintText: String?
    var receivedPreviousGuessText: String?
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

        receivedPreviousGuessText = nil
        receivedPreviousGuessHintText = nil
        receivedReadoutColor = nil
        receivedLockStatusText = nil
        receivedCodeLengthText = nil
        receivedCurrentGuessText = nil
        receivedIsKeypadEnabled = nil

        super.tearDown()
    }

    private func verifyNoLockStatusUpdatesReceived(file: StaticString = #file, line: UInt = #line) {
        XCTAssertNil(receivedPreviousGuessHintText, file: file, line: line)
        XCTAssertNil(receivedPreviousGuessText, file: file, line: line)
        XCTAssertNil(receivedLockStatusText, file: file, line: line)
        XCTAssertNil(receivedIsKeypadEnabled, file: file, line: line)
    }

    func testHandleViewDidLoad() {
        viewModel.handleViewDidLoad()

        XCTAssertEqual(receivedCodeLengthText, "3")
        XCTAssertEqual(receivedPreviousGuessHintText, "")
        XCTAssertEqual(receivedPreviousGuessText, "")
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
        XCTAssertEqual(receivedPreviousGuessHintText, "⚫⚫⚫")
        XCTAssertEqual(receivedPreviousGuessText, "123")
        XCTAssertEqual(receivedReadoutColor, UIColor.unlockedReadoutColor)
        XCTAssertEqual(receivedLockStatusText, "🔓")
        XCTAssertEqual(receivedCurrentGuessText, "")
        XCTAssertEqual(receivedIsKeypadEnabled, false)
    }

    func testIncorrectGuess() {
        viewModel.handleDigitAdded("1")
        verifyNoLockStatusUpdatesReceived()

        viewModel.handleDigitAdded("3")
        verifyNoLockStatusUpdatesReceived()

        viewModel.handleDigitAdded("4")
        XCTAssertEqual(receivedPreviousGuessHintText, "⚫⚪")
        XCTAssertEqual(receivedPreviousGuessText, "134")
        XCTAssertEqual(receivedReadoutColor, UIColor.lockedReadoutColor)
        XCTAssertEqual(receivedLockStatusText, "🔒")
        XCTAssertEqual(receivedCurrentGuessText, "")
        XCTAssertEqual(receivedIsKeypadEnabled, true)
    }

    func testSequentialGuesses() {
        testIncorrectGuess()

        let previousGuessHintText = receivedPreviousGuessHintText
        let previousGuessText = receivedPreviousGuessText
        let lockStatusText = receivedLockStatusText

        viewModel.handleDigitAdded("1")

        // Verify that previous guess indicators have not changed
        XCTAssertEqual(previousGuessHintText, receivedPreviousGuessHintText)
        XCTAssertEqual(previousGuessText, receivedPreviousGuessText)
        XCTAssertEqual(lockStatusText, receivedLockStatusText)

        viewModel.handleDigitAdded("2")
        viewModel.handleDigitAdded("3")

        XCTAssertEqual(receivedPreviousGuessHintText, "⚫⚫⚫")
        XCTAssertEqual(receivedPreviousGuessText, "123")
        XCTAssertEqual(receivedLockStatusText, "🔓")
        XCTAssertEqual(receivedCurrentGuessText, "")
    }

    func testCannotGuessAfterUnlock() {
        viewModel.handleDigitAdded("1")
        viewModel.handleDigitAdded("2")
        viewModel.handleDigitAdded("3")

        XCTAssertEqual(receivedPreviousGuessHintText, "⚫⚫⚫")
        XCTAssertEqual(receivedPreviousGuessText, "123")
        XCTAssertEqual(receivedLockStatusText, "🔓")
        XCTAssertEqual(receivedCurrentGuessText, "")

        receivedPreviousGuessHintText = nil
        receivedPreviousGuessText = nil
        receivedLockStatusText = nil
        receivedIsKeypadEnabled = nil
        receivedCurrentGuessText = nil

        viewModel.handleDigitAdded("2")

        verifyNoLockStatusUpdatesReceived()
        XCTAssertNil(receivedCurrentGuessText)
    }
}

extension PickLockViewModelTests: PickLockViewModelDelegate {
    func pickLockViewModelDidUpdate(previousGuessHintText: String, previousGuessText: String) {
        receivedPreviousGuessHintText = previousGuessHintText
        receivedPreviousGuessText = previousGuessText
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

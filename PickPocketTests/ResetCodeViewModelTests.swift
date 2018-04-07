//
//  ResetCodeViewModelTests.swift
//  PickPocketTests
//
//  Created by Maya Saxena on 4/7/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import XCTest
@testable import PickPocket

class ResetCodeViewModelTests: XCTestCase {
    
    var viewModel: ResetCodeViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ResetCodeViewModel(code: "123")
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testInitialValues() {
        XCTAssertEqual(viewModel.previousCode, "123")
        XCTAssertEqual(viewModel.currentCode, "")
        XCTAssertFalse(viewModel.isBackButtonEnabled)
    }

    func testSetCode() {
        viewModel.handleDigitAdded(digit: "4")
        XCTAssertEqual(viewModel.previousCode, "123")
        XCTAssertEqual(viewModel.currentCode, "4")
        XCTAssertFalse(viewModel.isBackButtonEnabled)

        viewModel.handleDigitAdded(digit: "5")
        XCTAssertEqual(viewModel.previousCode, "123")
        XCTAssertEqual(viewModel.currentCode, "45")
        XCTAssertFalse(viewModel.isBackButtonEnabled)

        viewModel.handleDigitAdded(digit: "6")
        XCTAssertEqual(viewModel.previousCode, "123")
        XCTAssertEqual(viewModel.currentCode, "456")
        XCTAssertTrue(viewModel.isBackButtonEnabled)

        viewModel.handleDigitAdded(digit: "7")
        XCTAssertEqual(viewModel.previousCode, "123")
        XCTAssertEqual(viewModel.currentCode, "456")
        XCTAssertTrue(viewModel.isBackButtonEnabled)
    }

    func testRemoveDigits() {
        viewModel.handleDigitAdded(digit: "4")
        viewModel.handleDigitAdded(digit: "5")
        viewModel.handleDigitAdded(digit: "6")
        XCTAssertEqual(viewModel.previousCode, "123")
        XCTAssertEqual(viewModel.currentCode, "456")
        XCTAssertTrue(viewModel.isBackButtonEnabled)


        viewModel.handleLastDigitRemoved()
        XCTAssertEqual(viewModel.previousCode, "123")
        XCTAssertEqual(viewModel.currentCode, "45")
        XCTAssertFalse(viewModel.isBackButtonEnabled)

        viewModel.handleLastDigitRemoved()
        XCTAssertEqual(viewModel.previousCode, "123")
        XCTAssertEqual(viewModel.currentCode, "4")
        XCTAssertFalse(viewModel.isBackButtonEnabled)

        viewModel.handleLastDigitRemoved()
        XCTAssertEqual(viewModel.previousCode, "123")
        XCTAssertEqual(viewModel.currentCode, "")
        XCTAssertFalse(viewModel.isBackButtonEnabled)

        viewModel.handleLastDigitRemoved()
        XCTAssertEqual(viewModel.previousCode, "123")
        XCTAssertEqual(viewModel.currentCode, "")
        XCTAssertFalse(viewModel.isBackButtonEnabled)
    }
}

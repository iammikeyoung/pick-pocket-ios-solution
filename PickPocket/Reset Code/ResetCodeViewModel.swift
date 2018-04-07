//
//  ResetCodeViewModel.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/7/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation

struct ResetCodeViewModel {
    private struct Constants {
        static let codeLength = 3
    }

    let previousCode: String

    private(set) var currentCode = ""

    var isBackButtonEnabled: Bool {
        return currentCode.count == Constants.codeLength
    }

    init(code: String) {
        previousCode = code
    }

    mutating func handleDigitAdded(digit: String) {
        if currentCode.count < Constants.codeLength {
            currentCode += digit
        }
    }

    mutating func handleLastDigitRemoved() {
        currentCode = String(currentCode.dropLast())
    }
}

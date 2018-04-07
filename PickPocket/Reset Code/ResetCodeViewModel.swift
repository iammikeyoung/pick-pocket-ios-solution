//
//  ResetCodeViewModel.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/7/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation

struct ResetCodeViewModel {
    let previousCode: String

    private(set) var currentCode = ""

    init(code: String) {
        previousCode = code
    }

    mutating func handleDigitAdded(digit: String) {
        currentCode += digit
    }

    mutating func handleLastDigitRemoved() {
        currentCode = String(currentCode.dropLast())
    }
}

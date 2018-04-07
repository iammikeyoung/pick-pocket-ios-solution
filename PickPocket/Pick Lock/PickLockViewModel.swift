//
//  PickLockViewModel.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/24/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation

struct PickLockViewModel {

    private typealias PreviousGuess = (guess: String, result: GuessResult)

    private var lock: Lock
    private var previousGuess: PreviousGuess?

    private(set) var currentGuess = ""

    private var isUnlocked: Bool {
        return previousGuess?.result.isCorrect(codeLength: lock.codeLength) ?? false
    }

    var previousGuessHintText: String {
        return previousGuess?.result.hintText ?? ""
    }

    var previousGuessText: String {
        return previousGuess?.guess ?? ""
    }

    var codeLength: String {
        return String(lock.codeLength)
    }

    var lockStatusText: String {
        return isUnlocked ? "🔓" : "🔒"
    }

    var resetCodeViewModel: ResetCodeViewModel {
        return ResetCodeViewModel(code: lock.code)
    }

    init(lock: Lock = Lock(code: "123")) {
        self.lock = lock
    }

    mutating func handleDigitAdded(digit: String) {
        if isUnlocked {
            previousGuess = nil
            currentGuess = ""
        }

        currentGuess += digit

        if currentGuess.count >= lock.codeLength {
            let result = lock.submit(guess: currentGuess)
            previousGuess = (guess: currentGuess, result: result)
            currentGuess = ""
        }
    }

    mutating func updateCode(newCode: String) {
        lock = Lock(code: newCode)
    }
}

private extension GuessResult {
    var hintText: String {
        return String(repeating: "⚫", count: correct) + String(repeating: "⚪", count: misplaced)
    }

    func isCorrect(codeLength: Int) -> Bool {
        return correct == codeLength && misplaced == 0
    }
}

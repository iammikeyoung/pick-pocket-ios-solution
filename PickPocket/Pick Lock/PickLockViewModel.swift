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
    private var previousGuesses = [PreviousGuess]()

    private(set) var currentGuess = ""

    private var isUnlocked: Bool {
        return previousGuesses.first?.result.isCorrect(codeLength: lock.codeLength) ?? false
    }

    var previousGuessCount: Int {
        return previousGuesses.count
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
            reset()
        }

        currentGuess += digit

        if currentGuess.count >= lock.codeLength {
            let result = lock.submit(guess: currentGuess)
            previousGuesses.insert(PreviousGuess(guess: currentGuess, result: result), at: 0)
            currentGuess = ""
        }
    }

    mutating func updateCode(newCode: String) {
        lock = Lock(code: newCode)
        reset()
    }

    mutating func handlePreviousGuessesCleared() {
        reset()
    }

    func hintAndGuess(atIndex index: Int) -> (hint: String, guess: String) {
        let guess = previousGuesses[index]
        return (hint: guess.result.hintText, guess: guess.guess)
    }

    private mutating func reset() {
        previousGuesses = []
        currentGuess = ""
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

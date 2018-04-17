//
//  PickLockViewModel.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/24/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit

class PickLockViewModel {

    let title: String

    private typealias PreviousGuess = (guess: String, result: GuessResult)

    private let lock: Lock
    private var previousGuesses = [PreviousGuess]()

    private(set) var currentGuess = ""

    private var isUnlocked: Bool {
        return previousGuesses.first?.result.isCorrect(codeLength: lock.codeLength) ?? false
    }

    private var canEnterDigits: Bool {
        return currentGuess.count != lock.codeLength
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

    var readoutBackgroundColor: UIColor {
        return isUnlocked ? UIColor.lightGray : UIColor.init(white: 0.9, alpha: 1)
    }

    convenience init(user: User) {
        self.init(title: "\(user.userID)'s Lock", lock: user.lock)
    }

    init(title: String, lock: Lock) {
        self.title = title
        self.lock = lock
    }

    func handleDigitAdded(digit: String, guessSubmitCompletion: @escaping () -> Void) {
        guard !isUnlocked && canEnterDigits else { return }

        currentGuess += digit

        if currentGuess.count >= lock.codeLength {
            lock.submit(guess: currentGuess) { result in
                if case .success(let guessResult) = result {
                    self.previousGuesses.insert(PreviousGuess(guess: self.currentGuess, result: guessResult), at: 0)
                    self.currentGuess = ""
                }
                guessSubmitCompletion()
            }
        }
    }

    func handlePreviousGuessesCleared() {
        reset()
    }

    func hintAndGuess(atIndex index: Int) -> (hint: String, guess: String) {
        let guess = previousGuesses[index]
        return (hint: guess.result.hintText, guess: guess.guess)
    }

    private func reset() {
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

private extension User {
    var lock: Lock {
        if let localUser = self as? LocalUser {
            return LocalLock(code: localUser.code)
        } else {
            return RemoteLock(userID: userID, codeLength: codeLength)
        }
    }
}

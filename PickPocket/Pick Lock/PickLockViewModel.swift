//
//  PickLockViewModel.swift
//  PickPocket
//
//  Created by Maya Saxena on 6/6/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit
import Intrepid

protocol PickLockViewModelDelegate: class {
    func pickLockViewModelDidUpdatePreviousGuesses()
    func pickLockViewModelDidUpdate(readoutColor: UIColor)
    func pickLockViewModelDidUpdate(lockStatusText: String)
    func pickLockViewModelDidUpdate(codeLengthText: String)
    func pickLockViewModelDidUpdate(currentGuessText: String)
    func pickLockViewModelDidUpdate(isKeypadEnabled: Bool)
}

class PickLockViewModel {
    private typealias PreviousGuess = (code: String, result: GuessResult)

    private let lock: Lock

    private var isUnlocked: Bool = false {
        didSet {
            delegate?.pickLockViewModelDidUpdate(readoutColor: isUnlocked ? .unlockedReadoutColor: .lockedReadoutColor)
            delegate?.pickLockViewModelDidUpdate(lockStatusText: isUnlocked ? "🔓" : "🔒")
            delegate?.pickLockViewModelDidUpdate(isKeypadEnabled: !isUnlocked)
        }
    }

    private var currentGuess = "" {
        didSet {
            delegate?.pickLockViewModelDidUpdate(currentGuessText: currentGuess)
        }
    }

    private var previousGuesses = [PreviousGuess]() {
        didSet {
            delegate?.pickLockViewModelDidUpdatePreviousGuesses()
        }
    }

    var previousGuessCount: Int {
        return previousGuesses.count
    }

    weak var delegate: PickLockViewModelDelegate?

    init(lock: Lock = RemoteLock()) {
        self.lock = lock
    }

    func handleViewDidLoad() {
        delegate?.pickLockViewModelDidUpdate(codeLengthText: String(lock.codeLength))
        currentGuess = ""
    }

    func handleDigitAdded(_ digit: String) {
        guard !isUnlocked else { return }

        currentGuess += digit
        delegate?.pickLockViewModelDidUpdate(isKeypadEnabled: currentGuess.count < lock.codeLength)

        submitGuessIfNecessary()
    }

    private func submitGuessIfNecessary() {
        guard currentGuess.count == lock.codeLength else { return }

        lock.submit(guess: currentGuess) { [weak self] result in
            guard let guessResult = result.value else { return }
            self?.update(with: guessResult)
        }
    }

    private func update(with guessResult: GuessResult) {
        isUnlocked = guessResult.correct == lock.codeLength && guessResult.misplaced == 0
        previousGuesses.insert(PreviousGuess(code: currentGuess, result: guessResult), at: 0)
        currentGuess = ""
    }

    func hintAndGuess(atIndex index: Int) -> (hint: String, guess: String) {
        let guess = previousGuesses[index]
        return (hint: guess.result.hintText, guess: guess.code)
    }

    func handleReset() {
        currentGuess = ""
        previousGuesses = []
        isUnlocked = false
    }
}

private extension GuessResult {
    var hintText: String {
        return String(repeating: "⚫", count: correct) + String(repeating: "⚪", count: misplaced)
    }
}

extension UIColor {
    static let lockedReadoutColor = UIColor(white: 0.93, alpha: 1)
    static let unlockedReadoutColor = UIColor(white: 0.71, alpha: 1)
}

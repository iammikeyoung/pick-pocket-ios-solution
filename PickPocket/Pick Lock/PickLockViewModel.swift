//
//  PickLockViewModel.swift
//  PickPocket
//
//  Created by Maya Saxena on 6/6/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit

protocol PickLockViewModelDelegate: class {
    func pickLockViewModelDidUpdate(previousGuessHintText: String, previousGuessText: String)
    func pickLockViewModelDidUpdate(readoutColor: UIColor)
    func pickLockViewModelDidUpdate(lockStatusText: String)
    func pickLockViewModelDidUpdate(codeLengthText: String)
    func pickLockViewModelDidUpdate(currentGuessText: String)
    func pickLockViewModelDidUpdate(isKeypadEnabled: Bool)
}

struct PickLockViewModel {
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

    private var previousGuess: PreviousGuess? {
        didSet {
            delegate?.pickLockViewModelDidUpdate(
                previousGuessHintText: previousGuess?.result.hintText ?? "",
                previousGuessText: previousGuess?.code ?? ""
            )
        }
    }

    weak var delegate: PickLockViewModelDelegate?

    init(lock: Lock = Lock(code: "123")) {
        self.lock = lock
    }

    mutating func handleViewDidLoad() {
        delegate?.pickLockViewModelDidUpdate(codeLengthText: String(lock.codeLength))
        previousGuess = nil
        currentGuess = ""
    }

    mutating func handleDigitAdded(_ digit: String) {
        guard !isUnlocked else { return }

        currentGuess += digit
        submitGuessIfNecessary()
    }

    private mutating func submitGuessIfNecessary() {
        guard currentGuess.count == lock.codeLength else { return }

        let result = lock.submit(guess: currentGuess)

        isUnlocked = result.correct == lock.codeLength && result.misplaced == 0
        previousGuess = (code: currentGuess, result: result)
        currentGuess = ""
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

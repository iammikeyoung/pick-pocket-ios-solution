//
//  Lock.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/22/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation

struct Lock {
    private let code: String

    init(code: String) {
        self.code = code
    }

    func submit(guess: String) -> GuessResult {
        var correct = 0
        var misplaced = 0
        var codeUnmatched = [Character: Int]()
        var guessUnmatched = [Character: Int]()

        zip(code, guess).forEach { (codeCharacter, guessCharacter) in
            if codeCharacter == guessCharacter {
                correct += 1
            } else {
                if let guessUnmatchedCount = guessUnmatched[codeCharacter], guessUnmatchedCount > 0 {
                    guessUnmatched[codeCharacter] = guessUnmatchedCount - 1
                    misplaced += 1
                } else {
                    let codeUnmatchedCount = codeUnmatched[codeCharacter] ?? 0
                    codeUnmatched[codeCharacter] = codeUnmatchedCount + 1
                }

                if let codeUnmatchedCount = codeUnmatched[guessCharacter], codeUnmatchedCount > 0 {
                    codeUnmatched[guessCharacter] = codeUnmatchedCount - 1
                    misplaced += 1
                } else {
                    let guessUnmatchedCount = guessUnmatched[codeCharacter] ?? 0
                    guessUnmatched[guessCharacter] = guessUnmatchedCount + 1
                }
            }
        }

        return GuessResult(correct: correct, misplaced: misplaced)
    }
}

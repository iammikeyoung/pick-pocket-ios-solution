//
//  Lock.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/22/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation
import Intrepid

protocol Lock {
    var codeLength: Int { get }
    func submit(guess: String, completion: @escaping (Result<GuessResult>) -> Void)
}

enum LocalLockError: Error {
    case guessLengthMismatch
}

struct LocalLock: Lock {
    private let code: String

    var codeLength: Int {
        return code.count
    }

    init(code: String) {
        self.code = code
    }

    func submit(guess: String, completion: @escaping (Result<GuessResult>) -> Void) {
        var correct = 0
        var misplaced = 0
        var codeUnmatched = [Character: Int]()
        var guessUnmatched = [Character: Int]()

        guard codeLength == guess.count else {
            completion(.failure(LocalLockError.guessLengthMismatch))
            return
        }

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

        completion(.success(GuessResult(correct: correct, misplaced: misplaced)))
    }
}

struct RemoteLock: Lock {
    private let requestManager: RequestManagerType
    private let userID: String

    let codeLength: Int

    init(userID: String = "Paul", codeLength: Int = 3, requestManager: RequestManagerType = RequestManager()) {
        self.requestManager = requestManager
        self.userID = userID
        self.codeLength = codeLength
    }

    func submit(guess: String, completion: @escaping (Result<GuessResult>) -> Void) {
        requestManager.post(guess: guess, userID: userID, completion: completion)
    }
}

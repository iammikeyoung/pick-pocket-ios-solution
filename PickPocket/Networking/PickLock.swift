//
//  PickLock.swift
//  PickPocket
//
//  Created by Maya Saxena on 9/14/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation

struct PickLockBody: Encodable {
    let token: String
    let guess: String

    init(token: String, guess: String) {
        self.token = token
        self.guess = "[\(guess.map { String($0) }.joined(separator: ","))]"
    }
}

struct PickLockResponse: Decodable {
    let result: GuessResult
}

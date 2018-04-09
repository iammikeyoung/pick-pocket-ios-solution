//
//  PickLock.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/29/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation

struct PickLockRequestBody: Encodable {
    let token: String
    let guess: String

    init(token: String, unformattedGuess: String) {
        self.token = token
        self.guess = unformattedGuess.formatted
    }
}

private extension String {
    var formatted: String {
        return "[\(map(String.init).joined(separator: ","))]"
    }
}

enum PickLockResponse: Decodable {
    case guessResult(GuessResult)
    case error(String)

    enum CodingKeys: CodingKey {
        case result
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let guessResult = try container.decode(GuessResult.self, forKey: .result)
            self = .guessResult(guessResult)
        } catch {
            let errorResponse = try container.decode(PickLockErrorResponse.self, forKey: .result)
            self = .error(errorResponse.error)
        }
    }
}

struct PickLockErrorResponse: Decodable {
    let error: String
}


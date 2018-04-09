//
//  PickLock.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/29/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation
import Intrepid

struct PickLockRequestBody: Encodable {
    let token: String
    let guess: String

    init(token: String, guess: String) {
        self.token = token
        self.guess = guess.formatted
    }
}

private extension String {
    var formatted: String {
        return "[\(self.map { String($0) }.joined(separator: ","))]"
    }
}

struct PickLockError: Error {
    let message: String
}

struct PickLockResponse: Decodable {
    let result: Result<GuessResult>

    enum CodingKeys: CodingKey {
        case result
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let guessResult = try container.decode(GuessResult.self, forKey: .result)
            result = .success(guessResult)
        } catch {
            let errorResponse = try container.decode(PickLockErrorResponse.self, forKey: .result)
            result = .failure(PickLockError(message: errorResponse.error))
        }
    }
}

private struct PickLockErrorResponse: Decodable {
    let error: String
}

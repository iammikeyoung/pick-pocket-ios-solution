//
//  Request.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/8/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PATCH
    case PUT
    case DELETE
}

enum Request {
    static let baseURL = "https://5gbad1ceal.execute-api.us-east-1.amazonaws.com/release"

    case pickLock(guess: String, userID: String)

    private var token: String {
        return "1e32c098-93cf-11e7-8bf1-e29045b92989"
    }

    var method: HTTPMethod {
        switch self {
        case .pickLock:
            return .POST
        }
    }

    var contentType: String {
        return "application/json"
    }

    var endpoint: String {
        switch self {
        case .pickLock(_, let userID):
            return "/picklock/\(userID)"
        }
    }

    var body: Encodable? {
        switch self {
        case .pickLock(let guess, _):
            return PickLockRequestBody(token: token, unformattedGuess: guess)
        }
    }

    var urlRequest: URLRequest {
        let url = Foundation.URL(string: "\(Request.baseURL)\(endpoint)")!

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(AnyEncodable(body))
        }

        return request as URLRequest
    }
}

private struct AnyEncodable: Encodable {
    private let encodable: Encodable

    init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

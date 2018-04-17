//
//  User.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/8/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation

protocol User {
    var userID: String { get }
    var codeLength: Int { get }
}

struct LocalUser: User {
    let code: String
    let userID: String

    var codeLength: Int {
        return code.count
    }

    init(userID: String, codeLength: Int = 3) {
        self.userID = userID
        code = LocalUser.randomCode(length: codeLength)
    }

    private static func randomCode(length: Int) -> String {
        let characters = Array("123456")
        let count = UInt32(characters.count)

        let result: [Character] = (0..<length).map { _ in
            let randomIndex = Int(arc4random_uniform(count))
            return characters[randomIndex]
        }

        return String(result)
    }
}

struct RemoteUser: User, Codable {
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case codeLength = "combinationLength"
    }

    let userID: String
    let codeLength: Int
}

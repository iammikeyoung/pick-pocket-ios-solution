//
//  Lock.swift
//  pick-pocket-ios
//
//  Created by Nicholas Servidio on 1/7/17.
//
//

import UIKit

struct Lock {
    let code: String
    func submit(guess: String) -> PickPocketResult {
        return PickPocketResult(correct: 0, misplaced: 0)
    }
}

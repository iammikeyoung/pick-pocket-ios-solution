//
//  Lock.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/22/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation

struct Lock {
    func submit(guess: String) -> GuessResult {
        return GuessResult(correct: 0, misplaced: 0)
    }
}

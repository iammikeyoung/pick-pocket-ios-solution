//
//  GuessResult.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/22/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation

struct GuessResult: Decodable {
    enum CodingKeys: String, CodingKey {
        case correct
        case misplaced = "close"
    }

    let correct: Int
    let misplaced: Int
}

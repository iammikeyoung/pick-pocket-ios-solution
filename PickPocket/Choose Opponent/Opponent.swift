//
//  Opponent.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/8/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation

struct Opponent {
    let userID: String
    let lock: Lock
}

enum OpponentType: Int {
    case local, remote
}


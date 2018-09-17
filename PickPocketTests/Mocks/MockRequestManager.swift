//
//  MockRequestManager.swift
//  PickPocketTests
//
//  Created by Maya Saxena on 9/17/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation
@testable import PickPocket
import Intrepid

class MockRequestManager: RequestManagerType {
    var receivedPostRequest: (guess: String, userID: String)?
    func post(guess: String, userID: String, completion: @escaping ((Result<GuessResult>) -> Void)) {
        receivedPostRequest = (guess: guess, userID: userID)
    }
}

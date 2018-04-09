//
//  ChooseOpponentViewModel.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/8/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation

struct ChooseOpponentViewModel {
    private let opponents: [OpponentType: [Opponent]]


    init() {
        let localOpponents = [
            Opponent(userID: "Mr. Robot", lock: Lock(code: "111"))
        ]

        let remoteOpponents = [
            Opponent(userID: "Addie", lock: Lock(code: "456"))
        ]

        opponents = [
            OpponentType.local: localOpponents,
            OpponentType.remote: remoteOpponents
        ]
    }

    var numberOfSections: Int {
        return OpponentType.ip_allCases.count
    }

    func cellCount(forSection section: Int) -> Int {
        guard let opponentType = OpponentType(rawValue: section) else { return 0 }
        return opponents[opponentType]?.count ?? 0
    }

    func headerTitle(forSection section: Int) -> String? {
        guard let opponentType = OpponentType(rawValue: section) else { return nil }
        return opponentType.title
    }

    func userID(at indexPath: IndexPath) -> String? {
        guard let opponentType = OpponentType(rawValue: indexPath.section) else { return nil }
        return opponents[opponentType]?[indexPath.row].userID ?? nil
    }

    func pickLockViewModel(at indexPath: IndexPath) -> PickLockViewModel? {
        guard
            let opponentType = OpponentType(rawValue: indexPath.section),
            let opponent = opponents[opponentType]?[indexPath.row]
            else { return nil }

        return PickLockViewModel(opponent: opponent)
    }
}

extension OpponentType {
    var title: String {
        switch self {
        case .local:
            return "COMPUTERS"
        case .remote:
            return "HUMANS"
        }
    }
}

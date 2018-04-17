//
//  UserListViewModel.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/8/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import Foundation

private enum UserType: Int {
    static var caseCount = 2
    case local, remote
}

class UserListViewModel {
    private let requestManager = UserListRequestManager()

    private let localUsers: [User]
    private var remoteUsers: [User] = []

    var numberOfSections: Int {
        return UserType.caseCount
    }

    var onUsersUpdated: () -> Void = {}

    init() {
        localUsers = ["Mr. Roboto", "Wall-E", "Alexa"].map { LocalUser(userID: $0) }
        requestManager.getUsers { [weak self] in
            self?.remoteUsers = $0
            self?.onUsersUpdated()
        }
    }

    func cellCount(forSection section: Int) -> Int {
        guard let userType = UserType(rawValue: section) else { return 0 }
        return users(with: userType).count
    }

    func headerTitle(forSection section: Int) -> String? {
        guard let userType = UserType(rawValue: section) else { return nil }
        return userType.title
    }

    func userID(at indexPath: IndexPath) -> String? {
        guard let userType = UserType(rawValue: indexPath.section) else { return nil }
        return users(with: userType)[indexPath.row].userID
    }

    func user(at indexPath: IndexPath) -> User? {
        guard let userType = UserType(rawValue: indexPath.section) else { return nil }
        return users(with: userType)[indexPath.row]
    }

    private func users(with type: UserType) -> [User] {
        switch type {
        case .local:
            return localUsers
        case .remote:
            return remoteUsers
        }
    }
}

private extension UserType {
    var title: String {
        switch self {
        case .local:
            return "COMPUTERS"
        case .remote:
            return "HUMANS"
        }
    }
}

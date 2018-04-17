//
//  UserListViewController.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/8/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit

class UserInitializableViewController: UIViewController {
    required init(user: User) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var usersTableView: UITableView!

    private let viewModel = UserListViewModel()
    private let userInitializableType: UserInitializableViewController.Type

    init<T: UserInitializableViewController>(type: T.Type) {
        self.userInitializableType = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Players"
        viewModel.onUsersUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.usersTableView.reloadData()
            }
        }
        setupTableView()
    }

    private func setupTableView() {
        usersTableView.register(
            UINib(nibName: String(describing: UserListTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: UserListTableViewCell.identifier
        )
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellCount(forSection: section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .lightGray
        label.text = viewModel.headerTitle(forSection: section)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label    
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.identifier, for: indexPath)

        guard let cell = dequeuedCell as? UserListTableViewCell else { return dequeuedCell }

        if let userID = viewModel.userID(at: indexPath) {
            cell.configure(userID: userID)
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = viewModel.user(at: indexPath) else { return }

        let viewController: UserInitializableViewController = userInitializableType.init(user: user)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

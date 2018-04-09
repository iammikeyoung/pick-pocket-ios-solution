//
//  ChooseOpponentViewController.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/8/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit

final class ChooseOpponentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var opponentsTableView: UITableView!

    private let viewModel = ChooseOpponentViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Players"
        setupTableView()
    }

    private func setupTableView() {
        opponentsTableView.ip_registerCell(ChooseOpponentTableViewCell.self, identifier: ChooseOpponentTableViewCell.identifier)
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
        label.textColor = UIColor(ip_hex: "#B4B4B4")
        label.text = viewModel.headerTitle(forSection: section)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChooseOpponentTableViewCell = tableView.ip_dequeueCell(indexPath, identifier: ChooseOpponentTableViewCell.identifier)

        if let userID = viewModel.userID(at: indexPath) {
            cell.configure(userID: userID)
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pickLockViewModel = viewModel.pickLockViewModel(at: indexPath) else { return }

        let pickLockViewController = PickLockViewController(viewModel: pickLockViewModel)
        navigationController?.pushViewController(pickLockViewController, animated: true)
    }
}

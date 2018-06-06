//
//  PickLockViewController.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/22/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit

final class PickLockViewController: UIViewController, PickLockViewModelDelegate, UITableViewDataSource {

    @IBOutlet private weak var previousGuessesTableView: UITableView!
    @IBOutlet private weak var readoutView: UIView!
    @IBOutlet private weak var lockStatusLabel: UILabel!
    @IBOutlet private weak var codeLengthLabel: UILabel!
    @IBOutlet private weak var currentGuessLabel: UILabel!
    @IBOutlet private weak var keypadView: UIStackView!

    private let viewModel = PickLockViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.handleViewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        previousGuessesTableView.register(
            UINib(nibName: String(describing: PickLockTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: PickLockTableViewCell.identifier
        )

        // Make the table view populate from bottom to top
        previousGuessesTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    // MARK: - Actions

    @IBAction func handleKeypadButtonPressed(_ sender: KeypadButton) {
        viewModel.handleDigitAdded(sender.digit)
    }

    @IBAction func handleResetButtonPressed(_ sender: UIButton) {
        viewModel.handleReset()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.previousGuessCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: PickLockTableViewCell.identifier, for: indexPath)

        guard let cell = dequeuedCell as? PickLockTableViewCell else { return dequeuedCell }

        let (hint, guess) = viewModel.hintAndGuess(atIndex: indexPath.row)
        cell.configure(hint: hint, guess: guess)

        return cell
    }

    // MARK: - PickLockViewModelDelegate

    func pickLockViewModelDidUpdatePreviousGuesses() {
        previousGuessesTableView.reloadData()
    }

    func pickLockViewModelDidUpdate(readoutColor: UIColor) {
        readoutView.backgroundColor = readoutColor
    }

    func pickLockViewModelDidUpdate(lockStatusText: String) {
        lockStatusLabel.text = lockStatusText
    }

    func pickLockViewModelDidUpdate(codeLengthText: String) {
        codeLengthLabel.text = codeLengthText
    }

    func pickLockViewModelDidUpdate(currentGuessText: String) {
        currentGuessLabel.text = currentGuessText
    }

    func pickLockViewModelDidUpdate(isKeypadEnabled: Bool) {
        keypadView.isUserInteractionEnabled = isKeypadEnabled
    }
}

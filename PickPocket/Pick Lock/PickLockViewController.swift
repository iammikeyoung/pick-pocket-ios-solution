//
//  PickLockViewController.swift
//  PickPocket
//
//  Created by Maya Saxena on 3/22/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit

final class PickLockViewController: UIViewController, UITableViewDataSource {

    @IBOutlet private weak var previousGuessesTableView: UITableView!
    @IBOutlet private weak var readoutView: UIView!
    @IBOutlet private weak var lockStatusLabel: UILabel!
    @IBOutlet private weak var codeLengthLabel: UILabel!
    @IBOutlet private weak var guessLabel: UILabel!

    private var viewModel: PickLockViewModel

    init() {
        viewModel = PickLockViewModel(title: "Local Lock", lock: LocalLock(code: "456"))
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        codeLengthLabel.text = viewModel.codeLength

        title = viewModel.title

        setupTableView()
        updateUI()
    }

    private func setupTableView() {
        previousGuessesTableView.register(
            UINib(nibName: String(describing: PickLockTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: PickLockTableViewCell.identifier
        )

        // Make the table view populate from bottom to top
        previousGuessesTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    private func updateUI() {
        readoutView.backgroundColor = viewModel.readoutBackgroundColor
        lockStatusLabel.text = viewModel.lockStatusText
        guessLabel.text = viewModel.currentGuess
        previousGuessesTableView.reloadData()
    }

    // MARK: - Actions

    @IBAction func handleResetButtonPressed(_ sender: UIButton) {
        viewModel.handlePreviousGuessesCleared()
        updateUI()
    }

    @IBAction func handleKeypadButtonPressed(_ sender: KeypadButton) {
        viewModel.handleDigitAdded(digit: sender.digit) {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
        updateUI()
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
}

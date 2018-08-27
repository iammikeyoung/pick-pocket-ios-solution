//
//  PickLockTableViewCell.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/7/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit

final class PickLockTableViewCell: UITableViewCell {

    static let identifier = String(describing: PickLockTableViewCell.self)

    @IBOutlet private weak var hintLabel: UILabel!
    @IBOutlet private weak var guessLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Flip the cell content to account for flipped table view (to make list populate from bottom to top)
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    func configure(hint: String, guess: String) {
        hintLabel.text = hint
        guessLabel.text = guess
    }
}

//
//  ChooseOpponentTableViewCell.swift
//  PickPocket
//
//  Created by Maya Saxena on 4/8/18.
//  Copyright © 2018 Intrepid Pursuits. All rights reserved.
//

import UIKit

class ChooseOpponentTableViewCell: UITableViewCell {
    static let identifier = String(describing: ChooseOpponentTableViewCell.self)

    @IBOutlet private weak var userIDLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configure(userID: String) {
        userIDLabel.text = userID
    }
}

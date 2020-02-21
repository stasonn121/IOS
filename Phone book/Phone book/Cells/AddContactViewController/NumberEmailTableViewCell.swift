//
//  NumberEmailTableViewCell.swift
//  Phone book
//
//  Created by user on 14.02.2020.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

protocol NumberEmailTableViewCellDelegate {
    func onClickCell(_ cell: NumberEmailTableViewCell)
}

class NumberEmailTableViewCell: UITableViewCell {

    @IBOutlet weak var informationLabel: UILabel!
    
    var delegate: NumberEmailTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction private func addNewCell(_ sender: Any) {
        delegate?.onClickCell(self)
    }
}

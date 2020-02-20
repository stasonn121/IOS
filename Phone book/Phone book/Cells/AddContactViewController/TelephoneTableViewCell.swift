//
//  TelephoneTableViewCell.swift
//  Phone book
//
//  Created by user on 14.02.2020.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

protocol TelephoneTableViewCellDelegate {
    func onClickCell(_ cell: TelephoneTableViewCell)
}

class TelephoneTableViewCell: UITableViewCell {

    @IBOutlet weak var numberPhoneTextField: UITextField!
    var delegate: TelephoneTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction private func deleteThisCellButton(_ sender: UIButton) {
         delegate?.onClickCell(self)
    }
}

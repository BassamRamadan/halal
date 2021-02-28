//
//  BankAccountCell.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/27/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class BankAccountCell: UITableViewCell {
    @IBOutlet var name : UILabel!
    @IBOutlet var username : UILabel!
    @IBOutlet var accountNumber : UILabel!
    @IBOutlet var iban : UILabel!
    @IBOutlet var logo: UIImageView!
    @IBOutlet var logoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
class AddBankAccountCell: UITableViewCell {
    @IBOutlet var name : UITextField!
    @IBOutlet var username : UITextField!
    @IBOutlet var accountNumber : UITextField!
    @IBOutlet var iban : UITextField!
    @IBOutlet var logo: UIImageView!
    @IBOutlet var logoLabel: UILabel!
    @IBOutlet var Delete: UIButton!
    @IBOutlet var editImage: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

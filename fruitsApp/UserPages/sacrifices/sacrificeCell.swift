//
//  sacrificeCell.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/27/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class sacrificeCell: UITableViewCell {

    @IBOutlet var sacrificeImage : UIImageView!
    @IBOutlet var name : UILabel!
    @IBOutlet var bio : UILabel!
    @IBOutlet var AdminEditAndDelet: UIView!
    @IBOutlet var edit : UIButton!
    @IBOutlet var delet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

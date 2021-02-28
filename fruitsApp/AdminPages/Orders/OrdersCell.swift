//
//  OrdersCell.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 4/1/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class OrdersCell: UITableViewCell {

    @IBOutlet var userName: UILabel!
    @IBOutlet var createAt: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var statusColor: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

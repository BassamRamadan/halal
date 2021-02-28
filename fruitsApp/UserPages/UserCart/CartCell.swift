//
//  CartCell.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/30/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
class CartCell: UITableViewCell {

    @IBOutlet var delet: UIButton!
    @IBOutlet var plus: UIButton!
    @IBOutlet var minus: UIButton!
    
    @IBOutlet var totalPrice: UILabel!
    @IBOutlet var quantity: UILabel!
    @IBOutlet var minQuantity: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var minPrice: UILabel!
    
    @IBOutlet var cockingPrice: UILabel!
    @IBOutlet var cockingName: UILabel!
  
    
    @IBOutlet var slicesPrice: UILabel!
    @IBOutlet var slicesName: UILabel!
    
    @IBOutlet var sizesPrice: UILabel!
    @IBOutlet var sizesName: UILabel!
    
    @IBOutlet var PackagingPrice: UILabel!
    @IBOutlet var PackagingName: UILabel!
    
    @IBOutlet var SacrificeName: UILabel!
    @IBOutlet var SacrificeImage: UIImageView!
    
    @IBOutlet var head: UIStackView!
    @IBOutlet var headSeperator: UIView!
    
    @IBOutlet var shin: UIStackView!
    @IBOutlet var shinSeperator: UIView!
    
    @IBOutlet var bowels: UIStackView!
    @IBOutlet var bowelsSeperator: UIView!
    
    @IBOutlet var notes: UILabel!
    @IBOutlet var SacNumber: UILabel!
    
    
    @IBOutlet var SizeStack: UIStackView!
    @IBOutlet var CockingStack: UIStackView!
    @IBOutlet var PackageStack: UIStackView!
    @IBOutlet var SliceStack: UIStackView!
    
    @IBOutlet var increment: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

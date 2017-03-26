//
//  OrderDetailTableViewCell.swift
//  iOSSwiftLab7
//
//  Created by Gates on 2017/3/26.
//  Copyright © 2017年 gatesakagi. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var orderDrinkPriceLabel: UILabel!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderDrinkLabel: UILabel!
    @IBOutlet weak var orderSugarLabel: UILabel!
    @IBOutlet weak var orderIceLabel: UILabel!
    @IBOutlet weak var orderDatetimeLabel: UILabel!
    @IBOutlet weak var orderNoteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  MenuItemViewCell.swift
//  Alayam
//
//  Created by Mala on 7/18/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class MenuItemViewCell: UITableViewCell {

    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var imgMenuImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

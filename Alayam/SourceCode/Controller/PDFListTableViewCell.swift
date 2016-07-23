//
//  PDFListTableViewCell.swift
//  Alayam
//
//  Created by Mala on 10/11/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class PDFListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPDFName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setFontSize(){
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            lblPDFName.font = UIFont(name: lblPDFName.font.fontName, size: 20)
        }
    }
    
}

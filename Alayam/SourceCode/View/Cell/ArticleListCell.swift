//
//  ArticleListCell.swift
//  Alayam
//
//  Created by Jeyaraj on 15/11/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class ArticleListCell: UITableViewCell {

    @IBOutlet weak var imgViewArticleimage: UIImageView!
    @IBOutlet weak var lblArticleTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

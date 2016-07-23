//
//  BreakingNewsTableViewCell.swift
//  Alayam
//
//  Created by Mala on 9/6/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class BreakingNewsTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet weak var imgRedViewNews: UIImageView!
    
    @IBOutlet weak var lblHotNewsDetails: UILabel!
    
    @IBOutlet weak var lblHotNewsDate: UILabel!
    
    var isCached = true
    
    //MARK:- Properties

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithData(cellDetails : BreakingNewsContentDTO)
    {
        if isCached
        {
            //            isCached = false
            lblHotNewsDetails.text = cellDetails.NewsTitle
            lblHotNewsDate.text = cellDetails.NEWSTIME
            
           // imgViewNews.setImageWithUrl(NSURL(string: cellDetails.ImageURL_S)!, placeHolderImage: UIImage(named: "tumbnailplaceholder"))
        }
    }

    func configureWithDataRegular(cellDetails : HotNewsDTO)
    {
            //            isCached = false
            lblHotNewsDetails.text = cellDetails.NewsTitle
            lblHotNewsDate.text = cellDetails.NEWSTIME
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
            lblHotNewsDetails.font = UIFont(name: lblHotNewsDetails.font.fontName, size: 18)
            lblHotNewsDate.font = UIFont(name: lblHotNewsDate.font.fontName, size: 18)
        }

    }

}

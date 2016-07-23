//
//  HomeHeaderTableViewCell.swift
//  Alayam
//
//  Created by Jeyaraj on 27/07/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class HomeHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewOriginal: UIImageView!
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var imgViewBlurredImage: UIImageView!
    
    @IBOutlet weak var lblNewsTitle: UILabel!
    
    @IBOutlet weak var lblNewsSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.45)
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithData(data : SliderNewsDTO)
    {
        imgViewOriginal.setImageWithUrl(NSURL(string: data.ImageURL)!, placeHolderImage: UIImage(named: "placeholder"))
        imgViewBlurredImage.setImageWithUrl(NSURL(string: data.ImageURL)!, placeHolderImage: UIImage(named: "placeholder"))
        
        lblNewsTitle.text = data.NewsTitle
        lblNewsSubTitle.text = data.NewsSubTitle
        
    }

    func setfontSize(){
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
            lblNewsTitle.font = UIFont(name: lblNewsTitle.font.fontName, size: 20)
            lblNewsSubTitle.font = UIFont(name: lblNewsSubTitle.font.fontName, size: 20)
        }
    }

}

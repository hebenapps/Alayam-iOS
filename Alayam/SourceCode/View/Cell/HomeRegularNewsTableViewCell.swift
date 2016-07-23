//
//  HomeRegularNewsTableViewCell.swift
//  Alayam
//
//  Created by Jeyaraj on 26/07/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class HomeRegularNewsTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet weak var imgViewNews: UIImageView!
    
    @IBOutlet weak var lblNewsDetails: UILabel!
    
    @IBOutlet weak var lblNewsTime: UILabel!
    
    var isCached = true
   
    
    private var cellDetailsValue : SliderNewsDTO!
    //MARK:- Properties
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Configuration
    
    func configureWithData(cellDetails : SliderNewsDTO)
    {
        
        
        cellDetailsValue = cellDetails
        
            lblNewsDetails.text = cellDetails.NewsTitle
            lblNewsTime.text = cellDetails.NEWSTIME
        
//        let postedDate = cellDetails.NEWSTIME
//        let postedDateArr = postedDate.componentsSeparatedByString(":")
//        
//        let date = NSDate()
//        let calendar = NSCalendar.currentCalendar()
//        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
//        let hour = components.hour
//        let minutes = components.minute
//        let seconds = components.second
//        
//        var hrdiff = hour - postedDateArr[0].toInt()!
//        var mindiff = minutes - postedDateArr[1].toInt()!
//        var secdiff = seconds - postedDateArr[2].toInt()!
//        
//        if(hrdiff > 0)
//        {
//            lblNewsTime.text = String(hrdiff) + "hr ago"
//        }
//        else if(mindiff > 0)
//        {
//            lblNewsTime.text = String(mindiff) + "m ago"
//        }
//        else
//        {
//            lblNewsTime.text = String(secdiff) + "sec ago"
//        }
//        
        
            
//            imgViewNews.setImageWithUrl(NSURL(string: cellDetails.ImageURL_S)!, placeHolderImage: UIImage(named: "tumbnailplaceholder"))
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
//            imgViewNews.frame = CGRectMake(imgViewNews.frame.origin.x, imgViewNews.frame.origin.y, imgViewNews.frame.size.width+140, imgViewNews.frame.size.height)
//            imgViewNews.setTranslatesAutoresizingMaskIntoConstraints(false)
//            self.view.addConstraint(NSLayoutConstraint(
//                item:imgViewNews, attribute:NSLayoutAttribute.Width,
//                relatedBy:NSLayoutRelation.Equal,
//                toItem:nil, attribute:NSLayoutAttribute.NotAnAttribute,
//                multiplier:0, constant:100))
            
            imgViewNews.updateConstraints()
            imgViewNews.layoutIfNeeded()
        }
        
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: cellDetails.ImageURL_S)!)
            request.addValue("image/*", forHTTPHeaderField: "Accept")
            imgViewNews.setImageWithUrlRequest(request, placeHolderImage: UIImage(named: "tumbnailplaceholder"), success: { (request, response, image, fromCache) -> Void in
                self.imgViewNews.image = image
                LocalCacheDataHandler().saveImageToLocal(image, directoryName: "HomeNews", imageName: "\(self.cellDetailsValue.NewsMainID)")
                
            }, failure: { (request, response, error) -> Void in
                
            })
        }
    
    
    
    func setusAlreadySelectedNews()
    {
        lblNewsDetails.textColor = UIColor.lightGrayColor()
        lblNewsTime.textColor = UIColor.lightGrayColor()
    }
    
    
    
    func setusUnSelectedNews()
    {
        lblNewsDetails.textColor = UIColor(red: 0, green: 24/255, blue: 63/255, alpha: 1)
        lblNewsTime.textColor = UIColor(red: 0, green: 24/255, blue: 63/255, alpha: 1)
    }
    
    func setfontSize(){
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
            lblNewsDetails.font = UIFont(name: lblNewsDetails.font.fontName, size: 20)
            lblNewsTime.font = UIFont(name: lblNewsTime.font.fontName, size: 18)
        }
    }
  
   
}






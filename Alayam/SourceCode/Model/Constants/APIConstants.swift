//
//  APIConstants.swift
//  Alayam
//
//  Created by Mala on 7/21/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class APIConstants: NSObject {
    
    enum urlConstant : String
    {
        //HomePage
        case homeTopSlider              = "GetHomeSliderTopNews"
        case homeRegularNews            = "%@&PageNo=%@&RowsPerPage=%@&Category=%@&IssueID=0&Type=%@" //PageNo and RowsPerPage need to add
        
        case News                       = "news"
        
        case photography                = "GetPhotography"
        
        case PDF                        = "GetLatestPDF"
        
        case hotNews                    = "GetHotNews&PageNo=%@&RowsPerPage=%@&Category=&IssueID=0"
        
        case tags                       = "GetTags"
        
        case tagsNews                   = "SearchByTag"
        
        case loginSocial                = "http://mobile.alayam.com/api/SocialLogin"
        
        case loginAlayam                = "http://mobile.alayam.com/api/SecurityUser"
        
        case addComment                 = "http://mobile.alayam.com/api/Comments"
        
        case commentList                = "http://mobile.alayam.com/api/Comments?MobileRequest=GetComments&PageNo=%@&RowsPerPage=%@&NewsMainID=%@&CommentType=%@"
        
        case sendFeedBackLike           = "http://mobile.alayam.com/api/Feedback"
        
        case registerSocial             = "http://mobile.alayam.com/api/SocialUser"
        
        case registerUser               = "http://mobile.alayam.com/api/Users"
    }
    
    let Base_url = "http://mobile.alayam.com/api/Content?MobileRequest="

    let Menu_url = "http://mobile.alayam.com/api/Menu?RequestData=GetMenu"
    
    func getUrl(urlString : urlConstant) -> String{
        return "\(Base_url)\(urlString.rawValue)"
    }
    
    
   
}

//
//  HomeFeedDataHandler.swift
//  Alayam
//
//  Created by Jeyaraj on 25/07/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class HomeFeedDataHandler: NSObject {
   
    
    func getHomeFeedSliderNews(isLoaderNeed : Bool, queryParameter: HomeSliderNewsRequestDTO?, parameter :[String : AnyObject]?, Completion Handler : (HomeSliderNewsResponseDTO!) -> Void!, failureHandler:(NSError?) ->Void)
    {
        WebServiceHandler().getMethod(isLoaderNeed, url: APIConstants().getUrl(.homeTopSlider), header: ["authorization" : ""], body: swiftToJsonParser(queryParameter!) as? [String : AnyObject]) { (responseDict, error) -> Void in
            
            if let responseValue = responseDict
            {
                Handler(HomeSliderNewsResponseDTO().initWithJsonRootDictionary(responseDict))
            }
            else
            {
                failureHandler(error)
            }
        }
        
    }
    
    func getHomeFeednewsWithPagination(isLoaderNeed : Bool, pageNumber : Int, numberOfNews : Int,queryParameter: HomeSliderNewsRequestDTO, parameter :[String : AnyObject]?, Completion Handler : (HomeSliderNewsResponseDTO!) -> Void!, failureHandler:(NSError?) ->Void)
    {
        if !Reachability.isConnectedToNetwork() {
            
            let dto = HomeSliderNewsResponseDTO()
            dto.Data.AlayamCategoryNews = LocalCacheDataHandler().getCachedData(queryParameter.category)
            
            Handler(dto)
            return
            
        }
        
        var categoryType = "GetHomeRegularNews"
        let apiPageNumber = pageNumber
        
        if queryParameter.category != ""
        {
            categoryType = "GetCategoryNews"
//            apiPageNumber = 4
        }
        
        let url : NSString = NSString(format:APIConstants().getUrl(.homeRegularNews),categoryType,"\(apiPageNumber)","\(numberOfNews)",queryParameter.category,queryParameter.type)
        
        WebServiceHandler().getMethod(isLoaderNeed, url: url as String, header: ["authorization" : ""], body: nil) { (responseDict, error) -> Void in
            
            if let responseValue = responseDict
            {
                Handler(HomeSliderNewsResponseDTO().initWithJsonRootDictionary(responseDict))
            }
            else
            {
                failureHandler(error)
            }
        }
        
    }
    
    
    
    func getMenuItems(isLoaderNeed : Bool, queryParameter: HomeSliderNewsRequestDTO?, parameter :[String : AnyObject]?, Completion Handler : (HomeSliderNewsResponseDTO!) -> Void!, failureHandler:(NSError?) ->Void)
    {
        
        let gotDate = NSUserDefaults.standardUserDefaults().objectForKey("updatedDate") as? String
        
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/mm/yyyy"
        
        
        let todayDate = NSDate()
        
        if let notnilDate = gotDate
        {
            
            let date = formatter.dateFromString(notnilDate)
            
            let component = NSCalendar.currentCalendar().component(NSCalendarUnit.NSDayCalendarUnit, fromDate: todayDate)
            
            let component2 = NSCalendar.currentCalendar().component(NSCalendarUnit.NSDayCalendarUnit , fromDate: date!)
            
            if component == component2
            {
                
                let details = HomeSliderNewsResponseDTO()
                details.Data.AlayamMenu = LocalCacheDataHandler().getMenuList(2).mutableCopy() as! NSMutableArray
                details.Data.OnlineMenu = LocalCacheDataHandler().getMenuList(1).mutableCopy() as! NSMutableArray
                details.Data.ArticleMenu = LocalCacheDataHandler().getMenuList(3).mutableCopy() as! NSMutableArray
                Handler(details)
                NSUserDefaults.standardUserDefaults().setValue(formatter.stringFromDate(todayDate), forKey: "updatedDate")
                return
            }
            
        }
        
        WebServiceHandler().getMethod(isLoaderNeed, url: APIConstants().Menu_url, header: ["authorization" : ""], body: nil) { (responseDict, error) -> Void in
            
            if let responseValue = responseDict
            {
                NSUserDefaults.standardUserDefaults().setValue(formatter.stringFromDate(todayDate), forKey: "updatedDate")
                let response = HomeSliderNewsResponseDTO().initWithJsonRootDictionary(responseDict)
                Handler(response)
                
                let array = response.Data.AlayamMenu
                
                for (var k = 0; k < response.Data.OnlineMenu.count; k++)
                {
                    array.addObject(response.Data.OnlineMenu.objectAtIndex(k) as! AlayamMenuDTO)
                }
                
                for (var k = 0; k < response.Data.ArticleMenu.count; k++)
                {
                    array.addObject(response.Data.ArticleMenu.objectAtIndex(k) as! AlayamMenuDTO)
                }
                
                LocalCacheDataHandler().addToMenuList(array)
//                LocalCacheDataHandler().addToMenuList(response.Data.OnlineMenu)
            }
            else
            {
                failureHandler(error)
            }
        }
        
    }

}

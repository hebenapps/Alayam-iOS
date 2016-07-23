//
//  BreakingNewsDataHandler.swift
//  Alayam
//
//  Created by Mala on 9/6/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class BreakingNewsDataHandler: NSObject {
    
    
    func getBreakingNewsList(isLoaderNeed : Bool, queryParameter: BreakingNewsRequestDTO?, parameter :[String : AnyObject]?, Completion Handler : (BreakingNewsResponseDTO!) -> Void!, failureHandler:(NSError?) ->Void)
    {
        WebServiceHandler().getMethod(isLoaderNeed, url: APIConstants().getUrl(.homeTopSlider), header: ["authorization" : ""], body: swiftToJsonParser(queryParameter!) as? [String : AnyObject]) { (responseDict, error) -> Void in
            
            if let responseValue = responseDict
            {
                Handler(BreakingNewsResponseDTO().initWithJsonRootDictionary(responseDict))
            }
            else
            {
                failureHandler(error)
            }
        }
        
    }
    
    
    
    func getBreakingnewsWithPagination(isLoaderNeed : Bool, pageNumber : Int, numberOfNews : Int,queryParameter: BreakingNewsRequestDTO, parameter :[String : AnyObject]?, Completion Handler : (BreakingNewsResponseDTO!) -> Void!, failureHandler:(NSError?) ->Void)
    {
        var categoryType = "GetHotNews"//"GetHotNews"
        let apiPageNumber = pageNumber
        
        if queryParameter.category != ""
        {
            categoryType = "GetCategoryNews"
            //            apiPageNumber = 4
        }
        
        let url : NSString = NSString(format:APIConstants().getUrl(.homeRegularNews),categoryType,"\(apiPageNumber)","\(numberOfNews)",queryParameter.category,"alayam")
        
        WebServiceHandler().getMethod(isLoaderNeed, url: url as String, header: ["authorization" : ""], body: nil) { (responseDict, error) -> Void in
            
            if let responseValue = responseDict
            {
                Handler(BreakingNewsResponseDTO().initWithJsonRootDictionary(responseDict))
            }
            else
            {
                failureHandler(error)
            }
        }
        
    }

    
   
   
}

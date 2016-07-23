//
//  TagsDataHandler.swift
//  Alayam
//
//  Created by Jeyaraj on 07/09/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class TagsDataHandler: NSObject {
   
    func getTagsList(isLoaderNeed : Bool, apiPageNumber : Int, numberOfNews : Int, queryParameter: BreakingNewsRequestDTO?, parameter :[String : AnyObject]?, Completion Handler : (TagsResponseDTO!) -> Void!, failureHandler:(NSError?) ->Void)
    {
        
        let url = NSString(format:APIConstants().getUrl(.tags))
        
        WebServiceHandler().getMethod(isLoaderNeed, url: url as String, header: ["authorization" : ""], body: nil) { (responseDict, error) -> Void in
            
            if let responseValue = responseDict
            {
                Handler(TagsResponseDTO().initWithJsonRootDictionary(responseDict))
            }
            else
            {
                failureHandler(error)
            }
        }
        
    }
    
    
}

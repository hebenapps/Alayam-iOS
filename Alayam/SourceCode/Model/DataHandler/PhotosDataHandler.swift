//
//  PhotosDataHandler.swift
//  Alayam
//
//  Created by Jeyaraj on 09/08/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class PhotosDataHandler: NSObject {
    
    func getPhotographyList(isLoaderNeed : Bool, queryParameter: GetPhotographyRequestDTO?, parameter :[String : AnyObject]?, Completion Handler : (GetPhotographyResponseDTO!) -> Void!, failureHandler:(NSError?) ->Void)
    {
        WebServiceHandler().getMethod(isLoaderNeed, url: APIConstants().getUrl(.photography), header: ["authorization" : ""], body: nil) { (responseDict, error) -> Void in
            
            if let responseValue = responseDict
            {
                Handler(GetPhotographyResponseDTO().initWithJsonRootDictionary(responseDict))
            }
            else
            {
                failureHandler(error)
            }
        }
        
    }
   
}

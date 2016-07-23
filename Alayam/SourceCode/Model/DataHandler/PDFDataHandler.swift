//
//  PDFDataHandler.swift
//  Alayam
//
//  Created by Mala on 10/11/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class PDFDataHandler: NSObject {
    
    func getPDFList(isLoaderNeed : Bool, queryParameter: GetPDFRequestDTO?, parameter : [String : AnyObject]?, Completion Handler : (GetPDFResponseDTO!) -> Void!, failureHandler: (NSError?) -> Void)
    {
        WebServiceHandler().getMethod(isLoaderNeed, url: APIConstants().getUrl(.PDF), header: ["authorization" : ""], body: nil){
            (responseDict, error) -> Void in
            if let responseValue = responseDict
            {
                Handler(GetPDFResponseDTO().initWithJsonRootDictionary(responseDict))
            }
            else
            {
                failureHandler(error)
            }
        }
    }
   
}

//
//  TagsViewControllerModel.swift
//  Alayam
//
//  Created by Jeyaraj on 07/09/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

protocol TagsViewControllerModelDelegate
{
    func refreshTagsList()
}

class TagsViewControllerModel: NSObject {
    
    var tagsList = NSMutableArray()
    
    var delegate : TagsViewControllerModelDelegate?
    
    
    func getTags()
    {
        TagsDataHandler().getTagsList(false, apiPageNumber: 1, numberOfNews: 50, queryParameter: nil, parameter: nil, Completion: { (response) -> Void! in
            
            self.tagsList = response.Data.Tags
            self.delegate?.refreshTagsList()
            
            return Void()
            
        }) { (error) -> Void in
            
        }
    }
    
    
}

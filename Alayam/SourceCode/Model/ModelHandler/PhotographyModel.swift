//
//  PhotographyModel.swift
//  Alayam
//
//  Created by Jeyaraj on 09/08/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

protocol PhotographyModelDelegate
{
    func refreshPhoto()
}

class PhotographyModel: NSObject {
    
    var delegate : PhotographyModelDelegate?
    
    var photosList = NSMutableArray()
    
    func getPhotosList()
    {
        PhotosDataHandler().getPhotographyList(true ,queryParameter: GetPhotographyRequestDTO(), parameter: nil, Completion: { (response) -> Void! in
            
            if response != nil
            {
                self.photosList = response.Data.Photography
                self.delegate?.refreshPhoto()
            }
            
            return Void()
        }) { (error) -> Void in
            
            
        }
    }
   
}

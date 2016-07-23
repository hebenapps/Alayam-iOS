//
//  ReadersEntity.swift
//  Alayam
//
//  Created by Jeyaraj on 10/09/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import Foundation
import CoreData

@objc(ReadersEntity)

class ReadersEntity: NSManagedObject {

    @NSManaged var contentType: String
    @NSManaged var imageURL: String
    @NSManaged var imageURL_S: String
    @NSManaged var newsCategory: String
    @NSManaged var newsDate: String
    @NSManaged var newsDetails: String
    @NSManaged var newsMainID: NSNumber
    @NSManaged var newsSubTitle: String
    @NSManaged var newsSummary: String
    @NSManaged var nEWSTIME: String
    @NSManaged var newsTitle: String
    @NSManaged var nEWSURL: String
    
    
    var categoryNewsDTO : SliderNewsDTO
        {
        get{
            let newObject = SliderNewsDTO()
            
            newObject.ContentType = contentType
            newObject.NEWSTIME = nEWSTIME
            newObject.NewsTitle = newsTitle
            newObject.NewsSubTitle = newsSubTitle
            newObject.NewsSummary = newsSummary
            newObject.NewsDetails = newsDetails
            newObject.NewsDate = newsDate
            newObject.ImageURL_S = imageURL_S
            newObject.ImageURL = imageURL
            newObject.NEWSURL = nEWSURL
            newObject.NewsMainID = newsMainID
            
            return newObject
        }
    }

}

@objc(ReadNews)

class ReadNews: NSManagedObject {
    @NSManaged var id: String
}


//
//  NewsEntity.swift
//  Alayam
//
//  Created by Jeyaraj on 10/09/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import Foundation
import CoreData

@objc(NewsEntity)

class NewsEntity: NSManagedObject {

    @NSManaged var contentType: String
    @NSManaged var newsTitle: String
    @NSManaged var newsSubTitle: String
    @NSManaged var newsSummary: String
    @NSManaged var newsDetails: String
    @NSManaged var newsDate: String
    @NSManaged var imageURL_S: String
    @NSManaged var imageURL: String
    @NSManaged var nEWSURL: String
    @NSManaged var nEWSTIME: String
    @NSManaged var newsMainID: NSNumber
    @NSManaged var newsCategory: String


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
    
//    var managedObjectArray : NSMutableArray
//        {
//        get
//        {
//            var array =
//        }
//    }
    
}

@objc(MenuEntity)

class MenuEntity: NSManagedObject {
    
    @NSManaged var contentSectionID: NSNumber
    @NSManaged var contentTypeID: NSNumber
    @NSManaged var arabicName : String
    @NSManaged var englishName: String
    @NSManaged var mobileIcon : String
    @NSManaged var menuType : NSNumber
    
    var alayamMenuDTO : AlayamMenuDTO
        {
        get
        {
            let alayamDto = AlayamMenuDTO()
            alayamDto.ContentSectionID = contentSectionID
            alayamDto.ContentTypeID = contentTypeID
            alayamDto.ArabicName = arabicName
            alayamDto.EnglishName = englishName
            alayamDto.MobileIcon = mobileIcon
            alayamDto.MenuType = menuType
            return alayamDto
        }
    }
}

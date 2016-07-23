//
//  PhotosData.swift
//  Alayam
//
//  Created by Jeyaraj on 09/08/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class PhotosData: NSObject {
    
}

class GetPhotographyRequestDTO : NSObject
{
    
}

class GetPhotographyResponseDTO : NSObject
{
    var Data = DataDTO()
    
    var Status : NSNumber = 0.0
    var ErrorMessage : AnyObject?
    var ErrorCode : AnyObject?
}

class PhotographyDTO : NSObject
{
    var CATENNAME = ""
    var SUBCATENNAME = ""
    var SUBCATARNAME = ""
    var ROWNUMBER_BYCONTENTSECTIONID : NSNumber = 0.0
    var SRLNOCS : NSNumber = 0.0
    var SRLNONS : NSNumber = 0.0
    var NewsMainID : NSNumber = 0.0
    var MainNewsKey : AnyObject?
    var ContentTypeID : NSNumber = 0.0
    var ContentSectionID : NSNumber = 0.0
    var AdminUserID : NSNumber = 0.0
    var WriterID : NSNumber = 0.0
    var IssueID : NSNumber = 0.0
    var PDFNUmber : NSNumber = 0.0
    var NewsSource = ""
    var NewsTitle = ""
    var NewsSubTitle = ""
    var NewsSummary = ""
    var NewsPhoto = ""
    var NewsPhotoCaption = ""
    var NewsPhotoSettings = ""
    var NewsDetails = ""
    var NewsDate = ""
    var VideoURL = ""
    var Tags = ""
    var MetaKeywords = ""
    var MetaDescription = ""
    var IsHomeNews : NSNumber = 0.0
    var IsSliderNews : NSNumber = 0.0
    var IsUrgentNews : NSNumber = 0.0
    var Facebook : NSNumber = 0.0
    var GooglePlus : NSNumber = 0.0
    var Twitter : NSNumber = 0.0
    var IsAllowPushNotification : NSNumber = 0.0
    var TotalReadings : NSNumber = 0.0
    var TotalComments : NSNumber = 0.0
    var TotalPrintings : NSNumber = 0.0
    var Priority : NSNumber = 0.0
    var ModifiedDate : AnyObject?
    var CreatedDate = ""
    var UpdatedByAdminUserID : NSNumber = 0.0
    var OldColumnID : NSNumber = 0.0
    var SRLNO : NSNumber = 0.0
    var Publish : NSNumber = 0.0
    var NDBType : AnyObject?
    var NEWSDESC160 = ""
    var NEWSDESC240 = ""
    var ImageURL_L = ""
    var ImageURL_M = ""
    var ImageURL_S = ""
    var NEWSURL = ""
    
    
    var ContentType = ""
    var SectionName = ""
    
    var ImageURL : String
        {
        get
        {
            return ImageURL_L
        }
    }
    var ImageURL_EXS : String
        {
        get
        {
            return NewsDate
        }
    }
    var NEWSTIME : String
        {
        get
        {
            return NewsDate
        }
    }
    
    
    var categoryNewsDTO : SliderNewsDTO
        {
        get{
            let newObject = SliderNewsDTO()
            
            newObject.ContentType = ContentType
            newObject.NEWSTIME = NewsDate
            newObject.NewsTitle = NewsTitle
            newObject.NewsSubTitle = NewsSubTitle
            newObject.NewsSummary = NewsSummary
            newObject.NewsDetails = NewsDetails
            newObject.NewsDate = NewsDate
            newObject.ImageURL_S = ImageURL_S
            newObject.ImageURL = ImageURL
            newObject.NEWSURL = NEWSURL
            newObject.NewsMainID = NewsMainID
            
            return newObject
        }
    }
}
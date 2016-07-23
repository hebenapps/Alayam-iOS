//
//  HomeSliderNewsData.swift
//  Alayam
//
//  Created by Jeyaraj on 25/07/15.
//
//

import UIKit
import CoreData

class HomeSliderNewsData: NSObject {
   var error = ""
}

class HomeSliderNewsRequestDTO : NSObject
{
    var category = ""
    var type = ""
}

class HomeSliderNewsResponseDTO : NSObject {
    
    var Data = DataDTO()
    var Status = ""
    var ErrorMessage : String?
    var ErrorCode : String?
    
}

class DataDTO : NSObject
{
    var SliderNews = NSMutableArray()
    var HomeRegularNews = NSMutableArray()
    var AlayamCategoryNews = NSMutableArray()
    var OnlineCategoryNews = NSMutableArray()
    var HotNews = NSMutableArray()
    var StreamURLS = NSMutableArray()
    
    var SearchNews = NSMutableArray()
    var RegularNews = NSMutableArray()
    var NewsDetails = NSMutableArray()
    var ImageDetails = NSMutableArray()
    
    var Photography = NSMutableArray()
    var PDF = NSMutableArray()
    var Tags = NSMutableArray()
    
    var AlayamMenu = NSMutableArray()
    var OnlineMenu = NSMutableArray()
    var ArticleMenu = NSMutableArray()
    
    var Articles = NSMutableArray()
    
    var Comments = NSMutableArray()
    
    var UserDetails = NSMutableArray()
    
    var SocialUserDetails = NSMutableArray()
}


class SliderNewsDTO : NSObject
{
    var ContentType = ""
    var SectionName = ""
    var IssueID : NSNumber = 0.0
    var NewsTitle = ""
    var NewsSubTitle = ""
    var NewsSummary = ""
    var NewsMainID : NSNumber = 0.0
    
    var NewsPhotoCaption = ""
    var NewsDetails = ""
    
    var NewsDate = ""
    var ImageURL = ""
    var ImageURL_S = ""
    var ImageURL_EXS = ""
    var NEWSURL = ""
    var NEWSTIME = ""
    
    var StreamKey = ""
    var StreamURL = ""
    
    var NewsMainImageID : NSNumber = 0.0
    var IMGURL_XL = ""
    var ImageSettings = ""
    var ImageCaption = ""
    var SRLNO : NSNumber = 0.0
    var Publish : Bool = true
    
    
    var thumbnailDirectory : String
        {
        get
        {
            return "thumbNailImages/\(self.NewsMainID)"
        }
    }
    
    var thumbnailPath : String
        {
        get
        {
            return "thumbNailImages/\(self.NewsMainID)/logo.jpg"
        }
    }
    
    var mainImageDirectory : String
        {
        get
        {
            return "mainImages/\(self.NewsMainID)"
        }
    }
    
    var mainImagePath : String
        {
        get
        {
            return "mainImages/\(self.NewsMainID)/logo.jpg"
        }
    }
}

class HomeRegularNewsDTO : SliderNewsDTO
{
    
}

class AlayamCategoryNewsDTO : SliderNewsDTO
{
    
}

class OnlineCategoryNewsDTO : SliderNewsDTO
{
    
}

class SearchNewsDTO : SliderNewsDTO
{
    
}

class RegularNewsDTO : SliderNewsDTO
{
    
}

class HotNewsDTO : SliderNewsDTO
{
    
}
class StreamURLSDTO : SliderNewsDTO
{
    
}
class NewsDetailsDTO : SliderNewsDTO
{
    
}
class ImageDetailsDTO : SliderNewsDTO
{
    
}





class AlayamMenuDTO : NSObject
{
    var ContentSectionID: NSNumber = 0
    var ContentTypeID: NSNumber = 0
    var ArabicName = ""
    var EnglishName = ""
    var MobileIcon = ""
    var MenuType : NSNumber = 0
}

class OnlineMenuDTO : AlayamMenuDTO
{
    
}

class ArticleMenuDTO : AlayamMenuDTO
{
    
}



class ArticlesDTO : NSObject {
    var ContentType = ""
    var SectionName = ""
    var IssueID : NSNumber = 0
    var ArticleID : NSNumber = 0
    var ArticleSummary = ""
    var ArticleDetails = ""
    var ArticleTitle = ""
    var ArticleSubTitle = ""
    var ArticlePhotoCaption = ""
    var ArticleDate = ""
    var ArticleSource = ""
    var WriterImageURL_S = ""
    var ARTICLEURL = ""
    var NEWSTIME = ""
}



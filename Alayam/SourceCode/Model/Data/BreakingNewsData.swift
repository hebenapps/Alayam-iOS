//
//  BreakingNewsData.swift
//  Alayam
//
//  Created by Mala on 9/6/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class BreakingNewsData: NSObject {
   
}

class BreakingNewsRequestDTO: NSObject {
    var category = ""
}

class BreakingNewsResponseDTO: NSObject {
   
    var Data = DataDTO()
}

class BreakingNewsDataDTO : NSObject
{
    var HomeRegularNews = NSMutableArray()
   // var CategoryNews = NSMutableArray()
}

class BreakingNewsContentDTO : NSObject {
    var ContentType = ""
    var SectionName = ""
    var IssueID : NSNumber = 0.0
    var NewsTitle = ""
    var NewsSubTitle = ""
    var NewsSummary = ""
    
    var NewsPhotoCaption = ""
    var NewsDetails = ""
    
    var NewsDate = ""
    var ImageURL = ""
    var ImageURL_S = ""
    var ImageURL_EXS = ""
    var NEWSURL = ""
    var NEWSTIME = ""
}

class BreakingNewsDTO: BreakingNewsContentDTO {
}

class BreakingNewsCategoryDTO: BreakingNewsContentDTO
{
    
}

class TagsResponseDTO : NSObject
{
    var Data = DataDTO()
}

class TagsDTO : NSObject{
    
        var TagID : NSNumber = 0
        var Name = ""
}

class TagsNewsResponseDTO : NSObject
{
    var Data = DataDTO()
}

class TagsNewsDTO : NSObject{
    
    var Data = DataDTO()
    var Status = ""
    var ErrorMessage : String?
    var ErrorCode : String?
}


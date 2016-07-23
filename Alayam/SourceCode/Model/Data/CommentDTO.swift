//
//  CommentDTO.swift
//  Alayam
//
//  Created by admin on 27/06/16.
//  Copyright © 2016 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class GetCommentListResponseDTO: NSObject {
    
    var Data = DataDTO()
    var Status = ""
    var ErrorMessage : String?
    var ErrorCode : String?
    
}

class CommentsDTO: NSObject {
    
    var COMMENTID: NSNumber = 0
    var NEWSID: NSNumber = 0
    var SUBCOMMENTID: NSNumber = 0
    var NEWSURL = ""
    var COMMENTTITLE = ""
    var COMMENTS = ""
    var USERNAME = ""
    var CREATEDATE = ""
    var LOCKED = ""
    var CLIENTIP = ""
    var CSSCLASS = ""
    var COMMENTTYPE = ""
    var Likes = NSMutableArray()
    var ReplyComments = NSMutableArray()
    
}


class LikesDTO: NSObject {
    
    var AbuseType: NSNumber = 0
    var AbuseCount: NSNumber = 0
    var AbuseTypeDesc = ""
}

class ReplyCommentsDTO: NSObject {
    
    var COMMENTID: NSNumber = 0
    var NEWSID: NSNumber = 0
    var SUBCOMMENTID: NSNumber = 0
    var NEWSURL = ""
    var COMMENTTITLE = ""
    var COMMENTS = ""
    var USERNAME = ""
    var CREATEDATE = ""
    var LOCKED = ""
    var CLIENTIP = ""
    var CSSCLASS = ""
    var COMMENTTYPE = ""
    var Likes = NSMutableArray()
    var ReplyComments = NSMutableArray()
}


class AddCommentRequestDTO: NSObject {
    
    var NewsMainID = ""
    var MasterCommentID = ""
    var DeviceUniqueID = ""
    var CommentTitle = ""
    var CommentInfo = ""
    var DeviceType = "iOS"
    var CommentType = "" //"News" or "Article"
    var UserID = ""
    
    
}


class SubmitCommentFeedbackRequestDTO: NSObject {
    var CommentID = ""
    var UserID = ""
    var AbuseType = "" //
    var DeviceType = "ios"
}

class SubmitCommentFeedbackResponseDTO: NSObject {
    
    var Data = DataDTO()
    var Status = ""
    var ErrorMessage : String?
    var ErrorCode : String?
    
}
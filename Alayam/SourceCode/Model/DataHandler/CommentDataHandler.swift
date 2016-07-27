//
//  CommentDataHandler.swift
//  Alayam
//
//  Created by admin on 26/06/16.
//  Copyright © 2016 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class CommentDataHandler: NSObject {
    
    func getCommentListWithPagination(isLoaderNeed : Bool, pageNumber : Int, numberOfNews : Int,queryParameter: HomeSliderNewsRequestDTO?,newsID: String,commentType: String, Completion Handler : (GetCommentListResponseDTO!) -> Void, failureHandler:(NSError?) ->Void)
    {
        
        let url : NSString = NSString(format:APIConstants.urlConstant.commentList.rawValue,"\(pageNumber)","\(numberOfNews)","\(newsID)","NEWS")
        
        WebServiceHandler().getMethod(isLoaderNeed, url: url as String, header: ["authorization" : ""], body: nil) { (responseDict, error) -> Void in
            
            if let _ = responseDict
            {
                Handler(GetCommentListResponseDTO().initWithJsonRootDictionary(responseDict))
            }
            else
            {
                failureHandler(error)
            }
        }
        
    }

    
    func postNewComment(isLoaderNeed : Bool, queryParameter: AddCommentRequestDTO?, parameter : [String : AnyObject]?, Completion Handler : (SubmitCommentFeedbackResponseDTO!) -> Void, failureHandler: (NSError?) -> Void)
    {
        WebServiceHandler().postMethod(APIConstants.urlConstant.addComment.rawValue, header: ["authorization" : ""], body: swiftToJsonParser(queryParameter!) as? [String : AnyObject]){
            (responseDict, error) -> Void in
            if let _ = responseDict
            {
                Handler(SubmitCommentFeedbackResponseDTO().initWithJsonRootDictionary(responseDict))
            }
            else
            {
                failureHandler(error)
            }
        }
    }
    
    
    func submitFeedbackForComment(isLoaderNeed : Bool, queryParameter: SubmitCommentFeedbackRequestDTO?, parameter : [String : AnyObject]?, Completion Handler : (SubmitCommentFeedbackResponseDTO!) -> Void, failureHandler: (NSError?) -> Void)
    {
        WebServiceHandler(show: isLoaderNeed).postMethod(APIConstants.urlConstant.sendFeedBackLike.rawValue, header: ["authorization" : ""], body: swiftToJsonParser(queryParameter!) as? [String : AnyObject]){
            (responseDict, error) -> Void in
            if let _ = responseDict
            {
                Handler(SubmitCommentFeedbackResponseDTO().initWithJsonRootDictionary(responseDict))
            }
            else
            {
                failureHandler(error)
            }
        }
    }
}

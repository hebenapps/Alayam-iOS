//
//  CommentModel.swift
//  Alayam
//
//  Created by admin on 27/06/16.
//  Copyright © 2016 Vaijayanthi Mala. All rights reserved.
//

import UIKit

protocol CommentModelDelegate {
    
    func getCommentListSuccess(commentList: NSMutableArray)
    
    func addNewCommentSuccess()
    
    func submitFeedbackCommentSuccess()
    
}

class CommentModel: NSObject {
    
    var delegate: CommentModelDelegate?
    
    var commentList = NSMutableArray()
    
    func getCommentList(showLoader: Bool, newsId: String, commentType: String) {
        
        CommentDataHandler().getCommentListWithPagination(showLoader, pageNumber: 1, numberOfNews: 100, queryParameter: nil, newsID: newsId, commentType: commentType, Completion: { (response) in
            
            if response != nil {
                
                self.commentList = response.Data.Comments
                
                self.delegate?.getCommentListSuccess(response.Data.Comments)
                
            }
            
            }) { (error) in
                
        }
    }
    
    func addNewComment(request: AddCommentRequestDTO) {
        
        CommentDataHandler().postNewComment(true, queryParameter: request, parameter: nil, Completion: { (response) -> Void in
            
            if response != nil && response.Status == "true" {
            
                self.delegate?.addNewCommentSuccess()
                
            }
            
            }) { (error) in
                
                
        }
        
    }
    
    func submitFeedBackForComment(request: SubmitCommentFeedbackRequestDTO) {
        
        CommentDataHandler().submitFeedbackForComment(false, queryParameter: request, parameter: nil, Completion: { (response) in
            
//            if response.Status == "false" {
//                return
//            }
            self.delegate?.submitFeedbackCommentSuccess()
            
            }) { (error) in
                
        }
        
    }
}

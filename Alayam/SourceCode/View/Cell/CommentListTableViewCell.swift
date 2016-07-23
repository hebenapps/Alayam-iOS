//
//  CommentListTableViewCell.swift
//  Alayam
//
//  Created by admin on 03/07/16.
//  Copyright © 2016 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class CommentListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCommentTitle: UILabel!
    
    @IBOutlet weak var lblCommentUserName: UILabel!
    
    @IBOutlet weak var lblCommentdate: UILabel!
    
    @IBOutlet weak var lblCommentDescription: UILabel!
    
    @IBOutlet weak var btnRlyComment: UIButton!
    
    @IBOutlet weak var lblLikeCount: UILabel!
    
    @IBOutlet weak var lblUnLikeCount: UILabel!
    
    @IBOutlet weak var btnLikeComment: UIButton!
    
    @IBOutlet weak var btnUnlikeComment: UIButton!
    
    @IBOutlet weak var btnViewReply: UIButton!
    
    @IBOutlet weak var constraintCommentTitleHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureCell(commentDetails: CommentsDTO) {
        
        lblCommentTitle.text = commentDetails.COMMENTTITLE
        
        lblCommentUserName.text = commentDetails.USERNAME
        
        lblCommentdate.text = commentDetails.CREATEDATE
        
        lblCommentDescription.text = commentDetails.COMMENTS
        
        let likePredicate = NSPredicate(format: "AbuseType = %d",  1)
        
        let likeArray = commentDetails.Likes.filteredArrayUsingPredicate(likePredicate)
        
        if likeArray.count > 0 {
            
            if let likecount = likeArray[0] as? LikesDTO {
                
                lblLikeCount.text = "\(likecount.AbuseCount)"
                
            }
        }
        
        let unlikePredicate = NSPredicate(format: "AbuseType = %d",  2)
        
        let unlikeArray = commentDetails.Likes.filteredArrayUsingPredicate(unlikePredicate)
        
        
        if unlikeArray.count > 0 {
            
            if let unlikecount = unlikeArray[0] as? LikesDTO {
                
                lblUnLikeCount.text = "\(unlikecount.AbuseCount)"
                
            }
            
        }
        
        
        if commentDetails.ReplyComments.count == 0 {
            
            btnViewReply.hidden = true
            btnViewReply.setTitle("", forState: UIControlState.Normal)
            
        }
        else {
            
            btnViewReply.hidden = false
            btnViewReply.setTitle("ردود رأي", forState: UIControlState.Normal)
            
        }
    }
    
    
    func configureCellWithReply(commentDetails: ReplyCommentsDTO) {
        
        constraintCommentTitleHeight.constant = 0
        
        lblCommentUserName.text = commentDetails.USERNAME
        
        lblCommentdate.text = commentDetails.CREATEDATE
        
        lblCommentDescription.text = commentDetails.COMMENTS
        
        let likePredicate = NSPredicate(format: "AbuseType = %d",  1)
        
        let likeArray = commentDetails.Likes.filteredArrayUsingPredicate(likePredicate)
        
        if likeArray.count > 0 {
            
            if let likecount = likeArray[0] as? LikesDTO {
                
                lblLikeCount.text = "\(likecount.AbuseCount)"
                
            }
        }
        
        let unlikePredicate = NSPredicate(format: "AbuseType = %d",  2)
        
        let unlikeArray = commentDetails.Likes.filteredArrayUsingPredicate(unlikePredicate)
        
        
        if unlikeArray.count > 0 {
            
            if let unlikecount = unlikeArray[0] as? LikesDTO {
                
                lblUnLikeCount.text = "\(unlikecount.AbuseCount)"
                
            }
            
        }
            
        btnRlyComment.hidden = true
        btnViewReply.setTitle("", forState: UIControlState.Normal)
        btnViewReply.hidden = true
        
        
    }
    
    
}

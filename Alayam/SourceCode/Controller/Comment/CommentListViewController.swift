//
//  CommentListViewController.swift
//  Alayam
//
//  Created by admin on 26/06/16.
//  Copyright © 2016 Vaijayanthi Mala. All rights reserved.
//

import UIKit

import FBSDKCoreKit

import FBSDKLoginKit

@objc
protocol CommentListViewControllerDelegate {
    
    optional func commentListCount(count: Int)
    
}


class CommentListViewController: UIViewController {
    
    var model = CommentModel()
    
    var newsMainId = ""
    
    var commentMailId: NSNumber = 0
    
    var commentType = "News"
    
    var comments = NSMutableArray()
    
    var isReplyCommentList = false
    
    var delegate: CommentListViewControllerDelegate?
    
    private var indexpathRow = -1
    
    private var abuseType = 1
    
    @IBOutlet weak var tblViewCommentList: UITableView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnAddComment: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        
        tblViewCommentList.rowHeight = UITableViewAutomaticDimension
        tblViewCommentList.estimatedRowHeight = 180
        
        if isReplyCommentList {
            
            btnAddComment.hidden = true
                
            lblTitle.text = "ردود"
        }
        
        
//        let button = FBSDKLoginButton()
//        button.center = self.view.center
//        self.view.addSubview(button)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(sender: AnyObject) {
        
        delegate?.commentListCount?(comments.count)
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func btnAddCommentAction(sender: AnyObject) {
        
//        let login = LocalCacheDataHandler().getUserLoginDetails()
//        
//        if login == "" {
//            
//            navigateToLoginViewController()
//            
//        }
//        else {
        
            navigateToAddCommentViewController()
            
//        }
        
        
    }
    
    func btnRlyCommentAction(sender: UIButton) {
        
        let login = LocalCacheDataHandler().getUserLoginDetails()
        
        if login == "" {
            
            navigateToLoginViewController()
            
        }
        else {
            
            let commentDetail = comments.objectAtIndex(sender.tag) as! CommentsDTO
        
            let addCommentViewcontroller = getViewControllerInstance("Comment", storyboardId: "AddCommentViewControllerID") as! AddCommentViewController
            
            addCommentViewcontroller.newsID = newsMainId
            
            addCommentViewcontroller.commentId = "\(commentDetail.COMMENTID)"
            
            addCommentViewcontroller.delegate = self
            
            self.navigationController?.pushViewController(addCommentViewcontroller, animated: true)
            
        }
    
    }
    
    func btnLikeAction(sender: UIButton) {
        
        indexpathRow = sender.tag
        
        abuseType = 1
        
        
        if isReplyCommentList {
            
            let commentDetail = comments.objectAtIndex(sender.tag) as! ReplyCommentsDTO
            
            
            model.submitFeedBackForComment(generateSubmitFeedbackRequest("1", commentId: "\(commentDetail.COMMENTID)"))
        }
        else {
            
            let commentDetail = comments.objectAtIndex(sender.tag) as! CommentsDTO
    
            model.submitFeedBackForComment(generateSubmitFeedbackRequest("1", commentId: "\(commentDetail.COMMENTID)"))
            
        }
        
    }
    
    
    func btnUnlikeAction(sender: AnyObject) {
        
        indexpathRow = sender.tag
        
        abuseType = 2
        
        if isReplyCommentList {
            
            let commentDetail = comments.objectAtIndex(sender.tag) as! ReplyCommentsDTO
            
            model.submitFeedBackForComment(generateSubmitFeedbackRequest("2", commentId: "\(commentDetail.COMMENTID)"))
        }
        else {
            
            let commentDetail = comments.objectAtIndex(sender.tag) as! CommentsDTO
            
            model.submitFeedBackForComment(generateSubmitFeedbackRequest("2", commentId: "\(commentDetail.COMMENTID)"))
        }
        
    }
    
    func btnViewRlyCommentList(sender: UIButton) {
        
        let commentDetail = comments.objectAtIndex(sender.tag) as! CommentsDTO
        
        let commentsViewController = self.getViewControllerInstance("Comment", storyboardId: "CommentListViewControllerID") as! CommentListViewController
        
        commentsViewController.comments = commentDetail.ReplyComments
        
        commentsViewController.newsMainId = newsMainId
        
        commentsViewController.commentMailId = commentDetail.COMMENTID
        
        commentsViewController.isReplyCommentList = true
        
        self.navigationController?.pushViewController(commentsViewController, animated: true)
        
    }
    
    private func navigateToLoginViewController() {
        
        let loginViewcontroller = getViewControllerInstance("Register", storyboardId: "LoginViewControllerID") as! LoginViewController
        
        let nvc = UINavigationController(rootViewController: loginViewcontroller)
        nvc.navigationBarHidden = true
        
        self.presentViewController(nvc, animated: true, completion: nil)
        
    }
    
    private func navigateToAddCommentViewController() {
        
        let addCommentViewcontroller = getViewControllerInstance("Comment", storyboardId: "AddCommentViewControllerID") as! AddCommentViewController
        
        addCommentViewcontroller.newsID = newsMainId
        
        addCommentViewcontroller.delegate = self
        
        self.navigationController?.pushViewController(addCommentViewcontroller, animated: true)
        
    }
    
    private func generateSubmitFeedbackRequest(abuseType: String,commentId: String) -> SubmitCommentFeedbackRequestDTO {
        
        
        let request = SubmitCommentFeedbackRequestDTO()
        
        request.AbuseType = abuseType
        
        request.CommentID = commentId
        
        let userDetails = LocalCacheDataHandler().getUserLoginDetails()
        
        if userDetails == "" {
            
            request.UserID = "1"
            
        }
        else {
            
            request.UserID = userDetails
            
        }
        
        
        return request
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CommentListViewController: CommentModelDelegate {
    
    func getCommentListSuccess(commentList: NSMutableArray) {
        
        if isReplyCommentList {
            
            for item in commentList {
                
                if let item = item as? CommentsDTO {
                    
                    if item.COMMENTID == commentMailId {
                        
                        self.comments = item.ReplyComments
                        
                        break
                    }
                    
                }
                
            }
            
        }
        else {
            
            self.comments = commentList
            
        }
        
        tblViewCommentList.reloadData()
        
    }
    
    func addNewCommentSuccess() {
        
    }
    
    func submitFeedbackCommentSuccess() {
        
        model.getCommentList(false, newsId: newsMainId, commentType: commentType)
        
//        if isReplyCommentList {
//            
//            if let value = self.comments.objectAtIndex(indexpathRow) as? ReplyCommentsDTO {
//                
//                let unlikePredicate = NSPredicate(format: "AbuseType = %d",  abuseType)
//                
//                let unlikeArray = value.Likes.filteredArrayUsingPredicate(unlikePredicate)
//                
//                
//                if unlikeArray.count > 0 {
//                    
//                    if let unlikecount = unlikeArray[0] as? LikesDTO {
//                        
//                        unlikecount.AbuseCount = Int(unlikecount.AbuseCount) + 1
//                        
//                    }
//                    
//                }
//                
//                self.comments[indexpathRow] = value
//                
//                tblViewCommentList.reloadData()
//                
//            }
//            
//        }
//        else {
//            if let value = self.comments.objectAtIndex(indexpathRow) as? CommentsDTO {
//                
//                let unlikePredicate = NSPredicate(format: "AbuseType = %d",  abuseType)
//                
//                let unlikeArray = value.Likes.filteredArrayUsingPredicate(unlikePredicate)
//                
//                
//                if unlikeArray.count > 0 {
//                    
//                    if let unlikecount = unlikeArray[0] as? LikesDTO {
//                        
//                        unlikecount.AbuseCount = Int(unlikecount.AbuseCount) + 1
//                        
//                    }
//                    
//                }
//                
//                self.comments[indexpathRow] = value
//                
//                tblViewCommentList.reloadData()
//                
//            }
//            
//        }
    }
    
}

extension CommentListViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CommentListTableViewCell
        
        if isReplyCommentList {
            
            let commentDetail = comments.objectAtIndex(indexPath.row) as! ReplyCommentsDTO
            
            cell.configureCellWithReply(commentDetail)
            
            
        }
        else {
            
            let commentDetail = comments.objectAtIndex(indexPath.row) as! CommentsDTO
            
            cell.configureCell(commentDetail)
            
            
            cell.btnRlyComment.tag = indexPath.row
            
            cell.btnViewReply.tag = indexPath.row
            
            cell.btnRlyComment.addTarget(self, action: #selector(CommentListViewController.btnRlyCommentAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.btnViewReply.addTarget(self, action: #selector(CommentListViewController.btnViewRlyCommentList(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
        }
        
        cell.btnUnlikeComment.tag = indexPath.row
        
        cell.btnLikeComment.tag = indexPath.row
        
        cell.btnLikeComment.addTarget(self, action: #selector(CommentListViewController.btnLikeAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.btnUnlikeComment.addTarget(self, action: #selector(CommentListViewController.btnUnlikeAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        return 155
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.delegate?.tableView?(tableView, didDeselectRowAtIndexPath: indexPath)
        
    }
    
    
}


extension CommentListViewController: AddCommentViewControllerDelegate {
    
    func refreshCommentList() {
        model.getCommentList(true, newsId: newsMainId, commentType: commentType)
    }
    
    
}
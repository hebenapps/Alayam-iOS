//
//  AddCommentViewController.swift
//  Alayam
//
//  Created by admin on 26/06/16.
//  Copyright © 2016 Vaijayanthi Mala. All rights reserved.
//

import UIKit

import GoogleSignIn

import FBSDKLoginKit

protocol AddCommentViewControllerDelegate {
    
    func refreshCommentList()
    
}

class AddCommentViewController: UIViewController {
    
    
    @IBOutlet weak var btnLoginLogout: UIButton!
    
    @IBOutlet weak var btnUserName: UIButton!
    
    @IBOutlet weak var lblUserCaption: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var txtFldCommentTitle: UITextField!
    
    @IBOutlet weak var txtViewCommentDescription: UITextView!
    
    var delegate: AddCommentViewControllerDelegate?
    
    var newsID: String = ""
    
    //if comment id is not empty screen should act as reply comment page
    var commentId: String = ""
    
    var commentType = "News"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWithLoginDetails()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnLogoutOrLoginAction(sender: AnyObject) {
        
        let userDetails = LocalCacheDataHandler().getUserLoginDetails()
        
        
        if userDetails == "" {
            
            navigateToLoginViewController()
            
        }
        else {
            
            LocalCacheDataHandler().updateLoginUserData("")
            
            LocalCacheDataHandler().updateLoginUserName("")
            
            GIDSignIn.sharedInstance().signOut()
            
            FBSDKLoginManager().logOut()
            
            configureWithLoginDetails()
            
        }
        
        
    }
    
    @IBAction func btnBackAction(sender: AnyObject) {
        
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func btnPostCommentAction(sender: AnyObject) {
        
        if isValidationSuccess() {
            
            if commentId != "" {
                
                let userDetails = LocalCacheDataHandler().getUserLoginDetails()
                
                
                if userDetails == "" {
                    
                    navigateToLoginViewController()
                    
                    return
                    
                }
            }
            
            CommentDataHandler().postNewComment(true, queryParameter: generateRequest(), parameter: nil, Completion: { (response) in
                
                if response != nil && response.Status == "true" {
                    
                    self.navigationController?.popViewControllerAnimated(true)
                    
                    self.delegate?.refreshCommentList()
                }
                
            }) { (error) in
                
                
            }
            
        }
    }
    
    
    func configureWithLoginDetails() {
        
        let userDetails = LocalCacheDataHandler().getUserLoginDetails()
        
        if userDetails == "" {
            
            btnLoginLogout.setTitle("تسجيل الدخول", forState: UIControlState.Normal)
            
            lblUserCaption.text = "أنت تعلق كزائر"
            
            btnUserName.setTitle("ضيف", forState: UIControlState.Normal)
            
        }
        else {
            
            btnLoginLogout.setTitle("خروج", forState: UIControlState.Normal)
            
            lblUserCaption.text = "أنت تعلق بإسم"
            
            //TODO: User Name should be updated here
            
            let userName = LocalCacheDataHandler().getUserLoginUserName()
            
            btnUserName.setTitle(userName, forState: UIControlState.Normal)
            
        }

    }
    
    
    private func isValidationSuccess() -> Bool {
        
        if txtFldCommentTitle.text! == "" {
            
            let msg = "ادخل عنوان التعليق"
            
            UIAlertView(title: "", message: msg, delegate: nil, cancelButtonTitle: "Ok").show()
            
            return false
            
        }
        
        if txtViewCommentDescription.text == "" {
            
            let msg = "إدخال وصف تعليق"
            
            UIAlertView(title: "", message: msg, delegate: nil, cancelButtonTitle: "Ok").show()
            
            return false
            
            
        }
        
        return true
    }
    
    private func generateRequest() -> AddCommentRequestDTO {
        
        let request = AddCommentRequestDTO()
        
        request.NewsMainID = newsID
        
        request.MasterCommentID = commentId
        
        if let uudid = UIDevice.currentDevice().identifierForVendor?.UUIDString {
            
            request.DeviceUniqueID = uudid
            
        }
        
        request.CommentTitle = txtFldCommentTitle.text!
        
        request.CommentInfo = txtViewCommentDescription.text
        
        request.CommentType = commentType
        
        let userDetails = LocalCacheDataHandler().getUserLoginDetails()
        
        if userDetails == "" {
            
            request.UserID = "1"
            
        }
        else {
            
            request.UserID = userDetails
            
        }
        
        return request
        
    }
    
    
    private func navigateToLoginViewController() {
        
        let loginViewcontroller = getViewControllerInstance("Register", storyboardId: "LoginViewControllerID") as! LoginViewController
        
        loginViewcontroller.delegate = self
        
        let nvc = UINavigationController(rootViewController: loginViewcontroller)
        
        nvc.navigationBarHidden = true
        
        self.presentViewController(nvc, animated: true, completion: nil)
        
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


extension AddCommentViewController: LoginViewControllerDelegate {
    
    func loginSuccess() {
        
        configureWithLoginDetails()
        
    }
    
}

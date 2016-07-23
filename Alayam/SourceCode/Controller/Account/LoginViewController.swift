//
//  LoginViewController.swift
//  Alayam
//
//  Created by admin on 26/06/16.
//  Copyright © 2016 Vaijayanthi Mala. All rights reserved.
//

import UIKit

import GoogleSignIn

import FBSDKCoreKit

import FBSDKLoginKit


protocol LoginViewControllerDelegate {

    func loginSuccess()
    
}


class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var lblUserName: UITextField!
    
    @IBOutlet weak var lblPassword: UITextField!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    var delegate: LoginViewControllerDelegate?
    
    
    var model = UserAccountModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnLoginAction(sender: AnyObject) {
        
        if isValidationSuccess() {
            
            model.loginToViewcontroller(false, request: generateRequest())
            
        }
    
    }
    
    
    @IBAction func btnBackAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func btnGooglePlusSignInAction(sender: AnyObject) {
        
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    @IBAction func btnFaceBookClickAction(sender: AnyObject) {
        
        
        
        
        
        let loginManager = FBSDKLoginManager()
        
        
        loginManager.logInWithReadPermissions(["email", "public_profile"],fromViewController: self ){ result, error in
            var token = ""
            if error != nil {
                print("error")
            }else if(result.isCancelled){
                print("result cancelled")
            }else{
                token = result.token.tokenString
                let params = ["fields": "id, link, first_name, last_name, email, gender, picture"]
                let fbRequest = FBSDKGraphRequest(graphPath:"me", parameters: params);
                fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                    
                    if error == nil {
                        let request = RegisterSocialUserRequestDTO()
                        
                        if let results = result as? NSDictionary{
                            print(results)
                            request.FullName = results.objectForKey("first_name") as! String
                            request.UserName = results.objectForKey("first_name") as? String ?? ""
                            request.ProviderID = results.objectForKey("id") as! String
                            request.ProfileURL = (results.objectForKey("link") as? String) ?? "www.google.com"
                            //                            if let  = (results.objectForKey("is_silhouette") as? String) {
                            //                                request.ProfilePicURL = "http://graph.facebook.com/\(request.ProviderID)/picture?width=300&height=300"
                            //                            }
                            request.Email = results.objectForKey("email") as! String
                            
                            
                            request.AccessToken = token
                            request.DisplayName = request.UserName
                            request.FirstName = request.UserName
                            request.MiddleName = request.UserName
                            request.LastName = results.objectForKey("last_name") as? String ?? ""
                            request.DOB = "03/31/1992"
                            request.Gender = "Male"
                            request.ProfileURL = "www.google.com"
                            request.ProfilePicURL = "www.google.com"
                            request.Country = "IN"
                            request.Language = "EN"
                            request.Provider = "facebook"
                            
                            if let uuidString = UIDevice.currentDevice().identifierForVendor?.UUIDString {
                                
                                request.Identifier = uuidString
                                
                            }
                            
                            self.model.registerSocialUser(request)
                        } else {
                            print("Error Getting Info \(error)");
                        }
                    }
                }
            }
            
        }
    }
    
    
    @IBAction func btnRegisterAction(sender: AnyObject) {
        
        navigateToRegisterViewController()
        
    }
    
    func isValidationSuccess() -> Bool {
        
        
        if lblUserName.text! == "" {
            
            //enter your email id or user name
            
            let alert = "إدخال اسم المستخدم البريد الالكتروني أو اسم المستخدم"

            
            UIAlertView(title: "", message: alert , delegate: nil, cancelButtonTitle: "حسنا").show()
            
            return false
            
        }
        
        
        if lblPassword.text! == "" {
            
            // enter your password
            
            let alert = "ادخل رقمك السري"
            
            UIAlertView(title: "", message: alert , delegate: nil, cancelButtonTitle: "حسنا").show()
            
            return false
            
        }
        
        
        return true
        
    }
    
    private func navigateToRegisterViewController() {
        
        let registerVC = getViewControllerInstance("Register", storyboardId: "RegisterViewControllerID") as! RegisterViewController
        
        registerVC.delegate = self
        
        self.navigationController?.pushViewController(registerVC, animated: true)
        
    }

    private func generateRequest() -> LoginRequestDTO {
        
        let request = LoginRequestDTO()
        
        request.Email = lblUserName.text!
        
        request.Password = lblPassword.text!
        
        request.LoginMode = "EmailID"
        
//        [[[UIDevice currentDevice] identifierForVendor] UUIDString]
        if let uuidString = UIDevice.currentDevice().identifierForVendor?.UUIDString {
            
            request.IdentifierID = uuidString
            
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


extension LoginViewController: UserAccountModelDelegate {
    
    func loginAPISuccess() {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        delegate?.loginSuccess()
        
    }
    
    func registerAPISuccess(dismissLoginView: Bool) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        delegate?.loginSuccess()
        
    }
    
}


extension LoginViewController: GIDSignInDelegate {
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
            let email = user.profile.email
            
            let request = RegisterSocialUserRequestDTO()
            
            request.Email = email
            request.ProviderID = userId
            request.AccessToken = user.authentication.idToken
            request.UserName = fullName
            request.FullName = user.profile.name
            request.DisplayName = user.profile.name
            request.FirstName = user.profile.familyName
            request.MiddleName = user.profile.name
            request.LastName = user.profile.name
            request.DOB = "03/31/1992"
            request.Gender = "Male"
            request.ProfileURL = "www.google.com"
            request.ProfilePicURL = "www.google.com"
            request.Country = "IN"
            request.Language = "EN"
            
            if let uuidString = UIDevice.currentDevice().identifierForVendor?.UUIDString {
                
                request.Identifier = uuidString
                
            }
            
            model.registerSocialUser(request)
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
//        myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


extension LoginViewController: RegisterViewControllerDelegate {
    
    func registerViewControllerSuccess(dismissLoginView: Bool) {
        
        if dismissLoginView {
            
            self.delegate?.loginSuccess()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
    
}
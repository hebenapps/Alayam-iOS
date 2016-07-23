//
//  RegisterViewController.swift
//  Alayam
//
//  Created by admin on 26/06/16.
//  Copyright © 2016 Vaijayanthi Mala. All rights reserved.
//

import UIKit

import GoogleSignIn

import FBSDKCoreKit

import FBSDKLoginKit

protocol RegisterViewControllerDelegate {
    
    func registerViewControllerSuccess(dismissLoginView: Bool)
    
}

class RegisterViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtFldUserName: UITextField!
    @IBOutlet weak var txtFldEmailId: UITextField!
    @IBOutlet weak var txtFldMobileNumber: UITextField!
    @IBOutlet weak var txtFldCountry: UITextField!
    @IBOutlet weak var txtFldCountryCode: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var txtFldConfirmPassword: UITextField!
    
    @IBOutlet weak var constraintScrollViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    var delegate: RegisterViewControllerDelegate?
    
    var model = UserAccountModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyboardNotifications()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().delegate = self
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func btnRegisterAction(sender: AnyObject) {
        
        
        if isValidationSuccess() {
            
            
            model.registerUser(generateRegisterRequest())
            
        }
        
    }
    
    
    
    
    @IBAction func btnBackAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func btnGoogleAction(sender: AnyObject) {
        
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
    
    private func generateRegisterRequest() -> RegisterRequestDTO {
        
        let request = RegisterRequestDTO()
        
        request.Name = txtFldName.text!
        request.UserName = txtFldUserName.text!
        request.Email = txtFldEmailId.text!
        request.PhoneNumber = txtFldMobileNumber.text!
        request.CountryCode = txtFldCountryCode.text!
        request.Country = txtFldCountry.text!
        request.Password = txtFldPassword.text!
        
        return request
        
    }
    
    
    
    private func isValidationSuccess() -> Bool {
        
        if txtFldName.text == "" {
            
            UIAlertView(title: "", message: "يرجى إدخال اسم", delegate: nil, cancelButtonTitle: "حسنا").show()
            
            return false
        }
        
        if txtFldUserName.text == "" {
            
            UIAlertView(title: "ادخل اسم المستخدم", message: "", delegate: nil, cancelButtonTitle: "حسنا").show()
            
            
            
            return false
        }
        
        
        if txtFldEmailId.text == "" {
            
            UIAlertView(title: "", message: "ادخل بريدك الالكتروني", delegate: nil, cancelButtonTitle: "حسنا").show()
            
            
            
            return false
        }
        
        
        if txtFldMobileNumber.text == "" {
            
            UIAlertView(title: "", message: "الرجاء ادخال رقم هاتف صحيح", delegate: nil, cancelButtonTitle: "حسنا").show()
            
            
            
            return false
        }
        
        
        if txtFldPassword.text == "" {
            
            UIAlertView(title: "", message: "ادخل كلمة المرو", delegate: nil, cancelButtonTitle: "حسنا").show()
            
            
            
            return false
        }
        
        
        
        if txtFldConfirmPassword.text == "" {
            
            UIAlertView(title: "", message: "يرجى إدخال تأكيد كلمة", delegate: nil, cancelButtonTitle: "حسنا").show()
            
            
            
            return false
        }
        
        
        
        if txtFldCountry.text == "" {
            
            UIAlertView(title: "", message: "ادخل اسم البلد", delegate: nil, cancelButtonTitle: "حسنا").show()
            
            
            
            return false
        }
        
        
        if txtFldCountryCode.text == "" {
            
            UIAlertView(title: "", message: "يرجى إدخال رمز البلد", delegate: nil, cancelButtonTitle: "حسنا").show()
            
            
            
            return false
        }
        
        
        if txtFldConfirmPassword.text! != txtFldPassword.text! {
            
            UIAlertView(title: "", message: "كلمة المرور غير مطابقة", delegate: nil, cancelButtonTitle: "حسنا").show()
            
            
            
            return false
        }
        
        
        return true
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


extension RegisterViewController: UserAccountModelDelegate {
    
    func loginAPISuccess() {
        
    }
    
    func registerAPISuccess(dismissLoginView: Bool) {
        
        self.delegate?.registerViewControllerSuccess(dismissLoginView)
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}

extension RegisterViewController: GIDSignInDelegate {
    
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
    
}


extension RegisterViewController {
    
    func registerForKeyboardNotifications() {
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
                                       selector: #selector(RegisterViewController.keyboardWillBeShown(_:)),
                                       name: UIKeyboardWillShowNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(RegisterViewController.keyboardWillBeHidden(_:)),
                                       name: UIKeyboardWillHideNotification,
                                       object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: NSNotification) {
        
        let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        
        
        self.constraintScrollViewBottom.constant = keyboardSize!.height
        self.view.layoutIfNeeded()
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        
        self.constraintScrollViewBottom.constant = 50
        self.view.layoutIfNeeded()
    }
    
}


extension UIView
{
    @IBInspectable var viewBorderColor: UIColor? {
        get {
            return UIColor(CGColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.CGColor
        }
    }
    
    @IBInspectable
    var borderWidth :  CGFloat  {
        get  {
            return  self.layer . borderWidth
        }
        set  {
            self.layer.borderWidth = newValue
        }
    }
}


extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}


class TextField: UITextField {
    let inset: CGFloat = 10
    
    // placeholder position
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , inset , inset)
    }
    
    // text position
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , inset , inset)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
}
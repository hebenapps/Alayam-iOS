//
//  UserAccountDataHandler.swift
//  Alayam
//
//  Created by admin on 02/07/16.
//  Copyright © 2016 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class UserAccountDataHandler: NSObject {
    
    func loginUser(isSocialUser: Bool, queryParameter: LoginRequestDTO?, parameter : [String : AnyObject]?, Completion Handler : (SubmitCommentFeedbackResponseDTO!) -> Void, failureHandler: (NSError?) -> Void)
    {
        var url = ""
        
        if isSocialUser {
            
            url = APIConstants.urlConstant.loginSocial.rawValue
            
        }
        else {
            
            url = APIConstants.urlConstant.loginAlayam.rawValue
            
        }
        WebServiceHandler().postMethod(url, header: ["authorization" : ""], body: swiftToJsonParser(queryParameter!) as? [String : AnyObject]){
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
    
    
    func registerSocialUser(queryParameter: RegisterSocialUserRequestDTO?, Completion Handler : (RegisterResponseDTO!) -> Void, failureHandler: (NSError?) -> Void)
    {
        let url = APIConstants.urlConstant.registerSocial.rawValue
        
        WebServiceHandler().postMethod(url, header: ["authorization" : ""], body: swiftToJsonParser(queryParameter!) as? [String : AnyObject]){
            (responseDict, error) -> Void in
            if let _ = responseDict
            {
                Handler(RegisterResponseDTO().initWithJsonRootDictionary(responseDict))
            }
            else
            {
                failureHandler(error)
            }
        }
    }
    
    func registerUser(queryParameter: RegisterRequestDTO?, Completion Handler : (RegisterResponseDTO!) -> Void, failureHandler: (NSError?) -> Void)
    {
        let url = APIConstants.urlConstant.registerUser.rawValue
        
        WebServiceHandler().postMethod(url, header: ["authorization" : ""], body: swiftToJsonParser(queryParameter!) as? [String : AnyObject]){
            (responseDict, error) -> Void in
            if let _ = responseDict
            {
                Handler(RegisterResponseDTO().initWithJsonRootDictionary(responseDict))
            }
            else
            {
                failureHandler(error)
            }
        }
    }

}

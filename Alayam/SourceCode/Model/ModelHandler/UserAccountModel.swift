//
//  UserAccountModel.swift
//  Alayam
//
//  Created by admin on 02/07/16.
//  Copyright © 2016 Vaijayanthi Mala. All rights reserved.
//

import UIKit

protocol UserAccountModelDelegate {

    func loginAPISuccess()
    
    func registerAPISuccess(dismissLoginView: Bool)
    
}


class UserAccountModel: NSObject {
    
    var delegate: UserAccountModelDelegate?
    
    
    func loginToViewcontroller(isSocialUser: Bool,request: LoginRequestDTO) {
        
        UserAccountDataHandler().loginUser(isSocialUser, queryParameter: request, parameter: nil, Completion: { (response) in
            
            if response != nil  {
                
                if response.Status == "true" {
                
                if response.Data.UserDetails.count > 0 {
                    
                    if let userId = response.Data.UserDetails[0] as? UserDetailsDTO {
                        
                        LocalCacheDataHandler().updateLoginUserName(userId.NAME)
                        LocalCacheDataHandler().updateLoginUserData("\(userId.USERID)")
                        
                        self.delegate?.loginAPISuccess()
                        
                        
                    }
                    
                }
                }else {
                    
                    UIAlertView(title: "", message: response.ErrorMessage ?? "", delegate: nil, cancelButtonTitle: "حسنا").show()
                    
                }
                
            }
            
            
            }) { (error) in
                
                
                
                
        }
        
    }
    
    
    func registerSocialUser(request: RegisterSocialUserRequestDTO) {
        
        
        UserAccountDataHandler().registerSocialUser(request, Completion: { (response) in
            
            if response != nil && response.Status == "true" {
                
                if let userId = response.Data.SocialUserDetails[0] as? SocialUserDetailsDTO {
                    
                    LocalCacheDataHandler().updateLoginUserName(userId.SDISPLAYNAME)
                    
                    LocalCacheDataHandler().updateLoginUserData("\(userId.SAID)")
                    
                    self.delegate?.registerAPISuccess(true)
                    
                }
                
            }
            
        }) { (error) in
            
            
        }
        
        
        
    }
    
    func registerUser(request: RegisterRequestDTO) {
        
        
        UserAccountDataHandler().registerUser(request, Completion: { (response) in
            
            if response != nil  {
                
                if response.Status == "true" {
                    
                    self.delegate?.registerAPISuccess(false)
                }
                else {
                
                UIAlertView(title: "", message: response.ErrorMessage ?? "", delegate: nil, cancelButtonTitle: "حسنا").show()
                    
                }
                
            }
            
        }) { (error) in
            
            
        }
        
        
        
    }
    

}

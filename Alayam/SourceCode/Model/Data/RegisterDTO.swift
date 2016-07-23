//
//  RegisterDTO.swift
//  Alayam
//
//  Created by admin on 27/06/16.
//  Copyright © 2016 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class RegisterRequestDTO: NSObject {
    
    var UserID: NSNumber = 0
    var Name = ""
    var UserName = ""
    var Email = ""
    var PhoneNumber = ""
    var CountryCode = ""
    var Country = ""
    var IsActive: NSNumber = 0
    var Password = ""
    
}

class RegisterResponseDTO: NSObject {
    
    var Data = DataDTO()
    var Status = ""
    var ErrorMessage : String?
    var ErrorCode : String?
    
}

class UserDetailsDTO: NSObject {
    var USERID: NSNumber = 0
    var NAME = ""
    var USERCODE = ""
    var EMAIL = ""
    var PHONENUMBER: NSNumber = 0
    var COUNTRYCODE = ""
    var COUNTRY = ""
    var EMAILACTIVE: NSNumber = 0
    var VPASSWORD = ""
    
}


class LoginRequestDTO: NSObject {
    var UserName = ""
    var Email = ""
    var Password = ""
    var LoginMode = ""
    var IdentifierID = ""
}


class RegisterSocialUserRequestDTO: NSObject {
    
    var Provider = "google+" //" facebook" / "google+"
    var Identifier = ""
    var ProviderID = ""
    var AccessToken = ""
    var UserName = ""
    var FullName = ""
    var DisplayName = ""
    var Email = ""
    var FirstName = ""
    var MiddleName = ""
    var LastName = ""
    var DOB = ""
    var Gender = ""
    var ProfileURL = ""
    var ProfilePicURL = ""
    var Country = ""
    var Language = ""
    
    
    
}

class SocialUserDetailsDTO: NSObject {
    
    var Provider = "google+"
    var Identifier = ""
    var ProviderID = ""
    var AccessToken = ""
    var UserName = ""
    var FullName = ""
    var DisplayName = ""
    var Email = ""
    var FirstName = ""
    var MiddleName = ""
    var LastName = ""
    var DOB = ""
    var Gender = ""
    var ProfileURL = ""
    var ProfilePicURL = ""
    var Country = ""
    var Language = ""
    
    var SDISPLAYNAME = ""
    var SPROVIDERID = ""
    var SEMAIL = ""
    var SAID: NSNumber = 0
    
}

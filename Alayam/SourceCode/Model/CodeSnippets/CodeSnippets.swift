//
//  LocationSearchViewController.swift
//  Alayam
//
//  Created by Mala on 7/20/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//


import UIKit

class CodeSnippets: NSObject {
    
    class func isValidEmail(emailAddress : String) -> Bool {
        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .CaseInsensitive)
        return regex?.firstMatchInString(emailAddress, options: [], range: NSMakeRange(0, emailAddress.characters.count)) != nil
    }
    
    class func isValidPassWord(passWord : String) -> Bool {
        
        if passWord.characters.count >= 4 && passWord.characters.count <= 15 {
            
            return true
        }
        
        return false
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
    }
}


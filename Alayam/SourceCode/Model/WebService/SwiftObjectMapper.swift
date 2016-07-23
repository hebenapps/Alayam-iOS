//
//  SwiftObjectMapper.swift
//  Alayam
//
//  Created by Jeyaraj on 27/04/15.
//  Copyright (c) 2015 hakuna. All rights reserved.
//

import UIKit

class SwiftObjectMapper: NSObject {
   
}

extension NSObject {
    
    // To create DTO object from json Which has dictionary as root object
    
    func initWithJsonRootDictionary(jsonInfo: NSDictionary) -> Self {
        let object = self
        
        (object as NSObject).loadDTOFromJsonDictionary(jsonInfo)
        
        return object
    }
    
    // To create DTO object from json which has Array as root object
    
    func initWithJsonRootArray(jsonArray: NSArray, rootClassName : String?) -> NSMutableArray {
        var object = self
        
        var jsonRootArray = NSMutableArray()
        
        var arrayList = NSMutableArray()
        
        for arrayValue in jsonArray
        {
            var nsObjectSubClass: AnyObject! = ObjectFactory<NSObject>.createInstance("Alayam.\(rootClassName!.capitalizedString)") as! AnyObject
            arrayList.addObject(nsObjectSubClass.initWithJsonRootDictionary(arrayValue as! NSDictionary))
        }
        
        return NSMutableArray()
    }
    
    private func loadDTOFromJsonDictionary(jsonInfo: NSDictionary) {
        
        // Enumerate the given dictionary with the keys
        
      //  print("\(jsonInfo)")
        
        for (key,value) in jsonInfo {
            let keyName = key as! String
            
            // If the value is dictionary, recursively call the initwithstring to create a custom class
            // var value : AnyObject = jsonInfo[keyName]!
            if value.isKindOfClass(NSDictionary)
            {
                let capitalised = keyName + "DTO"
                
                var nsObjectSubClass = ObjectFactory<NSObject>.createInstance("Alayam.\(capitalised)")
                NSLog("%@", "Alayam.\(capitalised)")
                if nsObjectSubClass == nil
                {
                    nsObjectSubClass = ObjectFactory<NSObject>.createInstance("Alayam.\(capitalised.substringToIndex(capitalised.endIndex.predecessor()))")
                    
                    
                    if nsObjectSubClass == nil {
                        
                        if (capitalised.substringToIndex(capitalised.endIndex.predecessor()) == "Range"){
                            nsObjectSubClass = ObjectFactory<NSObject>.createInstance("Alayam.\(capitalised.substringToIndex(capitalised.endIndex.predecessor()))1")
                        }
                        
                        if(nsObjectSubClass == nil){
                            continue
                        }
                    }
                }
                
                if let tempValue = value as? NSDictionary {
                    if self.respondsToSelector(NSSelectorFromString(keyName)) {
                    setValue(nsObjectSubClass!.initWithJsonRootDictionary(tempValue as NSDictionary), forKey: keyName)
                    }
                }
                
               // print("NSDictionary Class ----> \(value)")
            }
                
            else if value.isKindOfClass(NSArray)
            {
                let valueArray: NSArray! = value as! NSArray
                
                var arrayList = NSMutableArray()
                
                for arrayValue in valueArray
                {
                    if arrayValue.isKindOfClass(NSString)
                    {
                        arrayList.addObject(arrayValue)
                    }
                    else
                    {
                        let capitalised = keyName + "DTO"
                        
                        var nsObjectSubClass: AnyObject! = ObjectFactory<NSObject>.createInstance("Alayam.\(capitalised)")
                        
                        if nsObjectSubClass == nil
                        {
                            nsObjectSubClass = ObjectFactory<NSObject>.createInstance("Alayam.\(capitalised.substringToIndex(capitalised.endIndex.predecessor()))")
                            
//                            if nsObjectSubClass == nil {
//                                continue
//                            }
                        }
                        if nsObjectSubClass != nil {
                        arrayList.addObject(nsObjectSubClass.initWithJsonRootDictionary(arrayValue as! NSDictionary))
                        }
                    }
                }
                
                
//                if self.respondsToSelector(Selector.convertFromStringLiteral("set\(keyName):")) {
                if self.respondsToSelector(NSSelectorFromString(keyName)) {
                    setValue(arrayList, forKey: keyName)
                }
//                }
                
             //   print("NSArray Class ----> \(value)")
            }
            else{
                if self.respondsToSelector(NSSelectorFromString(keyName)) {
                
                    if value.isKindOfClass(NSNull) == false
                    {
                        setValue(value, forKey: keyName)
                    }
                }
                
            }
        }
    }
    
    
    func getUrlString(parseObj : AnyObject) -> String{
        var outCount:UInt32 = 0;
        var urlString = "?"
        let poperites: UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(object_getClass(parseObj), &outCount)
        let intCount = Int(outCount)
        for var i = 0; i < intCount; i++ {
            let property : objc_property_t = poperites[i]
            let propertyName = NSString(UTF8String: property_getName(property))!
            if (parseObj.valueForKey(propertyName as String) != nil){
                let value: AnyObject = parseObj.valueForKey(propertyName as String)!
                
                
                if let stringobj = value as? NSString {
                    if stringobj.length > 0 {
                       urlString = urlString + (propertyName as String) + "=" + (stringobj as String) + "&"
                    }
                }
                else if let numberobj = value as? NSNumber {
                    urlString = urlString + (propertyName as String) as String + "=" + numberobj.stringValue + "&"
                }
                else if let arrobjs = value as? NSArray{
                    var arrayString = ""
                  
                    for arrobj in arrobjs {
                        if let arrvalue = arrobj as? NSString {
                            if arrvalue.length > 0 {
                                arrayString = arrayString + (arrvalue as String) + ","
                                //arrayString[i] = arrvalue
                                
                            }
                        }else if(getUrlString(arrobj).characters.count > 0){
                            arrayString += getUrlString(arrobj)
                            
                        }
                    }
                    
                    
                    if(arrayString.characters.count > 0){
                        arrayString = arrayString.substringToIndex(arrayString.endIndex.advancedBy(-1))
                    }
                    
                    urlString = urlString + (propertyName as String) as String + "=" + arrayString + "&"
                    
                }
                else if let customobj = value as? NSObject{ // must be custom object
                    let objString  = getUrlString(customobj)
                    if(objString.characters.count > 0){
                         urlString = urlString + (propertyName as String) as String + "=" + objString + "&"
                    }
                }

        }
            
    }
         urlString = urlString.substringToIndex(urlString.endIndex.advancedBy(-1))
        return urlString.stringByReplacingOccurrencesOfString("+", withString: "%2B", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
    }
    
    func swiftToJsonParser(parseObj : AnyObject) -> AnyObject{
        var outCount:UInt32 = 0;
        var dictionary  =  Dictionary<String, AnyObject>()
        let poperites: UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(object_getClass(parseObj), &outCount)
        let intCount = Int(outCount)
        for var i = 0; i < intCount; i++ {
            let property : objc_property_t = poperites[i]
            let propertyName = NSString(UTF8String: property_getName(property))!
            if (parseObj.valueForKey(propertyName as String) != nil){
                let value: AnyObject = parseObj.valueForKey(propertyName as String)!
                
                
                if let stringobj = value as? NSString {
                    if stringobj.length > 0 {
                        dictionary[propertyName as String] = stringobj.copy()
                    }
                }else if let numberobj = value as? NSNumber {
                    dictionary[propertyName as String] = numberobj.copy()
                }else if let arrobjs = value as? NSArray{
                    let arrayString : NSMutableArray = NSMutableArray()
                    var i = 0;
                    for arrobj in arrobjs {
                        if let arrvalue = arrobj as? NSString {
                            if arrvalue.length > 0 {
                                arrayString.addObject(arrvalue)
                                //arrayString[i] = arrvalue
                                i++
                            }
                        }else if(swiftToJsonParser(arrobj).count > 0){
                            arrayString[i] = swiftToJsonParser(arrobj)
                            i++
                        }
                    }
                    
                    
                    if(arrayString.count > 0){
                        dictionary[propertyName as String] = arrayString.copy()
                    }
                    
                    
                    
                }else if let customobj = value as? NSObject{ // must be custom object
                    let objString: (AnyObject) = swiftToJsonParser(customobj)
                    if(objString.count > 0){
                        dictionary[propertyName as String] = objString
                    }
                }
                
            }
            
        }
        free(poperites)
    
        return dictionary;
        
    }
}

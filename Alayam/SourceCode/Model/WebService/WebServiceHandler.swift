 //
 //  WebServiceHandler.swift
 //  Alayam
 //
 //  Created by Jeyaraj on 27/04/15.
 //  Copyright (c) 2015 hakuna. All rights reserved.
 //
 
 import UIKit
 import Alamofire
 
 class WebServiceHandler: NSObject {
    
    
    var loaderView : UIView!
    
    func getMethod(isLoaderNeed : Bool, url : String, header : [String : AnyObject]?, body : [String : AnyObject]?, Completion responseHandler : (NSDictionary!, NSError?) -> Void)
    {
        
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        if isLoaderNeed
        {
            addloader();
        }
        
        print("Request : \(body)")
        var configuration : NSURLSessionConfiguration?
        
        
        let nsurl = NSURL(string: appendDatewithURl(url))
        
        let request = (ParameterEncoding.URL.encode(NSURLRequest(URL: nsurl!), parameters: body).0).mutableCopy() as! NSMutableURLRequest
        
//        if let headerValue = header
//        {
//            
//            request.setValue(headerValue["authorization"] as? String, forHTTPHeaderField:"authorization")
//            
//        }
        
        Alamofire.Manager.sharedInstance.request(request).responseJSON() {
            (request,response, JSON, error) in
            
            self.removeLoader()
            
            #if DEBUG
                print(nsurl?.absoluteString)
                print("Response : \(JSON)")
            #endif
            if error == nil
            {
                if response?.statusCode == 200
                {
                    if let object = JSON as? NSDictionary {
                        
                        responseHandler(object , error)
                    }
                    
                }else if response?.statusCode == 404 { //bad token
                    
                    //responseHandler(nil, NSError(domain: "", code: response!.statusCode, userInfo: nil))
                }
                    
                else if response?.statusCode == 401 {//bad token
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("AUTHTOKENINVALIDNOTIFICATION", object: nil)
                    
                }
                else
                {
                    if let object = JSON as? NSDictionary {
                        
                        responseHandler(nil, nil)
                        
                        return
                    }
                    
                    responseHandler(nil, NSError(domain: "", code: response!.statusCode, userInfo: nil))
                }
            }
            else if response != nil
            {
                if response?.statusCode != 404 { //bad token
                    
                    responseHandler(nil, NSError(domain: "", code: response!.statusCode, userInfo: nil))
                }
                
                
            }
            else
            {
                let dict = NSDictionary(objects: ["Connection Time out!"], forKeys: [NSLocalizedDescriptionKey])
                
                responseHandler(nil, NSError(domain: "", code: 504, userInfo: dict as [NSObject : AnyObject]))
            }
        }
    }
    
    func postMethod(url : String, header : [String : AnyObject]?, body :  [String : AnyObject]?, Completion responseHandler : (NSDictionary!, NSError?) -> Void)
    {
        
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        addloader();
        print("Request : \(body)")
        
        let nsurl = NSURL(string:url)
        let request = NSMutableURLRequest(URL: nsurl!)
        
        
        
        if let headerValue = header
        {
            request.setValue(headerValue["authorization"] as? String, forHTTPHeaderField: "authorization")
        }
        
        request.HTTPMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        if let tempBody = body {
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(tempBody, options: NSJSONWritingOptions(rawValue: 0))
                request.HTTPBody = data
                #if DEBUG
                    print(nsurl?.absoluteString)
                    print(NSString(data: data, encoding: NSUTF8StringEncoding))
                #endif
            }catch {
                request.HTTPBody = nil
            }
        }
        
        
        Alamofire.Manager.sharedInstance.request(request).authenticate(user: "liad", password: "hm1234$").responseJSON() {
            
            (request,response, JSON, error) in
            
            self.removeLoader()
            
            #if DEBUG
                print("Response : \(JSON)")
            #endif
            if error == nil
            {
                if response?.statusCode == 200
                {
                    if let object = JSON as? NSDictionary {
                        
                        responseHandler(object , error)
                    }
                }
                else if response?.statusCode == 404 { //bad token
                    
                    //  NSNotificationCenter.defaultCenter().postNotificationName("AUTHTOKENINVALIDNOTIFICATION", object: nil)
                    
                }
                else if response?.statusCode == 401 { //bad token
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("AUTHTOKENINVALIDNOTIFICATION", object: nil)
                    
                }
                else
                {
                    if let object = JSON as? NSDictionary {
                        
                        responseHandler(nil, nil)
                        
                        return
                    }
                    
                    responseHandler(nil, NSError(domain: "", code: response!.statusCode, userInfo: nil))
                }
            }
            else if response != nil
            {
                if response != nil
                {
                    if response?.statusCode != 404 { //bad token
                        
                        responseHandler(nil, NSError(domain: "", code: response!.statusCode, userInfo: nil))
                    }
                    
                    
                }
            }
            else
            {
                let dict = NSDictionary(objects: ["Connection Time out!"], forKeys: [NSLocalizedDescriptionKey])
                
                responseHandler(nil, NSError(domain: "", code: 504, userInfo: dict as [NSObject : AnyObject]))
            }
        }
        
    }
    
//    func putMethod(url : String, header : [String : AnyObject]?, body :  [String : AnyObject]?, Completion responseHandler : (NSDictionary!, NSError?) -> Void)
//    {
//        
//        NSURLCache.sharedURLCache().removeAllCachedResponses()
//        addloader();
//        print("Request : \(body)")
//        
//        var configuration : NSURLSessionConfiguration?
//        var nsurl = NSURL(string: appendDatewithURl(url))
//        let request = NSMutableURLRequest(URL: nsurl!)
//        request.HTTPMethod = "PUT"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        if let headerValue = header
//        {
//            request.setValue(header?["authorization"] as? String, forHTTPHeaderField: "authorization")
//            //             Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = header
//            //            var headers = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
//            //            headers["authorization"] = header?["authorization"] as! NSString
//            //
//            //            configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//            //            configuration?.HTTPAdditionalHeaders = headers
//            
//        }
//        
//        
//        
//        var error: NSError?
//        if body != nil {
//            do {
//                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(body!, options: [])
//            } catch var error1 as NSError {
//                error = error1
//                request.HTTPBody = nil
//            }
//        }
//        
//        Alamofire.upload(.POST, URLString: "", data: NSData())
//        
//        Alamofire.Manager.sharedInstance.request(request).responseJSON() {
//            // Alamofire.Manager(configuration: configuration).request(request).responseJSON() {
//            
//            (request,response, JSON, error) in
//            self.removeLoader()
//            print("Response : \(JSON)")
//            
//            
//            if error == nil
//            {
//                if response?.statusCode == 200
//                {
//                    if let object = JSON as? NSDictionary {
//                        print(object)
//                        
//                        responseHandler(object , error)
//                    }
//                    
//                }else if response?.statusCode == 535 {//bad token
//                    NSNotificationCenter.defaultCenter().postNotificationName("AUTHTOKENINVALIDNOTIFICATION", object: nil)
//                }
//                else
//                {
//                    responseHandler(nil, NSError(domain: "", code: response!.statusCode, userInfo: nil))
//                }
//            }else
//            {
//                responseHandler(nil,error)
//            }
//        }
//    }
//    
//    func deleteMethod(url : String, header : [String : AnyObject]?, body :  [String : AnyObject]?, Completion responseHandler : (NSDictionary!, NSError?) -> Void)
//        
//    {
//        
//        NSURLCache.sharedURLCache().removeAllCachedResponses()
//        addloader();
//        print("Request : \(body)")
//        
//        var configuration : NSURLSessionConfiguration?
//        var nsurl = NSURL(string: appendDatewithURl(url))
//        let request = NSMutableURLRequest(URL: nsurl!)
//        request.HTTPMethod = "DELETE"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        if let headerValue = header
//        {
//            request.setValue(header?["authorization"] as? String, forHTTPHeaderField: "authorization")
//            
//            //            var headers = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
//            //            headers["authorization"] = header?["authorization"] as! NSString
//            //
//            //            configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//            //            configuration?.HTTPAdditionalHeaders = headers
//            //             Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = header
//        }
//        var error: NSError?
//        if body != nil {
//            do {
//                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(body!, options: [])
//            } catch var error1 as NSError {
//                error = error1
//                request.HTTPBody = nil
//            }
//        }
//        
//        Alamofire.Manager.sharedInstance.request(request).responseJSON() {
//            // Alamofire.Manager(configuration: configuration).request(.DELETE, url, parameters: body).responseJSON() {
//            (request,response, JSON, error) in
//            self.removeLoader()
//            print("Response : \(JSON)")
//            if error == nil
//            {
//                
//                if response?.statusCode == 200
//                {
//                    if let object = JSON as? NSDictionary {
//                        print(object)
//                        
//                        responseHandler(object , error)
//                    }
//                    
//                }else if response?.statusCode == 535 {//bad token
//                    NSNotificationCenter.defaultCenter().postNotificationName("AUTHTOKENINVALIDNOTIFICATION", object: nil)
//                }
//                else
//                {
//                    responseHandler(nil, NSError(domain: "", code: response!.statusCode, userInfo: nil))
//                }
//            }else
//            {
//                responseHandler(nil,error)
//            }
//        }
//    }
    
    
    
    func UploadWithAlamofire(url : String, image : UIImage?, header :  [String : AnyObject]?, filename : String, mimeType : String,  Completion responseHandler : (NSDictionary!, NSError?) -> Void!)
    {
        
        // Set Content-Type in HTTP header
        let boundaryConstant = "Boundary-7MA4YWxkTLLu0UIW";
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        let accessTokenHeader = ""
        
        var fileData : NSData =  UIImagePNGRepresentation(image!)!
        //        if let fileContents = NSFileManager.defaultManager().contentsAtPath(filePath.path!) {
        //            fileData = fileContents
        //        }
        
        let fileName = "test1.png"
        let mimeType = "image/png"
        let fieldName = "file" // key set from the server
        
        var request1 : URLRequestConvertible = Router(filename: fileName, fieldname: fieldName, mimeType: mimeType, fileContent: fileData, boundaryConstant: boundaryConstant, url: url)
        
        //        var headers = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        //        headers["authorization"] = header?["authorization"] as! String
        //
        //        var configuration : NSURLSessionConfiguration?
        //        configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        //        configuration?.HTTPAdditionalHeaders = headers
        //        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = header
        var request2 : NSMutableURLRequest = request1.URLRequest.mutableCopy() as! NSMutableURLRequest
        request2.setValue(header?["authorization"] as? String, forHTTPHeaderField: "authorization")
        
        
        Alamofire.Manager.sharedInstance.request(request2).responseJSON() {
            //  Alamofire.Manager(configuration: configuration).request(request1.URLRequest).responseJSON {
            (request, response, JSON, error) in
            
            print("Response : \(JSON)")
            
            if error == nil
            {
                
                if response?.statusCode == 200
                {
                    if let object = JSON as? NSDictionary {
                        
                        
                        responseHandler(object , error)
                    }
                    
                }else
                {
                    responseHandler(nil, NSError(domain: "", code: response!.statusCode, userInfo: nil))
                }
            }else
            {
                responseHandler(nil,error)
            }
            
        }
    }
    
    
    
    
    func addloader()
    {
        
//        removeLoader()
        
        if loaderView != nil
        {
            loaderView.removeFromSuperview()
        }
        else
        {
            loaderView = UIView(frame: UIApplication.sharedApplication().keyWindow!.bounds)
//            loaderView = UIApplication.sharedApplication().keyWindow?.subviews.last as! UIView
            loaderView.backgroundColor = UIColor.clearColor()
            
            var arrayofimages = [UIImage]()
            
            for (var k = 1; k<=42 ; k++)
            {
                arrayofimages.append(UIImage(named: "tmp-\(k).png")!)
            }
            
            let uiimage = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSizeMake(60, 60)))
            uiimage.image = UIImage(named: "Loader")!
            uiimage.animationImages = arrayofimages
            uiimage.animationDuration = 4
            uiimage.center = loaderView.center
            loaderView.addSubview(uiimage)
            
            uiimage.startAnimating()
//            CodeSnippets.rotateLayer(uiimage.layer)
        }
        
        UIApplication.sharedApplication().keyWindow?.addSubview(loaderView)
        
    }
    
    func removeLoader()
    {
//        SwiftLoader.hide()
        
        if loaderView != nil
        {
            loaderView.removeFromSuperview()
        }
    }
    
    
    func appendDatewithURl(url : String) -> String{
        
        let datestring = "1234" //CodeSnippets.getStringFromLocaleNSDate(NSDate(), dateFormatString: "yyyy,MM,dd,HH,mm,ss")
        
        if (url.rangeOfString("?", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil) {
            return "\(url)&dateAlayam=\(datestring)"
        }
        return "\(url)?dateAlayam=\(datestring)"
    }
    
 }

 
 
 extension WebServiceHandler
 {
    func addCircleLayer(frame : CGRect) -> CAShapeLayer
    {
        let radius : CGFloat = 100.0
        
        // Create the circle layer
        let circle = CAShapeLayer()
        
        // Set the center of the circle to be the center of the view
        let center = CGPointMake(CGRectGetMidX(frame) - radius, CGRectGetMidY(frame) - radius)
        
        let fractionOfCircle = 3.0 / 4.0
        
        let twoPi = 2.0 * Double(M_PI)
        // The starting angle is given by the fraction of the circle that the point is at, divided by 2 * Pi and less
        // We subtract M_PI_2 to rotate the circle 90 degrees to make it more intuitive (i.e. like a clock face with zero at the top, 1/4 at RHS, 1/2 at bottom, etc.)
        let startAngle = Double(fractionOfCircle) / Double(twoPi) - Double(M_PI_2)
        let endAngle = 0.0 - Double(M_PI_2)
        let clockwise: Bool = true
        
        // `clockwise` tells the circle whether to animate in a clockwise or anti clockwise direction
        circle.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).CGPath
        
        // Configure the circle
        circle.fillColor = UIColor.blackColor().CGColor
        circle.strokeColor = UIColor.redColor().CGColor
        circle.lineWidth = 5
        
        // When it gets to the end of its animation, leave it at 0% stroke filled
        circle.strokeEnd = 0.0
        
        // Add the circle to the parent layer
        return circle
        
//        // Configure the animation
//        var drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        drawAnimation.repeatCount = 1.0
//        
//        // Animate from the full stroke being drawn to none of the stroke being drawn
//        drawAnimation.fromValue = NSNumber(double: fractionOfCircle)
//        drawAnimation.toValue = NSNumber(float: 0.0)
//        
//        drawAnimation.duration = 30.0
//        
//        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        
//        // Add the animation to the circle
//        circle.addAnimation(drawAnimation, forKey: "drawCircleAnimation")
    }
 }
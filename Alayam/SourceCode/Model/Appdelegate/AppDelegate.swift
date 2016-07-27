//
//  AppDelegate.swift
//  Alayam
//
//  Created by Mala on 7/16/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn

import FBSDKCoreKit

import FBSDKLoginKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    var centerContainer: MMDrawerController?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize a tracker using a Google Analytics property ID.
        // Configure tracker from GoogleService-Info.plist.
        
        var rootViewController = self.window?.rootViewController
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        
        let hotNewsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("BreakingNewsViewController") as! BreakingNewsViewController
        
        let menuViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        
        let NewsDetailsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeDetailViewControllerID") as! HomeDetailViewController
        
        
        let menuSideNav = UINavigationController(rootViewController: menuViewController)
        let homeNav = UINavigationController(rootViewController: homeViewController)
        let HotNav = UINavigationController(rootViewController: hotNewsViewController)
        var newsDetails = UINavigationController(rootViewController: NewsDetailsViewController)
        
        
        if let options = launchOptions {
            //notification found mean that you app is opened from notification
            if let notification = options[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
                
                //                var MainNewsID: NSString = notification.objectForKey("NewsMainID") as! NSString
                
                //                NewsDetailsViewController.isFromNotification = true
                //                NewsDetailsViewController.MainNewsID = MainNewsID
                self.centerContainer = MMDrawerController(centerViewController: HotNav, rightDrawerViewController: menuSideNav)
                
            }else{
                centerContainer = MMDrawerController(centerViewController: homeNav, rightDrawerViewController: menuSideNav)
            }
        }else{
            centerContainer = MMDrawerController(centerViewController: homeNav, rightDrawerViewController: menuSideNav)
        }
        
        
        // centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: leftSideNav, rightDrawerViewController: rightSideNav)
        
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView;
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.All
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GIDSignIn.sharedInstance().clientID = "497825064621-q92oask59dgtguj42au5gog105g6t7ot.apps.googleusercontent.com"
        
        
        //        var configureError: NSError?
        //        GGLContext.sharedInstance().configureWithError(&configureError)
        //        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
        //UA-27381894-1
        // UA-27381894-2
        
        // Optional: configure GAI options.
        let gai2 = GAI.sharedInstance()
        gai2.trackerWithTrackingId("UA-27381894-2")
        gai2.trackUncaughtExceptions = true  // report uncaught exceptions
        gai2.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        
        let type: UIUserNotificationType = [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound];
        let setting = UIUserNotificationSettings(forTypes: type, categories: nil);
        UIApplication.sharedApplication().registerUserNotificationSettings(setting);
        UIApplication.sharedApplication().registerForRemoteNotifications();
        
        var oneSignal : OneSignal!
        //        oneSignal.registerForPushNotifications()
        _ = OneSignal(launchOptions: launchOptions, appId: "b1041082-084d-4adb-97c3-26c6429f226b") { (message, additionalData, isActive) in
            NSLog("OneSignal Notification opened:\nMessage: %@", message)
            
            if additionalData != nil {
                NSLog("additionalData: %@", additionalData)
                var MainNewsID: NSString!
                if let id = additionalData["NewsMainID"] as! String? {
                    MainNewsID = id as NSString
                    print("MainNewsID : \(MainNewsID)", terminator: "")
                }
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let NewsDetailsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeDetailViewControllerID") as! HomeDetailViewController
                
                let newsDetails = UINavigationController(rootViewController: NewsDetailsViewController)
                
                NewsDetailsViewController.isFromNotification = true
                NewsDetailsViewController.MainNewsID = MainNewsID
//                self.centerContainer = MMDrawerController(centerViewController: newsDetails, rightDrawerViewController: menuSideNav)
//                // centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: leftSideNav, rightDrawerViewController: rightSideNav)
//                
//                self.centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView;
//                self.centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.All
                
                let current = self.getCurrentViewController()
                
                if isActive == false{
                    
//                    self.window!.rootViewController = self.centerContainer
//                    self.window!.makeKeyAndVisible()
                    
                }else {
                    let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "اقرأ", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        
                        self.centerContainer?.centerViewController.navigationController?.pushViewController(NewsDetailsViewController, animated: true)
                        
//                        self.window!.rootViewController = self.centerContainer
//                        self.window!.makeKeyAndVisible()
                        
                    }
                    let cancelAction = UIAlertAction(title: "في وقت لاحق", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        NSLog("Cancel Pressed")
                    }
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    current!.presentViewController(alertController, animated: true, completion: nil)
                }
                
                
                // Check for and read any custom values you added to the notification
                // This done with the "Additonal Data" section the dashbaord.
                // OR setting the 'data' field on our REST API.
                if let customKey = additionalData["customKey"] as! String? {
                    NSLog("customKey: %@", customKey)
                }
            }
        }
        
        window!.rootViewController = centerContainer
        window!.makeKeyAndVisible()
        return true
        
    }
    
    
    func application(application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //send this device token to server
        print(deviceToken)
        
        //        WebServiceHandler().postMethod("http://mobile.alayam.com/api/PushNotification?", header: nil, body: ["DeviceType" : "iOS", "Imei" : "", "TokenID" : deviceToken]) { (dict, error) -> Void in
        //            if dict != nil
        //            {
        //                print(dict)
        //            }
        //        }
        
    }
    
    //Called if unable to register for APNS.
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        print(error)
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        print("Recived: \(userInfo)")
        
        //Parsing userinfo:
        var temp : NSDictionary = userInfo
        var MainNewsID : NSString!
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
        {
            MainNewsID = info["NewsMainID"] as! NSString
            let alertMsg = info["alert"] as! String
            //            var alert: UIAlertView!
            //            alert = UIAlertView(title: "", message: alertMsg, delegate: nil, cancelButtonTitle: "OK")
            //            alert.show()
            var rootViewController = self.window?.rootViewController
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let homeViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
            
            let hotNewsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("BreakingNewsViewController") as! BreakingNewsViewController
            
            let menuViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
            
            let NewsDetailsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeDetailViewControllerID") as! HomeDetailViewController
            
            let menuSideNav = UINavigationController(rootViewController: menuViewController)
            var homeNav = UINavigationController(rootViewController: homeViewController)
            var HotNav = UINavigationController(rootViewController: hotNewsViewController)
            let newsDetails = UINavigationController(rootViewController: NewsDetailsViewController)
            
            NewsDetailsViewController.isFromNotification = true
            NewsDetailsViewController.MainNewsID = MainNewsID
            
            
            let alertController = UIAlertController(title: "", message: alertMsg, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "اقرأ", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
                self.centerContainer?.centerViewController.navigationController?.pushViewController(NewsDetailsViewController, animated: true)
                
            }
            let cancelAction = UIAlertAction(title: "في وقت لاحق", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            
            alertController.addAction(okAction)
            
            alertController.addAction(cancelAction)
            
            getCurrentViewController()!.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        var success : Bool!
        
        //Facebook
        //ios 8
        
        if #available(iOS 9.0, *) {
            var options: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!,
                                                UIApplicationOpenURLOptionsAnnotationKey: annotation]
        } else {
            // Fallback on earlier versions
        }
        
        if url.scheme == "fb1299298546747296" {
            
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        if #available(iOS 9.0, *) {
            
            if url.scheme == "fb1299298546747296" {
                
                return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String, annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
            }
            
            return GIDSignIn.sharedInstance().handleURL(url,
                                                        sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                        annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
        } else {
            // Fallback on earlier versions
        }
        
        return false
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.hakuna.LIAD" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("CacheModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Alayam.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    // NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
    func Loadwebview(view : UIView, target : UIWebViewDelegate){
        let webV:UIWebView = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        webV.loadRequest(NSURLRequest(URL: NSURL(string: "http://mobile.alayam.com/AnalyticsTracker.html")!))
        webV.delegate = target;
        webV.hidden = true
        view.addSubview(webV)
    }
    
    // Returns the most recently presented UIViewController (visible)
    func getCurrentViewController() -> UIViewController? {
        
        // Otherwise, we must get the root UIViewController and iterate through presented views
        if let rootController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            
            var currentController: UIViewController! = rootController
            
            // Each ViewController keeps track of the view it has presented, so we
            // can move from the head to the tail, which will always be the current view
            while( currentController.presentedViewController != nil ) {
                
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return self.window?.rootViewController
    }
    
    
}


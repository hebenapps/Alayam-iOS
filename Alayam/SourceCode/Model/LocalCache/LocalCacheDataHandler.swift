//
//  LocalCacheDataHandler.swift
//  Alayam
//
//  Created by Jeyaraj on 08/09/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit
import CoreData

class LocalCacheDataHandler: NSObject {
    
    
    
    func updateLoginUserData(authToken: String) {
        
        NSUserDefaults.standardUserDefaults().setValue(authToken, forKey: "loginDetails")
        
    }
    
    func getUserLoginDetails() -> String {
        
        if let login = NSUserDefaults.standardUserDefaults().objectForKey("loginDetails") as? String {
            return login
        }
        
        return ""
        
    }
    
    func updateLoginUserName(userName: String) {
        
        NSUserDefaults.standardUserDefaults().setValue(userName, forKey: "loginDetailsName")
        
    }
    
    func getUserLoginUserName() -> String {
        
        if let login = NSUserDefaults.standardUserDefaults().objectForKey("loginDetailsName") as? String {
            return login
        }
        
        return ""
        
    }
    
    
    func removeDataforNewsCategory(newsCategory : NewsCategory)
    {
        
    }
    
    func getCachedData(category : String) -> NSMutableArray {
        let request : NSFetchRequest = NSFetchRequest(entityName: "NewsEntity")
        
        let resultPredicate = NSPredicate(format: "newsCategory = %@",  category)
                request.predicate = resultPredicate
        request.returnsObjectsAsFaults = false
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let results:NSArray = try! context.executeFetchRequest(request)
        
        let listObjectsArray = NSMutableArray()
        
        for (var i = 0; i < results.count ;i++)
        {
            listObjectsArray.addObject((results.objectAtIndex(i) as! NewsEntity).categoryNewsDTO)
        }
        
        //if results.count > 0 {
        return listObjectsArray
        // }
        
    }
    
    func saveNewData(category : String, arrayOfData : NSArray)
    {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        let request : NSFetchRequest = NSFetchRequest(entityName: "NewsEntity")
        
        let resultPredicate = NSPredicate(format: "newsCategory = %@",  category)
        request.predicate = resultPredicate
        request.returnsObjectsAsFaults = false
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let results:NSArray = try! context.executeFetchRequest(request)
        
        
        
        managedObjectContext.performBlock {
            
            autoreleasepool {
                
                let array: Array<SliderNewsDTO>? = arrayOfData as? Array<SliderNewsDTO>
                
                for item in array! {
                    
                    let resultPredicate2 = NSPredicate(format: "newsMainID = %@",  item.NewsMainID)
                    
                    let hasValues = results.filteredArrayUsingPredicate(resultPredicate2)
                    
                    if hasValues.count == 0
                    {
                    
                    let newEntityObject = NSEntityDescription.insertNewObjectForEntityForName("NewsEntity", inManagedObjectContext: managedObjectContext) as! NewsEntity
                    newEntityObject.contentType     = item.ContentType
                    newEntityObject.nEWSTIME        = item.NEWSTIME
                    newEntityObject.newsTitle       = item.NewsTitle
                    newEntityObject.newsSubTitle    = item.NewsSubTitle
                    newEntityObject.newsSummary     = item.NewsSummary
                    newEntityObject.newsDetails     = item.NewsDetails
                    newEntityObject.newsDate        = item.NewsDate
                    newEntityObject.imageURL_S      = item.ImageURL_S
                    newEntityObject.imageURL        = item.ImageURL
                    newEntityObject.nEWSURL         = item.NEWSURL
                    newEntityObject.newsMainID      = item.NewsMainID
                    newEntityObject.newsCategory    = category
                    }
                }
            }

            do {
                try managedObjectContext.save()
            } catch _ {
            }
            
            managedObjectContext.reset()
            //            }
        }
    }
    
    func isAlreadyInReadersList(readerDetails : SliderNewsDTO) -> Bool
    {
        let request : NSFetchRequest = NSFetchRequest(entityName: "ReadersEntity")
        
        let resultPredicate = NSPredicate(format: "newsMainID = %@",  readerDetails.NewsMainID)
        request.predicate = resultPredicate
        request.returnsObjectsAsFaults = false
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0
        {
            return true
        }
        
        return false
    }
    
    func addNewReaderList(readerDetails : SliderNewsDTO)
    {
        
        let request : NSFetchRequest = NSFetchRequest(entityName: "ReadersEntity")
        
        let resultPredicate = NSPredicate(format: "newsMainID = %@",  readerDetails.NewsMainID)
        request.predicate = resultPredicate
        request.returnsObjectsAsFaults = false
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let results:NSArray = try! context.executeFetchRequest(request)

        if results.count > 0
        {
            context.deleteObject(results.objectAtIndex(0) as! NSManagedObject)
            
            do {
                try context.save()
            } catch _ {
            }
            
            context.reset()
            
//            UIAlertView(title: "Already in readers list", message: "", delegate: nil, cancelButtonTitle: "Ok").show()
            return
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
//        managedObjectContext.performBlock {
//            
//            autoreleasepool {
//                
                let newEntityObject = NSEntityDescription.insertNewObjectForEntityForName("ReadersEntity", inManagedObjectContext: managedObjectContext) as! ReadersEntity
                newEntityObject.contentType     = readerDetails.ContentType
                newEntityObject.nEWSTIME        = readerDetails.NEWSTIME
                newEntityObject.newsTitle       = readerDetails.NewsTitle
                newEntityObject.newsSubTitle    = readerDetails.NewsSubTitle
                newEntityObject.newsSummary     = readerDetails.NewsSummary
                newEntityObject.newsDetails     = readerDetails.NewsDetails
                newEntityObject.newsDate        = readerDetails.NewsDate
                newEntityObject.imageURL_S      = readerDetails.ImageURL_S
                newEntityObject.imageURL        = readerDetails.ImageURL
                newEntityObject.nEWSURL         = readerDetails.NEWSURL
                newEntityObject.newsMainID      = readerDetails.NewsMainID
                do {
                    //            }
            //        }
        
                    try managedObjectContext.save()
                } catch _ {
                }
        
        managedObjectContext.reset()
        
        UIAlertView(title: "Successfully added to readers list..!!!", message: "", delegate: nil, cancelButtonTitle: "Ok").show()
        
    }
    
    
    func getMenuList(menuId : NSNumber) -> NSArray
    {
        let request : NSFetchRequest = NSFetchRequest(entityName: "MenuEntity")
        
        let resultPredicate = NSPredicate(format: "menuType = %@",  menuId)
        request.predicate = resultPredicate
        
        request.returnsObjectsAsFaults = false
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let results:NSArray = try! context.executeFetchRequest(request)
        
        
        let resultsInSwift = NSMutableArray()
    
        for object in results
        {
            resultsInSwift.addObject((object as! MenuEntity).alayamMenuDTO)
        }
        
        return resultsInSwift
    }
    
    func addToMenuList(menulist : NSArray)
    {
        
        let request : NSFetchRequest = NSFetchRequest(entityName: "MenuEntity")
        
        request.returnsObjectsAsFaults = false
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let results:NSArray = try! context.executeFetchRequest(request)
        
//        for (var j = 0; j < results.count; j++)
//        {
//           context.deleteObject(results.objectAtIndex(j) as! NSManagedObject)
//        }
        
        for item in results {
            
            context.deleteObject(item as! NSManagedObject)
            
        }
        
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        //        managedObjectContext.performBlock {
        //
        //            autoreleasepool {
        
        for (var k = 0; k < menulist.count; k++)
        {
            let menuDetails = menulist.objectAtIndex(k) as! AlayamMenuDTO
            //
            let newEntityObject = NSEntityDescription.insertNewObjectForEntityForName("MenuEntity", inManagedObjectContext: managedObjectContext) as! MenuEntity
            newEntityObject.contentSectionID = menuDetails.ContentSectionID
            newEntityObject.contentTypeID = menuDetails.ContentTypeID
            newEntityObject.arabicName = menuDetails.ArabicName
            newEntityObject.englishName = menuDetails.EnglishName
            newEntityObject.mobileIcon = menuDetails.MobileIcon
            newEntityObject.menuType = menuDetails.MenuType
            //            }
        }
        
        do {
            try managedObjectContext.save()
        } catch _ {
        }
        
        managedObjectContext.reset()
        
    }

    
    func fetchReadersList(category : String) -> NSMutableArray?{
        
        let request : NSFetchRequest = NSFetchRequest(entityName: "ReadersEntity")
        
        request.returnsObjectsAsFaults = false
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let results:NSArray = try! context.executeFetchRequest(request)

        
        //if results.count > 0 {
        return results.mutableCopy() as? NSMutableArray //as? [ReadersEntity] //[0] as? NewsEntity
        // }
        
    }
    
    func addToReadNewsForCache(newsId : String)
    {
        
        let request : NSFetchRequest = NSFetchRequest(entityName: "ReadNews")
        
        let resultPredicate = NSPredicate(format: "id = %@",  newsId)
        request.predicate = resultPredicate
        
        request.returnsObjectsAsFaults = false
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0
        {
            return
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator // or wherever your coordinator is
        
        //        managedObjectContext.performBlock {
        //
        //            autoreleasepool {
        //
        let newEntityObject = NSEntityDescription.insertNewObjectForEntityForName("ReadNews", inManagedObjectContext: managedObjectContext) as! ReadNews
        newEntityObject.id = newsId
        do {
            //            }
            //        }
        
            try managedObjectContext.save()
        } catch _ {
        }
        
        managedObjectContext.reset()
        
    }
    
    func fetchAllReadedNews() -> NSMutableArray{
        
        let request : NSFetchRequest = NSFetchRequest(entityName: "ReadNews")
        
        request.returnsObjectsAsFaults = false
        let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        let results:NSArray = try! context.executeFetchRequest(request)
        
        let ids = NSMutableArray()
        
        for (var i = 0; i < results.count; i++)
        {
            let result = results.objectAtIndex(i) as! ReadNews
            ids.addObject(result.id)
        }
        
        //if results.count > 0 {
        return ids //as? [ReadersEntity] //[0] as? NewsEntity
        // }
        
    }

    
    static func removeImage(directoryName:String) {
        var fileManager:NSFileManager = NSFileManager.defaultManager()
        var image:UIImage!
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    var filePath = NSString(format:"%@/%@", dirPath, directoryName) as String
                    var error:NSErrorPointer = NSErrorPointer()
                    do {
                        try fileManager.removeItemAtPath(filePath)
                    } catch var error1 as NSError {
//                        error.memory = error1
                    }
                    if error != nil {
                        print(error.debugDescription)
                    }
                }
            }
    }
    
    func saveImageToLocal(imageData : UIImage, directoryName : String,imageName : String)
    {
        var error: NSError?
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent(directoryName)
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath)) {
            do {
                try NSFileManager.defaultManager() .createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
            } catch var error1 as NSError {
                error = error1
            }
        }
        
        let writePath = (dataPath as NSString).stringByAppendingPathComponent("\(imageName).png")

        var data = UIImagePNGRepresentation(imageData);
        data!.writeToFile(writePath, atomically: true)
    }
    
    
}


extension UIImageView
{
    func loadImageFromPath(directoryName : String,imageName : String) {
        
        dispatch_async(dispatch_get_main_queue(), {
            let fileManager = NSFileManager.defaultManager()
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
            let getImagePath = (paths as NSString).stringByAppendingPathComponent("\(directoryName)/\(imageName).png")
            
            
            
            if (fileManager.fileExistsAtPath(getImagePath))
            {
                print("FILE AVAILABLE AT \(paths)");
                
                //Pick Image and Use accordingly
                let imageis: UIImage = UIImage(contentsOfFile: getImagePath)!
                
                let data: NSData = UIImagePNGRepresentation(imageis)!
                
                self.image = UIImage(data: data)
                self.contentMode = UIViewContentMode.ScaleAspectFit
                
            }
            else
            {
                print("FILE NOT AVAILABLE");
                
            }
            
        });
        
    }
    

}






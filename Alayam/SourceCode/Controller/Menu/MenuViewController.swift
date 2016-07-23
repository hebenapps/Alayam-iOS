//
//  MenuViewController.swift
//  Alayam
//
//  Created by Mala on 7/17/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit
import MessageUI

class MenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var searchBarView: UISearchBar!
    @IBOutlet weak var tblMenu: UITableView!
    var tag : Int!
    var isSearchEnabled = false
    
    var searchArray = NSMutableArray()
    
//    var aryMenuItems:[String] = ["الصفحة الرئيسية","الأخبار العاجلة","محليات","الأيام الإقتصادي","الأيام رياضي","منوعات","إخبارية","أخبار الجريدة الورقية","راديو وتلفزيون","فوتوغرافيا","شارك تطبيق الأيام","أرسل خبر","الأيام تاغز","قارئ QR","قائمة القراءة","الصفحات الكاملة","الإعدادات","طقس"];

//    var aryMenuItems : [String] =  ["الصفحة الرئيسية","الأخبار العاجلة","الأيام نت","أخبار الجريدة الورقية","كتاب الأيام","راديو وتلفزيون","فوتوغرافيا","شارك تطبيق الأيام","أرسل خبر","الأيام تاغز","الأيام تاغز","قائمة القراءة","الكيو آر","الصفحات الكاملة","الاعدادات"]
    
//    var aryMenuItems:[String] = ["الصفحة الرئيسية","الأيام نت","أخبار الجريدة الورقية","كتاب الأيام","راديو وتلفزيون","فوتوغرافيا","شارك تطبيق الأيام","أرسل خبر","الأيام تاغز","قائمة القراءة","الكيو آر","الصفحات الكاملة","الاعدادات"]


//    var aryMenuItems : [String] = ["الصفحة الرئيسية","الأخبار العاجلة","الأيام نت","أخبار الجريدة الورقية","كتاب الأيام","راديو وتلفزيون","فوتوغرافيا","شارك تطبيق الأيام","رأيك يهمن","الأيام تاجز" ,"قائمة القراءة","الكيو آر","الصفحات الكاملة","الاعدادات"]
    
    var aryMenuItems : [String] = ["الصفحة الرئيسية","الأخبار العاجلة","الأيام نت","أخبار الجريدة الورقية","كتاب الأيام","راديو وتلفزيون","فوتوغرافيا","شارك تطبيق الأيام","رأيك يهمنا","الأيام تاجز" ,"قائمة القراءة","الكيو آر","الصفحات الكاملة","الاعدادات"]
    
//    var aryMenuImages:[String] = ["home","latest_news","local_news","economic_news","sports_news","variety_news","international_news","news_paper_printed","radio_tv","photography","share","send_news","tags","qr_reader","reader_list","pdf","setting","weather_b"]
    
    var aryMenuImages:[String] = ["home","latest_news","international_news","news_paper_printed","edit","radio_tv","photography","share","send_news","tags","reader_list","qr_reader","pdf","setting"]
    
    var aryAlayamSubmenus = NSMutableArray()
    var aryOnlineSbumenus = NSMutableArray()
    var aryArticlesList   = NSMutableArray()
    var readNewsIds = NSMutableArray()
    var sectionHeader = NSMutableArray()
    
    var tableViewAlayamSubMenus = NSMutableArray()
    var tableViewOnlineSubMenus = NSMutableArray()
    var tableViewArticleSubMenus = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        readNewsIds = LocalCacheDataHandler().fetchAllReadedNews()
        self.navigationController?.navigationBarHidden = true
        
        self.edgesForExtendedLayout = UIRectEdge.None
//        HomeFeedDataHandler().getMenuItems(true, queryParameter: nil, parameter: nil, Completion: { (response) -> Void! in
//            return Void()
//        }) { (error) -> Void in
//            
//        }
        
        // Do any additional setup after loading the view.
        
        for (var k = 0; k < aryMenuItems.count; k++)
        {
        
        let headerView = UIView(frame: CGRectMake(-40, 0, tblMenu.frame.size.width - 40, 45))
        headerView.backgroundColor = UIColor.whiteColor()
        headerView.tag = k
        
        //        var myCustomView = UIImageView (frame: CGRectMake(headerView.frame.width - 45, 10, 25, 25))
        //
        //        var myImage: UIImage = UIImage(named: aryMenuImages[section])!
        //        myCustomView.image = myImage
        //
        //        headerView.addSubview(myCustomView)
        let mycell = tblMenu.dequeueReusableCellWithIdentifier("MyMenuCell") as! MenuItemViewCell
        
        mycell.frame = headerView.bounds
        
        mycell.backgroundColor = UIColor.clearColor()
        
        mycell.lblMenuName.text = aryMenuItems[k]
        mycell.imgMenuImage.image = UIImage(named: aryMenuImages[k])
            
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
            mycell.lblMenuName.font = UIFont (name: mycell.lblMenuName.font.fontName, size:20)
        }
            
        headerView.addSubview(mycell)
        
        let headerTapped = UITapGestureRecognizer (target: self, action:"sectionHeaderTapped:")
        headerView .addGestureRecognizer(headerTapped)
        
        
        let separator = UIView(frame: CGRectMake(0, 44, tblMenu.frame.size.width - 40, 1))
        separator.backgroundColor = UIColor.lightGrayColor()
        headerView.addSubview(separator)
        
        sectionHeader.addObject(headerView)

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.tblMenu.reloadData()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBarView.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isSearchEnabled
        {
            return
        }
        
        HomeFeedDataHandler().getMenuItems(true, queryParameter: nil, parameter: nil, Completion: { (response) -> Void! in
            
            self.aryAlayamSubmenus = response.Data.OnlineMenu
            self.aryOnlineSbumenus = response.Data.AlayamMenu
            self.aryArticlesList = response.Data.ArticleMenu
            
            
            
            return Void()
            }) { (error) -> Void in
                
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if isSearchEnabled
        {
            return 1
        }
        
        return aryMenuItems.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isSearchEnabled
        {
            return searchArray.count
        }
        
        if section == 2
        {
            return tableViewAlayamSubMenus.count
        }
        
        if section == 3
        {
            return tableViewOnlineSubMenus.count
        }
        
        if section == 4
        {
            return tableViewArticleSubMenus.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if isSearchEnabled
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("HomeRegularNewsTableViewCellID", forIndexPath: indexPath) as! HomeRegularNewsTableViewCell
            let news = searchArray.objectAtIndex(indexPath.row) as! SliderNewsDTO
            
            if readNewsIds.containsObject("\(news.NewsMainID)")
            {
                cell.setusAlreadySelectedNews()
            }
            else
            {
                cell.setusUnSelectedNews()
            }
            
            cell.configureWithData(news)
            
            //        if indexPath.row == 0
            //        {
            //            lblNewsDate.text = news.NewsDate
            //        }
            
//            if readNewsIds.containsObject("\(news.NewsMainID)")
//            {
//                cell.setusAlreadySelectedNews()
//            }
//            else
//            {
//                cell.setusUnSelectedNews()
//            }
            return cell
        }
        
        let mycell = tableView.dequeueReusableCellWithIdentifier("MyMenuCell", forIndexPath: indexPath) as! MenuItemViewCell
        
        if indexPath.section == 2
        {
            
            let selectedItem = tableViewAlayamSubMenus.objectAtIndex(indexPath.row) as! AlayamMenuDTO
        
            mycell.lblMenuName.text = selectedItem.ArabicName
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                mycell.lblMenuName.font = UIFont(name: mycell.lblMenuName.font.fontName, size: 18)
            }
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: selectedItem.MobileIcon)!)
            request.addValue("image/*", forHTTPHeaderField: "Accept")
            if selectedItem.MobileIcon != ""
            {
                
                UIGraphicsBeginImageContext(mycell.imgMenuImage.bounds.size);
                CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, mycell.imgMenuImage.bounds.size.width, mycell.imgMenuImage.bounds.size.height)); // this may not be necessary
                let image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
            
            mycell.imgMenuImage.setImageWithUrlRequest(request, placeHolderImage: image, success: { (request, response, image, fromCache) -> Void in
                mycell.imgMenuImage.image = image
                mycell.imgMenuImage.hidden = false
                }, failure: { (request, response, error) -> Void in
                    
            })
            }else
            {
                mycell.imgMenuImage.hidden = true
            }
//            mycell.imgMenuImage.image = UIImage(named: "local_news")
        }
        else if indexPath.section == 3
        {
            mycell.lblMenuName.text = (tableViewOnlineSubMenus.objectAtIndex(indexPath.row) as! AlayamMenuDTO).ArabicName
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                mycell.lblMenuName.font = UIFont(name: mycell.lblMenuName.font.fontName, size: 18)
            }
            UIGraphicsBeginImageContext(mycell.imgMenuImage.bounds.size);
            CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, mycell.imgMenuImage.bounds.size.width, mycell.imgMenuImage.bounds.size.height)); // this may not be necessary
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            print ((tableViewOnlineSubMenus.objectAtIndex(indexPath.row) as! AlayamMenuDTO).MobileIcon)
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: (tableViewOnlineSubMenus.objectAtIndex(indexPath.row) as! AlayamMenuDTO).MobileIcon)!)
            request.addValue("image/*", forHTTPHeaderField: "Accept")
            
            mycell.imgMenuImage.setImageWithUrlRequest(request, placeHolderImage: image, success: { (request, response, image, fromCache) -> Void in
                mycell.imgMenuImage.image = image
                }, failure: { (request, response, error) -> Void in
                    
            })
            
//            mycell.imgMenuImage.image = UIImage(named: "news_paper_printed")
        }
        
        else if indexPath.section == 4
        {
            mycell.lblMenuName.text = (tableViewArticleSubMenus.objectAtIndex(indexPath.row) as! AlayamMenuDTO).ArabicName
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                mycell.lblMenuName.font = UIFont(name: mycell.lblMenuName.font.fontName, size: 18)
            }
            UIGraphicsBeginImageContext(mycell.imgMenuImage.bounds.size);
            CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, mycell.imgMenuImage.bounds.size.width, mycell.imgMenuImage.bounds.size.height)); // this may not be necessary
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            print ((tableViewArticleSubMenus.objectAtIndex(indexPath.row) as! AlayamMenuDTO).MobileIcon)
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: (tableViewArticleSubMenus.objectAtIndex(indexPath.row) as! AlayamMenuDTO).MobileIcon)!)
            request.addValue("image/*", forHTTPHeaderField: "Accept")
            
            mycell.imgMenuImage.setImageWithUrlRequest(request, placeHolderImage: image, success: { (request, response, image, fromCache) -> Void in
                mycell.imgMenuImage.image = image
                }, failure: { (request, response, error) -> Void in
                    
            })
            
            //            mycell.imgMenuImage.image = UIImage(named: "news_paper_printed")
        }
        
        return mycell
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if isSearchEnabled
        {
            return nil
        }
        
        if sectionHeader.count > section
        {
            return sectionHeader.objectAtIndex(section) as? UIView
        }
        
        return nil
        
        
//        return headerView
    }
    
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
        print("Tapping working")
        print(recognizer.view?.tag)
        
        
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            recognizer.view?.backgroundColor = UIColor.lightGrayColor()
        }) { (completed) -> Void in
            if completed
            {
                recognizer.view?.backgroundColor = UIColor.whiteColor()
            }
        }
        
        let tagValue = recognizer.view?.tag
        let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
        
        if tagValue != 2 && tagValue != 3 && tagValue != 4
        {
            navigateToScreenBasedOnSections(tagValue!)
            return
        }
        
        if (tagValue == 2) {
            
            if tableViewAlayamSubMenus.count > 0
            {
                tableViewAlayamSubMenus = NSMutableArray()
                let range = NSMakeRange(indexPath.section, 1)
                let sectionToReload = NSIndexSet(indexesInRange: range)
                tblMenu.reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)

                return
            }
            
        }
            
        else if (tagValue == 3) {
            
            if tableViewOnlineSubMenus.count > 0
            {
                tableViewOnlineSubMenus = NSMutableArray()
                let range = NSMakeRange(indexPath.section, 1)
                let sectionToReload = NSIndexSet(indexesInRange: range)
                tblMenu.reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)

                return
            }
        }
        else if (tagValue == 4)
        {
            if tableViewArticleSubMenus.count > 0
            {
                tableViewArticleSubMenus = NSMutableArray()
                let range = NSMakeRange(indexPath.section, 1)
                let sectionToReload = NSIndexSet(indexesInRange: range)
                tblMenu.reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
                return
            }
        }
        
        tableViewOnlineSubMenus = NSMutableArray()
        tableViewAlayamSubMenus = NSMutableArray()
        tableViewArticleSubMenus = NSMutableArray()
        
        self.tblMenu.reloadData()
        
        if (tagValue == 2) {
            
            if tableViewAlayamSubMenus.count > 0
            {
                tableViewAlayamSubMenus = NSMutableArray()
            }
            else
            {
                tableViewAlayamSubMenus = aryAlayamSubmenus.mutableCopy() as! NSMutableArray
            }
            
            tableViewOnlineSubMenus = NSMutableArray()
            tableViewArticleSubMenus = NSMutableArray()
            
        }
        
        else if (tagValue == 3) {
            
            if tableViewOnlineSubMenus.count > 0
            {
                tableViewOnlineSubMenus = NSMutableArray()
            }
            else
            {
                tableViewOnlineSubMenus = aryOnlineSbumenus.mutableCopy() as! NSMutableArray
            }
            
            tableViewAlayamSubMenus = NSMutableArray()
            tableViewArticleSubMenus = NSMutableArray()
        }
        else if (tagValue == 4)
        {
            if tableViewArticleSubMenus.count > 0
            {
                tableViewArticleSubMenus = NSMutableArray()
            }
            else
            {
                tableViewArticleSubMenus = aryArticlesList.mutableCopy() as! NSMutableArray
            }
            
            tableViewAlayamSubMenus = NSMutableArray()
            tableViewOnlineSubMenus = NSMutableArray()
        }
        
//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            self.tblMenu.reloadData()
//        })
//        
//        return
        
        let range = NSMakeRange(indexPath.section, 1)
        let sectionToReload = NSIndexSet(indexesInRange: range)
        tblMenu.reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
        
//        var range2 = NSMakeRange(3, 1)
//        var sectionToReload2 = NSIndexSet(indexesInRange: range2)
//        tblMenu.reloadSections(sectionToReload2, withRowAnimation:UITableViewRowAnimation.Fade)
//
//        
//        var range3 = NSMakeRange(4, 1)
//        var sectionToReload3 = NSIndexSet(indexesInRange: range3)
//        tblMenu.reloadSections(sectionToReload3, withRowAnimation:UITableViewRowAnimation.Fade)

    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if isSearchEnabled
        {
            return 0
        }
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
            return 55
        }
        return 45
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if isSearchEnabled
        {
            return 91
        }
        
        return 45
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if isSearchEnabled
        {
            let detailsViewController = getViewControllerInstance("Main", storyboardId: "HomeDetailViewControllerID") as! HomeDetailViewController
            detailsViewController.detailsTitle = ""
            
            detailsViewController.sliderNewsDetails = searchArray.objectAtIndex(indexPath.row) as! SliderNewsDTO
            
            detailsViewController.detailsTitle = (searchArray.objectAtIndex(indexPath.row) as! SliderNewsDTO).SectionName
            
            LocalCacheDataHandler().addToReadNewsForCache("\(detailsViewController.sliderNewsDetails.NewsMainID)")
            
            if !readNewsIds.containsObject("\(detailsViewController.sliderNewsDetails.NewsMainID)")
            {
                readNewsIds.addObject("\(detailsViewController.sliderNewsDetails.NewsMainID)")
            }
            
            self.navigationController?.pushViewController(detailsViewController, animated: true)
            return
        }
       
        var categoryType = ""
        var newsType = ""
        var menuTitle = ""
        
        if indexPath.section == 2
        {
            
            categoryType = (tableViewAlayamSubMenus.objectAtIndex(indexPath.row) as! AlayamMenuDTO).EnglishName
            newsType = "online"
            menuTitle = (tableViewAlayamSubMenus.objectAtIndex(indexPath.row) as! AlayamMenuDTO).ArabicName
            
            let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
            tracker2.set(kGAIScreenName, value: "iOS-online-\(categoryType)")
            
            let builder = GAIDictionaryBuilder.createScreenView()
            tracker2.send(builder.build() as [NSObject : AnyObject])
        }
        else if indexPath.section == 3
        {
            categoryType = (tableViewOnlineSubMenus.objectAtIndex(indexPath.row) as! AlayamMenuDTO).EnglishName
            newsType = "alayam"
            menuTitle = (tableViewOnlineSubMenus.objectAtIndex(indexPath.row) as! AlayamMenuDTO).ArabicName
            
            let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
            tracker2.set(kGAIScreenName, value: "iOS-Alayam-\(categoryType)")
            
            let builder = GAIDictionaryBuilder.createScreenView()
            tracker2.send(builder.build() as [NSObject : AnyObject])
        }
        else if indexPath.section == 4
        {
            categoryType = (tableViewArticleSubMenus.objectAtIndex(indexPath.row) as! AlayamMenuDTO).EnglishName
            newsType = "article"
            menuTitle = (tableViewArticleSubMenus.objectAtIndex(indexPath.row) as! AlayamMenuDTO).ArabicName
            
            let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
            tracker2.set(kGAIScreenName, value: "iOS-Article-\(categoryType)")
            
            let builder = GAIDictionaryBuilder.createScreenView()
            tracker2.send(builder.build() as [NSObject : AnyObject])
            
            let weatherViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShareNewsViewControllerID") as! ShareNewsViewController
            weatherViewController.menuTitle = menuTitle
            weatherViewController.categoryList = categoryType
            let weatherNavController = UINavigationController(rootViewController: weatherViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = weatherNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
            weatherViewController.navigationController?.navigationBarHidden = true
            return
        }
        else
        {
            return
        }
       
        let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        homeViewController.newsCategory = categoryType
        homeViewController.newsType = newsType
        homeViewController.menuTitle = menuTitle
        let homeNavController = UINavigationController(rootViewController: homeViewController)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.centerViewController = homeNavController
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
    }
    
    //MARK:- BusinessLogic methods
    
    
    func navigateToScreenBasedOnSections(section : Int)
    {
        switch (section)
        {
            //Home Page
        case 0:
            let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
            homeViewController.newsCategory = NewsCategory.NEWS_HOME.rawValue
            homeViewController.menuTitle = aryMenuItems[section]
            let homeNavController = UINavigationController(rootViewController: homeViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = homeNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
            
            break;
            
//        case 1:
//            //var weatherViewController = getViewControllerInstance("Weather", storyboardId: "WeatherViewController") as! WeatherViewController
//            
//            /*var weatherViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WeatherViewController") as! WeatherViewController
//            var weatherNavController = UINavigationController(rootViewController: weatherViewController)
//            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            appDelegate.centerContainer!.centerViewController = weatherNavController
//            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
//            weatherViewController.navigationController?.navigationBarHidden = true*/
//            UIApplication.sharedApplication().openURL(NSURL(string: "itms://itunes.apple.com/bh/app/almjals-alrmdanyt/id1120788501?mt=8")!)
//            
//            print("OK", terminator: "")
//            break;
            
            //Breaking anews
        case 1:
            let breakingNewsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BreakingNewsViewController") as! BreakingNewsViewController
            let breakNewsNavController = UINavigationController(rootViewController: breakingNewsViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = breakNewsNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
            breakingNewsViewController.navigationController?.navigationBarHidden = true
            print("breaking", terminator: "")
            break;
            
            
            //Local News
//        case 2:
//            var homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
//            homeViewController.newsCategory = NewsCategory.NEWS_LOCAL.rawValue
//            homeViewController.menuTitle = aryMenuItems[section]
//            var localNewsNavController = UINavigationController(rootViewController: homeViewController)
//            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            appDelegate.centerContainer!.centerViewController = localNewsNavController
//            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
//            homeViewController.navigationController?.navigationBarHidden = true
//            break;
//            
//            //Economics News
//        case 3:
//            var homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
//            homeViewController.newsCategory = NewsCategory.NEWS_ECONOMICS.rawValue
//            homeViewController.menuTitle = aryMenuItems[section]
//            var ecoNavController = UINavigationController(rootViewController: homeViewController)
//            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            appDelegate.centerContainer!.centerViewController = ecoNavController
//            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
//            homeViewController.navigationController?.navigationBarHidden = true
//            break;
//            
//            //Sports News
//        case 4:
//            var homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
//            homeViewController.newsCategory = NewsCategory.NEWS_SPORTS.rawValue
//            homeViewController.menuTitle = aryMenuItems[section]
//            var sportsNavController = UINavigationController(rootViewController: homeViewController)
//            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            appDelegate.centerContainer!.centerViewController = sportsNavController
//            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
//            homeViewController.navigationController?.navigationBarHidden = true
//            break;
//            
//            //Variety News
//        case 5:
//            var homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
//            homeViewController.newsCategory = NewsCategory.NEWS_VARIETY.rawValue
//            homeViewController.menuTitle = aryMenuItems[section]
//            var varityNavController = UINavigationController(rootViewController: homeViewController)
//            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            appDelegate.centerContainer!.centerViewController = varityNavController
//            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
//            homeViewController.navigationController?.navigationBarHidden = true
//            break;
//            
//            //International News
//        case 6:
//            var homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
//            homeViewController.newsCategory = NewsCategory.NEWS_INTERNATIONAL.rawValue
//            homeViewController.menuTitle = aryMenuItems[section]
//            var intNavController = UINavigationController(rootViewController: homeViewController)
//            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            appDelegate.centerContainer!.centerViewController = intNavController
//            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
//            homeViewController.navigationController?.navigationBarHidden = true
//            break;
//            
            //Navigate to WritesWebView
        case 4:
            
            let weatherViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShareNewsViewControllerID") as! ShareNewsViewController
            let weatherNavController = UINavigationController(rootViewController: weatherViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = weatherNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
            weatherViewController.navigationController?.navigationBarHidden = true

            
            break;
            
            //Radio News
        case 5:
            let radioViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RadioTVViewController") as! RadioTVViewController
            let radioNavController = UINavigationController(rootViewController: radioViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = radioNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
            radioViewController.navigationController?.navigationBarHidden = true
            break;
            
            //Photography News
        case 6:
            let photoViewController = getViewControllerInstance("Photos", storyboardId: "PhotographyViewControllerID") as! PhotographyViewController
            let photoNavController = UINavigationController(rootViewController: photoViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = photoNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
            photoViewController.navigationController?.navigationBarHidden = true
            break;
            
            //Share Application
        case 7:
            let textToShare = "تطبيق \"الأيام\" - التطبيق الإخباري المحدث للآيفون والآندرويد ، مع خدمة الإشعارات المباشرة من الوكالات العالمية، لتكن اول من يعلم   حمل التطبيق"
            
            
            if let myWebsite = NSURL(string: "http://alay.am/IYNfkN")
            {
                let objectsToShare = [textToShare, myWebsite]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                //New Excluded Activities Code
                activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
                //
                if let wPPC = activityVC.popoverPresentationController {
                    wPPC.sourceView = self.view
                    wPPC.sourceRect = tblMenu.frame
                    //  or
//                    wPPC.barButtonItem = some bar button item
                }
                presentViewController( activityVC, animated: true, completion: nil )
//                self.presentViewController(activityVC, animated: true, completion: nil)
            }
            break;
            
            
            //Send News
        case 8:
            
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                
                //Tracker 1 & 2
                let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
                tracker2.set(kGAIScreenName, value: "iOS-SendNewsView")
                
                let builder = GAIDictionaryBuilder.createScreenView()
                tracker2.send(builder.build() as [NSObject : AnyObject])
                
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
            
            break;
            
            //tags News
        case 9:
            let tagViewController = getViewControllerInstance("Main", storyboardId: "TagsViewControllerID") as! TagsViewController
            tagViewController.isNavigateFromMenu = true
            let tagNavController = UINavigationController(rootViewController: tagViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = tagNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
            tagViewController.navigationController?.navigationBarHidden = true
            break;
            
            //QR News
        case 10:
           
            let readerlistViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ReaderListViewControllerID") as! ReaderListViewController
            let readerlistNavController = UINavigationController(rootViewController: readerlistViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = readerlistNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
            readerlistViewController.navigationController?.navigationBarHidden = true
            break;
            
            //ReaderList News
        case 11:
            let qrViewController = self.storyboard?.instantiateViewControllerWithIdentifier("QRReaderViewController") as! QRReaderViewController
            let qrNavController = UINavigationController(rootViewController: qrViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = qrNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
            qrViewController.navigationController?.navigationBarHidden = true
            break;
            
            //PDF News
        case 12:
            let pdfViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PDFReaderViewController") as! PDFReaderViewController
            let pdfNavController = UINavigationController(rootViewController: pdfViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = pdfNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
            pdfViewController.navigationController?.navigationBarHidden = true
            break;
            
            
            //settings
        case 13:
            let settingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
            let settingNavController = UINavigationController(rootViewController: settingViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = settingNavController
            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
            settingViewController.navigationController?.navigationBarHidden = true
            break;
            
            
            //weaather
        
            
        default:
            break;
            
        }
        

    }
    

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        let systemVersion = UIDevice.currentDevice().systemVersion
        
        mailComposerVC.setToRecipients(["support@alayam.com"])
        mailComposerVC.setSubject("Feed back")
        mailComposerVC.setMessageBody("App version : 1.0, iOS version : \(systemVersion)", isHTML: false)
        
        return mailComposerVC
    }

}


extension UIViewController
{
    func getViewControllerInstance(storyboardName : String, storyboardId :String) ->AnyObject
    {
        let storyboard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        let viewController: AnyObject! = storyboard.instantiateViewControllerWithIdentifier(storyboardId)
        
        return viewController;
    }
}


extension MenuViewController : MFMailComposeViewControllerDelegate
{
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}


extension MenuViewController : UISearchBarDelegate
{
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        isSearchEnabled = true
        tblMenu.reloadData()
        
        searchBar.showsCancelButton = true
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            appDelegate.centerContainer!.maximumRightDrawerWidth = screenSize.width
        })
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        var searchText = (searchBar.text! as NSString)
        
        var searchedTextWithoutSpace1 = searchText.stringByReplacingOccurrencesOfString(" ", withString: "")
        var searchedTextWithoutSpace = searchedTextWithoutSpace1.stringByReplacingOccurrencesOfString("\n", withString: "")
        
        if searchedTextWithoutSpace == ""
        {
            searchArray = NSMutableArray()
            tblMenu.reloadData()
            
        }
        searchedTextWithoutSpace = searchedTextWithoutSpace.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        WebServiceHandler().getMethod(true, url: "http://mobile.alayam.com/api/NewsSearch?MobileRequest=SearchNews&PageNo=1&RowsPerPage=10&SearchTag=\(searchedTextWithoutSpace)", header: nil, body: nil) { (dict, error) -> Void in
            
            if dict != nil
            {
                
                self.searchArray = HomeSliderNewsResponseDTO().initWithJsonRootDictionary(dict).Data.SearchNews
                self.tblMenu.reloadData()
            }
            
        }

    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        
//        
//        var searchText = (searchBar.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
//        
//        var searchedTextWithoutSpace1 = searchText.stringByReplacingOccurrencesOfString(" ", withString: "")
//        var searchedTextWithoutSpace = searchedTextWithoutSpace1.stringByReplacingOccurrencesOfString("\n", withString: "")
//        
//        if searchedTextWithoutSpace == ""
//        {
//            searchArray = NSMutableArray()
//            tblMenu.reloadData()
//            return true
//        }
//        searchedTextWithoutSpace = searchedTextWithoutSpace.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//        WebServiceHandler().getMethod(true, url: "http://mobile.alayam.com/api/NewsSearch?MobileRequest=SearchNews&PageNo=1&RowsPerPage=10&SearchTag=\(searchedTextWithoutSpace)", header: nil, body: nil) { (dict, error) -> Void in
//            
//            if dict != nil
//            {
//            
//                self.searchArray = HomeSliderNewsResponseDTO().initWithJsonRootDictionary(dict).Data.SearchNews
//                self.tblMenu.reloadData()
//            }
//            
//        }
        
        
//        var searchString = searchBar.text.replaceRange(range, with: "c")
        
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchBar.endEditing(true)
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar)

    {
        searchBar.showsCancelButton = false
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let screenSize: CGRect = UIScreen.mainScreen().bounds
                       
            if screenSize.height <= 568 {
                appDelegate.centerContainer!.maximumRightDrawerWidth = screenSize.width - 50
            }else {
                appDelegate.centerContainer!.maximumRightDrawerWidth = screenSize.width - 100
            }
            
            
        })
        
        searchBar.text = ""
        searchBar.endEditing(true)
     
        isSearchEnabled = false
        
        searchArray = NSMutableArray()
        
        tblMenu.reloadData()
    }


}




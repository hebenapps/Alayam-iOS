//
//  BreakingNewsViewController.swift
//  Alayam
//
//  Created by Mala on 7/30/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class BreakingNewsViewController: UIViewController, BreakingNewsModelDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate {
    
    //MARK:- IBOutlets
    var refreshControl : CustomPullToRefreshControl!
    var refreshView : UIImageView!
    
    @IBOutlet weak var tblHotNewsListView: UITableView!
    @IBOutlet weak var imgViewLoading: UIImageView!
    @IBOutlet weak var constraintHotTableViewBottom: NSLayoutConstraint!
    @IBOutlet var newsTitle : UILabel!
    var newsCategory = ""
    var isPageRefresStarted = false
    
    var menuTitle = "الأخبار العاجلة"
    var old = 0
    var new = 0
    var readNewsIds = NSMutableArray()
    //MARK:- Properties
    
    let numberOfNews = 10
    var model = BreakingNewsModel()
    
   //MARK:- ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let appdelegate = AppDelegate()
        appdelegate.Loadwebview(self.view, target: self)
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
            newsTitle.font = UIFont(name: newsTitle.font.fontName, size: 25)
        }
        
        self.tblHotNewsListView.setNeedsLayout()
        self.tblHotNewsListView.layoutIfNeeded()
        
        self.navigationController?.navigationBarHidden = true
        imgViewLoading.hidden = true
        model.delegate = self
        
        model.getBreakingNewsFreshData(true ,pageNumber: 1, numberOfNews: numberOfNews, category: newsCategory)
        
        refreshView = UIImageView(image: UIImage(named: "fav"))
        
        refreshView.frame = CGRectMake(
            floor(self.view.bounds.size.width / 2) - 16,
            self.view.bounds.size.height - 16 * 2,
            16 * 2,
            16 * 2)
        self.refreshControl =  CustomPullToRefreshControl(inScrollView: tblHotNewsListView, activityIndicatorView: refreshView) // [[CustomPullToRefreshControl alloc]
        //            initInScrollView:self.scrollView
        //            activityIndicatorView:self.refreshIV];
        self.refreshControl.backgroundColor = UIColor.clearColor()
        //        self.refreshControl.tintColor = UIColor(red: 23/255, green: 180/255, blue: 241/255, alpha: 1) // UIColorFromHex(0xF7931AFF);
        //        self.refreshControl.strokeColor = UIColor(red: 0, green: 24/255, blue: 63/255, alpha: 1)
        self.refreshControl.pullView = UIImageView(image: UIImage(named: "fav_img_reader1")) // [[UIImageView alloc] initWithImage:self.refreshIV.image];
        self.refreshControl.drawDiskWhenPulling = false;
        self.refreshControl.enableDiskDripEffect = false;
        self.refreshControl.stickToTopWhenRefreshing = false;
        self.refreshControl.scrollUpToCancel = true;
        self.refreshControl.refreshStyle = CustomPullToRefreshNone;
        //        	self.refreshControl.refreshEasing = CustomPullToRefreshMomentum;
        
        self.refreshControl.addTarget(self, action: Selector("pullToRefresh:"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.addTarget(self, action: Selector("cancelRefresh:"), forControlEvents: UIControlEvents.TouchCancel)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

      
    override func viewWillAppear(animated: Bool) {
     //   model.getHomeLatestNewsFreshData(1, numberOfNews: numberOfNews,category: newsCategory)
        
        //Tracker 1 & 2
        let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
        tracker2.set(kGAIScreenName, value: "iOS-HotNews")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker2.send(builder.build() as [NSObject : AnyObject])

//        var tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: "Breaking News Screen")
//        
//        var builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])

        
           }
    
    //MARK:- IBAction methods
    @IBAction func menuButtonClick(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
    }
    
    func pullToRefresh(sender: AnyObject?)
    {
        
        imgViewLoading.hidden = true
        var arrayofimages = [UIImage]()
        
        for (var k = 1; k<=42 ; k++)
        {
            arrayofimages.append(UIImage(named: "tmp-\(k).png")!)
        }
        
        refreshView.animationImages = arrayofimages
        refreshView.animationDuration = 4
        
        refreshView.startAnimating()
        
        
        //        self.refreshView.layer.addAnimation(animation, forKey: "rotate")
        pullDowntoRefresh()
    }
    
    func cancelRefresh(sender: AnyObject?)
    {
        refreshControl.endRefreshing()
    }

    func pullDowntoRefresh()
    {
        imgViewLoading.hidden = true
       model.getBreakingNewsFreshData(false ,pageNumber: 1, numberOfNews: numberOfNews, category: newsCategory)
    }
    
    //MARK:- TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        NSLog("%@", model.tableViewHotNewsDataSource.count)
        return model.tableViewHotNewsDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BreakingNewsTableViewCellID", forIndexPath: indexPath) as! BreakingNewsTableViewCell
        let news = model.tableViewHotNewsDataSource.objectAtIndex(indexPath.row) as! HotNewsDTO
        cell.configureWithDataRegular(news)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailsViewController = getViewControllerInstance("Main", storyboardId: "PageViewControllerID") as! PageViewController
        detailsViewController.sliderNewsDetailsArr = model.tableViewHotNewsDataSource
        detailsViewController.currentIndex = indexPath.row
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        if (isPageRefresStarted == false) && indexPath.row == (model.tableViewHotNewsDataSource.count - 1) {
            
            isPageRefresStarted = true
            
            let pagenumber = (model.tableViewHotNewsDataSource.count / numberOfNews) + 1
            new = pagenumber
            if old == new {
                imgViewLoading.hidden = true
            }else{
                old = pagenumber
                model.getBreakingNews(pagenumber, numberOfNews: numberOfNews, category: newsCategory)
                imgViewLoading.hidden = false
                //            CodeSnippets.rotateLayer(imgViewLoading.layer)
                
                var arrayofimages = [UIImage]()
                
                for (var k = 1; k<=42 ; k++)
                {
                    arrayofimages.append(UIImage(named: "tmp-\(k).png")!)
                }
                
                imgViewLoading.animationImages = arrayofimages
                imgViewLoading.animationDuration = 4
                
                imgViewLoading.startAnimating()
                
                
                constraintHotTableViewBottom.constant = 33
                self.view.layoutIfNeeded()
                

            }
            
        }
    }

//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("BreakingNewsTableViewCellID", forIndexPath: indexPath) as! BreakingNewsTableViewCell
//        
//        var yourLabelHeight = cell.lblHotNewsDetails.
//        return yourLabelHeight
//    }
//    
    
        //MARK:- Model Delegate
    
    func refreshTableViewWithRegularNews()
    {
        isPageRefresStarted = false
        
        tblHotNewsListView.reloadData()
        
        imgViewLoading.hidden = true
        imgViewLoading.layer.removeAllAnimations()
        constraintHotTableViewBottom.constant = 0
        self.view.layoutIfNeeded()
    }
    
    func refreshRegularNewsWithFreshData()
    {
        if refreshControl != nil
        {
            refreshControl.endRefreshing()
        }
        readNewsIds = LocalCacheDataHandler().fetchAllReadedNews()
        
        if model.tableViewHotNewsDataSource.count < 10
        {
            isPageRefresStarted = true
        }
        else
        {
            isPageRefresStarted = false
        }
       
        tblHotNewsListView.reloadData()
        
        imgViewLoading.hidden = true
        imgViewLoading.layer.removeAllAnimations()
        constraintHotTableViewBottom.constant = 0
        self.view.layoutIfNeeded()
    }
    
    
    @IBAction func onClickWeatherButton(sender: AnyObject) {
        let weatherViewController = getViewControllerInstance("Main", storyboardId: "WeatherViewController") as! WeatherViewController
        self.navigationController?.pushViewController(weatherViewController, animated: true)
    }


}

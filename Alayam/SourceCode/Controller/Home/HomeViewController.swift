//
//  HomeViewController.swift
//  Alayam
//
//  Created by Mala on 7/18/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit
import Alamofire

enum NewsCategory : String
{
    case NEWS_HOME = ""
//    case NEWS_HOT = ""
    case NEWS_LOCAL = "local"
    case NEWS_ECONOMICS = "economic"
    case NEWS_SPORTS = "sports"
    case NEWS_VARIETY = "variety"
    case NEWS_INTERNATIONAL = "international"
}

class HomeViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource , HomeNewsModelDelegate, SOAPServiceHandlerDelegate, UIWebViewDelegate {

    //MARK:- IBOutlets
    
    var refreshControl : CustomPullToRefreshControl!
    var refreshView : UIImageView!
    
    //@IBOutlet weak var lblNewsDate: UILabel!
    @IBOutlet weak var lblMenuTitle: UILabel!
    
    @IBOutlet weak var tblNewsListView: UITableView!
    
    @IBOutlet weak var imgViewLoader: UIImageView!
    @IBOutlet weak var constraintTableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var pageCtrlPage: UIPageControl!
    
    @IBOutlet weak var scrollImages: UIScrollView!
    
    @IBOutlet weak var lblNewsTitle : UILabel!
    
    @IBOutlet weak var lblNewsSubtitle : UILabel!
    
    var newsCategory = NewsCategory.NEWS_HOME.rawValue
    
    var newsType = "alayam"
    
    var menuTitle = "الصفحة الرئيسية"
    
    var readNewsIds = NSMutableArray()
    
    var isPageRefresStarted = false
    
    //MARK:- Properties
    
    let numberOfNews = 15
    
    var firstTime = true
    
    private var animatedIdArray = NSMutableArray()
    
    var model = HomeNewsModel()    
    
    var sliderTimer : NSTimer!
    
    //MARK:- ViewcontrollerLifeCycle
    
    
    func successResponseString(responseXML: NSData) {
        print(responseXML)
        
        let datawill = XMLDataParser()
        datawill.parser = NSXMLParser(data: responseXML)
        datawill.parser.delegate = datawill
        datawill.parser.parse()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        checkDevice()
        let appdelegate = AppDelegate()
        appdelegate.Loadwebview(self.view, target: self)
        
        
        LocalCacheDataHandler.removeImage("HomeNews")

        let gesture = UITapGestureRecognizer(target: self, action: Selector("navigateToDetailsPage:"))
        gesture.numberOfTapsRequired = 1
        scrollImages.addGestureRecognizer(gesture)
        
        model.delegate = self

        scrollImages.tag = 204
        
//        model.getHomeNewsList()
//        model.getHomeLatestNewsFreshData(1, numberOfNews: numberOfNews)
        
        tblNewsListView.delegate = self
        tblNewsListView.dataSource = self
        
        if newsCategory != ""
        {
            model.isCategoryNews = true
        }
        
        imgViewLoader.hidden = true
        lblMenuTitle.text = menuTitle
        model.getHomeLatestNewsFreshData(true,pageNumber: 1, numberOfNews: numberOfNews,category: newsCategory,newsType: newsType)
        
        refreshView = UIImageView(image: UIImage(named: "fav"))
        
        refreshView.frame = CGRectMake(
            floor(self.view.bounds.size.width / 2) - 16,
            self.view.bounds.size.height - 16 * 2,
            16 * 2,
            16 * 2)
        self.refreshControl =  CustomPullToRefreshControl(inScrollView: tblNewsListView, activityIndicatorView: refreshView) // [[CustomPullToRefreshControl alloc]
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
//        [self.refreshControl addTarget:self action:@selector(pulledToRefresh:)
//        forControlEvents:UIControlEventValueChanged];
//        [self.refreshControl addTarget:self action:@selector(cancelledRefresh:)
//        forControlEvents:UIControlEventTouchCancel];
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkDevice(){
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            lblMenuTitle.font = UIFont (name: lblMenuTitle.font.fontName, size: 28)
        }
    }
    
    func pullToRefresh(sender: AnyObject?)
    {
//        var animation = CABasicAnimation(keyPath: "transform")// [CABasicAnimation animationWithKeyPath:@"transform"];
//        var transform = self.refreshView.layer.transform;
//        transform.m34 = -1/500;
//        transform = CATransform3DRotate(transform, CGFloat(M_PI), 0, 1, 0) //CATransform3DRotate(transform, M_PI, 0, 1, 0)
//        animation.autoreverses = true;
//        animation.toValue = NSValue(CATransform3D: transform)//( [NSValue valueWithCATransform3D:transform];
//        animation.duration = 0.3;
//        animation.repeatCount = 1000;
        
        
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
    
    override func viewWillAppear(animated: Bool) {
//        model.getHomeLatestNewsFreshData(1, numberOfNews: numberOfNews,category: newsCategory)
        
        if sliderTimer != nil
        {
            sliderTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "moveToNextPage", userInfo: nil, repeats: true)
        }
        
        tblNewsListView.reloadData()
        
       // self.mm_drawerController setopenDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
        
        
        //Tracker 1 & 2
        
        let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
        tracker2.set(kGAIScreenName, value: "iOS-Home View Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker2.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        if sliderTimer != nil
        {
            sliderTimer.invalidate()
        }
        
        //self.mm_drawerController setopenDrawerGestureModeMask = MMOpenDrawerGestureMode.None
    }
    
    
    
    
    //MARK:- IBAction methods

    @IBAction func menuButtonClick(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)

    }
    
    func navigateToDetailsPage(sender : AnyObject)
    {
        if model.tableSliderDataSource.count > self.pageCtrlPage.currentPage
        {
            firstTime = false
            let newsDetails = model.tableSliderDataSource.objectAtIndex(self.pageCtrlPage.currentPage) as! SliderNewsDTO
            
            let detailsViewController = getViewControllerInstance("Main", storyboardId: "HomeDetailViewControllerID") as! HomeDetailViewController
            detailsViewController.sliderNewsDetails = newsDetails
            detailsViewController.detailsTitle = menuTitle
            self.navigationController?.pushViewController(detailsViewController, animated: true)
            
        }
    }
    
    func navigateToDetailsPageForHeader(sender : AnyObject)
    {
        if model.tableViewRegularNewsDataSource.count > 0
        {
//            var newsDetails = model.tableViewRegularNewsDataSource.objectAtIndex(0) as! SliderNewsDTO
            
            let detailsViewController = getViewControllerInstance("Main", storyboardId: "PageViewControllerID") as! PageViewController
            detailsViewController.sliderNewsDetailsArr = model.tableViewRegularNewsDataSource
            detailsViewController.currentIndex = 0
//            detailsViewController.detailsTitle = menuTitle
            self.navigationController?.pushViewController(detailsViewController, animated: true)
            
        }
    }
    
    
    //MARK:- BusinessLogic methods
    
    //MARK:- Delegate Methods -
    
    
    //MARK:- TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if model.tableViewRegularNewsDataSource.count == 1 || model.tableViewRegularNewsDataSource.count == 0
        {
            return 0
        }
    
        return model.tableViewRegularNewsDataSource.count - 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeRegularNewsTableViewCellID", forIndexPath: indexPath) as! HomeRegularNewsTableViewCell
        let news = model.tableViewRegularNewsDataSource.objectAtIndex(indexPath.row + 1) as! SliderNewsDTO
        cell.configureWithData(news)
        
        cell.setfontSize()
//        if indexPath.row == 0
//        {
//            lblNewsDate.text = news.NewsDate
//        }
        
        if readNewsIds.containsObject("\(news.NewsMainID)")
        {
            cell.setusAlreadySelectedNews()
        }
        else
        {
            cell.setusUnSelectedNews()
        }
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
        
        cell.imgViewNews.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(
            item:cell.imgViewNews, attribute:NSLayoutAttribute.Width,
            relatedBy:NSLayoutRelation.Equal,
            toItem:nil, attribute:NSLayoutAttribute.NotAnAttribute,
            multiplier:0, constant:115))
        
        }
        self.view.layoutIfNeeded()
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        
        var row = 5
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        if screenSize.height <= 568 {
            row = 4;
        }
        
        
        if firstTime && indexPath.row < row && !animatedIdArray.containsObject(indexPath.row)
        {
            animatedIdArray.addObject(indexPath.row)
            let minrow = row - 1;
            
            
            if indexPath.row == minrow
            {
                firstTime = false
            }
            
            let initialFrame = cell.frame
            
            cell.frame.origin.x = 300
            cell.alpha = 0
            
            
            let fromValue = 320
            let toValue = 0
            
            let delay = CGFloat(indexPath.row) * CGFloat(0.1)
            
            UIView.animateWithDuration(1, delay: Double(delay), usingSpringWithDamping: 0.3, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                cell.frame = initialFrame
                cell.alpha = 1
                }) { (completed) -> Void in
                    
            }
        }
        else
        {
            firstTime = false
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if model.tableViewRegularNewsDataSource.count == 0
        {
            return nil
        }
        
        let cellIdentifier = "HomeHeaderTableViewCellID";
        
        let headerView = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! HomeHeaderTableViewCell
        
        headerView.configureWithData(model.tableViewRegularNewsDataSource.objectAtIndex(0) as! SliderNewsDTO)
        headerView.setfontSize()
        self.view.layoutIfNeeded()
        let gesture = UITapGestureRecognizer(target: self, action: Selector("navigateToDetailsPageForHeader:"))
        gesture.numberOfTapsRequired = 1
        headerView.clipsToBounds = true
        headerView.addGestureRecognizer(gesture)
        
                return headerView
    }
    
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        
        if firstTime
        {
        
        let headerView = view
        let initialFrame = headerView.frame
        
        headerView.frame.origin.x = 300
        headerView.alpha = 0
        
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            headerView.frame = initialFrame
            headerView.alpha = 1
            }) { (completed) -> Void in
                
        }
        }

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
            return 100
        }
        return 91
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad
        {
            return 450
        }
        else
        {
            return 200
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        firstTime = false
        let detailsViewController = getViewControllerInstance("Main", storyboardId: "PageViewControllerID") as! PageViewController
//        detailsViewController.detailsTitle = menuTitle
        
        detailsViewController.sliderNewsDetailsArr = model.tableViewRegularNewsDataSource as NSMutableArray
        detailsViewController.currentIndex = indexPath.row + 1
        let currentSlider = model.tableViewRegularNewsDataSource.objectAtIndex(detailsViewController.currentIndex) as! SliderNewsDTO
        LocalCacheDataHandler().addToReadNewsForCache("\(currentSlider.NewsMainID)")
        
        if !readNewsIds.containsObject("\(currentSlider.NewsMainID)")
        {
            readNewsIds.addObject("\(currentSlider.NewsMainID)")
        }
        
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
       
        if (isPageRefresStarted == false) && indexPath.row == (model.tableViewRegularNewsDataSource.count - 2) {

            isPageRefresStarted = true
            
            let pagenumber = (model.tableViewRegularNewsDataSource.count / numberOfNews) + 1
            model.getHomeLatestNews(pagenumber, numberOfNews: numberOfNews,category: newsCategory)
            
            imgViewLoader.hidden = false
//            CodeSnippets.rotateLayer(imgViewLoader.layer)
            
            
            var arrayofimages = [UIImage]()
            
            for (var k = 1; k<=42 ; k++)
            {
                arrayofimages.append(UIImage(named: "tmp-\(k).png")!)
            }
            
            imgViewLoader.animationImages = arrayofimages
            imgViewLoader.animationDuration = 4
            
            imgViewLoader.startAnimating()
            
            
            
            constraintTableViewBottom.constant = 33
            self.view.layoutIfNeeded()
        }
    }
    
    
    func pullDowntoRefresh()
    {
        model.getHomeLatestNewsFreshData(false,pageNumber: 1, numberOfNews: numberOfNews,category: newsCategory,newsType: newsType)
    }

    //MARK:- Model Delegate
    
    func refreshSliderImageSet()
    {
        // use model.tableSliderDataSource object for top image slider
        ImageScroller()
        
    }
    
    func refreshTableViewWithRegularNews(isPageEnd : Bool)
    {
        refreshControl.endRefreshing()
        readNewsIds = LocalCacheDataHandler().fetchAllReadedNews()
        
        isPageRefresStarted = isPageEnd
        
        tblNewsListView.reloadData()
        
        imgViewLoader.hidden = true
        imgViewLoader.layer.removeAllAnimations()
        constraintTableViewBottom.constant = 0
        self.view.layoutIfNeeded()
    }
    
    func refreshRegularNewsWithFreshData()
    {
        if refreshControl != nil
        {
            refreshControl.endRefreshing()
        }
        readNewsIds = LocalCacheDataHandler().fetchAllReadedNews()
        let count = model.tableViewRegularNewsDataSource.count
        print(count)
        if model.tableViewRegularNewsDataSource.count < 10
        {
            isPageRefresStarted = true
        }
        else
        {
            isPageRefresStarted = false
        }
        tblNewsListView.reloadData()
        
        imgViewLoader.hidden = true
        imgViewLoader.layer.removeAllAnimations()
        constraintTableViewBottom.constant = 0
        self.view.layoutIfNeeded()
        
//        tblNewsListView.setContentOffset(CGPointMake(0,  UIApplication.sharedApplication().statusBarFrame.height - 15), animated: true)
    }
    
    func ImageScroller(){
        
        for (var i = 0; i < model.tableSliderDataSource.count; i++) {
            var svframe = CGRect()
            svframe.origin.x = scrollImages.frame.size.width * CGFloat(i)
            svframe.origin.y = 0
            svframe.size = scrollImages.frame.size
            
           let details = model.tableSliderDataSource.objectAtIndex(i) as! SliderNewsDTO
            
            let imgNews = UIImageView(frame: svframe)
            imgNews.setImageWithUrl(NSURL(string: details.ImageURL)!, placeHolderImage: UIImage(named: "placeholder"))//.image = UIImage(named: model.tableSliderDataSource.objectAtIndex(i) as! String)
            imgNews.contentMode = UIViewContentMode.ScaleToFill
           
            let viewOverlay = UIView(frame: svframe)
            viewOverlay.backgroundColor = UIColor (red: 0, green: 0, blue: 0, alpha: 0.3)
            imgNews.addSubview(viewOverlay)
            
            let imgInsideNews = UIImageView(frame: svframe)
            imgInsideNews.setImageWithUrl(NSURL(string: details.ImageURL)!, placeHolderImage: UIImage(named: "placeholder"))//.image = UIImage(named: model.tableSliderDataSource.objectAtIndex(i) as! String)
            imgInsideNews.contentMode = UIViewContentMode.ScaleAspectFit

            
            
            self.scrollImages.addSubview(imgNews)
            self.scrollImages.addSubview(imgInsideNews)
        }
        self.scrollImages.contentSize = CGSizeMake(self.scrollImages.frame.width * CGFloat(model.tableSliderDataSource.count), self.scrollImages.frame.height)
        self.scrollImages.delegate = self
        self.pageCtrlPage.currentPage = 0
        self.pageCtrlPage.numberOfPages = model.tableSliderDataSource.count
        
      
       sliderTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "moveToNextPage", userInfo: nil, repeats: true)
        
    }
    
    func moveToNextPage (){
       
        let pageWidth:CGFloat = CGRectGetWidth(self.scrollImages.frame)
        let maxWidth:CGFloat = pageWidth * CGFloat(model.tableSliderDataSource.count)
        let contentOffset:CGFloat = self.scrollImages.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth{
            slideToX = 0
        }
        self.scrollImages.scrollRectToVisible(CGRectMake(slideToX, 0, pageWidth, CGRectGetHeight(self.scrollImages.frame)), animated: true)
    }
    
    
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView)
    {
        if scrollView.tag == 204
        {
            
            let pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
            self.pageCtrlPage.currentPage = Int(currentPage);
            
            for (var i = 0; i < model.tableSliderDataSource.count; i++) {
                if Int(currentPage) == i
                {
                    let details = model.tableSliderDataSource.objectAtIndex(i) as! SliderNewsDTO
                    //lblHeader.text = arytext.objectAtIndex(i) as? String
                    lblNewsTitle.text = details.NewsTitle
                    lblNewsSubtitle.text = details.NewsSubTitle
                }
                
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.tag == 204
        {
            let pageWidth = scrollView.frame.size.width
            let floadDecimal = scrollView.contentOffset.x / pageWidth
            //        var page = round(floadDecimal as Float)
            self.pageCtrlPage.currentPage = Int(CGFloat(ceil(Double(floadDecimal))))
            
            if model.tableSliderDataSource.count > self.pageCtrlPage.currentPage
            {
                let details = model.tableSliderDataSource.objectAtIndex(self.pageCtrlPage.currentPage) as! SliderNewsDTO
                //lblHeader.text = arytext.objectAtIndex(i) as? String
                lblNewsTitle.text = details.NewsTitle
                lblNewsSubtitle.text = details.NewsSubTitle
            }
            
        }
        
    }
    
    
    @IBAction func onClickWeatherButton(sender: AnyObject) {
        let weatherViewController = getViewControllerInstance("Main", storyboardId: "WeatherViewController") as! WeatherViewController
        self.navigationController?.pushViewController(weatherViewController, animated: true)
    }
    
    
    //Date Formate
    /*
    let date1 = NSCalendar.currentCalendar().dateWithEra(1, year: 2014, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
    let date2 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 8, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
    
    let years = date2.yearsFrom(date1)     // 0
    let months = date2.monthsFrom(date1)   // 9
    let weeks = date2.weeksFrom(date1)     // 39
    let days = date2.daysFrom(date1)       // 273
    let hours = date2.hoursFrom(date1)     // 6,553
    let minutes = date2.minutesFrom(date1) // 393,180
    let seconds = date2.secondsFrom(date1) // 23,590,800
    
    let timeOffset = date2.offsetFrom(date1) // "9M"
    
    let date3 = NSCalendar.currentCalendar().dateWithEra(1, year: 2014, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
    let date4 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
    
    let timeOffset2 = date4.offsetFrom(date3) // "1y"
    
    let timeOffset3 = NSDate().offsetFrom(date3) // "54m"
    
    */
    
    
    
}


protocol SOAPServiceHandlerDelegate
{
    func successResponseString(responseXML : NSData)
}


class SOAPServiceHandler: NSObject, NSURLConnectionDataDelegate {
    
    private var responseData : NSMutableData!
    
    var delegate : SOAPServiceHandlerDelegate?
    
    func postServiceRequest()
    {
        var soapMsg = "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope'>\n''<soap:Body>''<CelsiusToFahrenheit xmlns='http://tempuri.org/'>''<Celsius>2</Celsius>''</CelsiusToFahrenheit>''</soap:Body>''</soap:Envelope>'"
        var hostURL = "http://w3schools.com/webservices/tempconvert.asmx"
        
        var soapAction = "http://tempuri.org/CelsiusToFahrenheit"
        
        
        //        var soapMsg = "<?xml version='1.0' encoding='UTF-8'?><soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:tem='http://tempuri.org/'><soapenv:Header/><soapenv:Body><tem:GetBalance><tem:deviceID>23</tem:deviceID></tem:GetBalance></soapenv:Body></soapenv:Envelope>"
        
        //        var hostURL = "http://localhost:8966/AppleWatchWS.asmx"
        
        
        var request = NSMutableURLRequest(URL: NSURL(string: hostURL)!)
        let msgLength = String(soapMsg.characters.count)
        let data2 = soapMsg.dataUsingEncoding(NSUTF8StringEncoding)
        
        request.HTTPMethod = "POST"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        request.addValue(soapAction, forHTTPHeaderField: "SOAPAction")
        request.HTTPBody = data2
        
        //For alamofire
        
        
                Alamofire.upload( request, data: data2! )
                    .response { (request, response, data, error) in
                        // do stuff here
                        
//                        if let datans =
                        
                        var responseXMLString = NSString(bytes: data!.mutableCopy().mutableBytes, length: data!.mutableCopy().length, encoding: NSUTF8StringEncoding)
                        
                        
                }
        
        
//        var connection = NSURLConnection(request: request, delegate: self)
//        
//        if (connection != nil)
//        {
//            responseData = NSMutableData()
//        }
        
    }
    
    
    
    //MARK: NSURLConnectionDataDelegate methods
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        responseData.length = 0
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        responseData.appendData(data)
        
        print("ResponseDAta : \(data)")
    }
    
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        
        var responseXMLString = NSString(bytes: responseData.mutableBytes, length: responseData.length, encoding: NSUTF8StringEncoding)
        
        delegate?.successResponseString(responseData)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        
    }
    
    
    
}



class XMLDataParser: NSObject, NSXMLParserDelegate {
    
    var strXMLData:String = ""
    var currentElement:String = ""
    var passData:Bool=false
    var passName:Bool=false
    
    var nsMutableDictionary = NSMutableDictionary()
    var parser = NSXMLParser()
    
    
    //MARK: NSXMLParserDelegate methods
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        strXMLData = ""
        currentElement=elementName;
        print("element Name : \(elementName) && Element Value: \(elementName)")
        if(elementName=="id" || elementName=="name" || elementName=="cost" || elementName=="description")
        {
            if(elementName=="name"){
                passName=true;
            }
            passData=true;
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        
        nsMutableDictionary.setObject(strXMLData, forKey: elementName)
        
        if(elementName=="id" || elementName=="name" || elementName=="cost" || elementName=="description")
        {
            if(elementName=="name"){
                passName=false;
            }
            passData=false;
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if(passName){
            strXMLData=strXMLData+"\n\n"+string!
        }
        
        if(passData)
        {
            print(string)
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        NSLog("failure error: %@", parseError)
    }
    
    
}



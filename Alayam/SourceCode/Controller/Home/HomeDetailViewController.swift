//
//  HomeDetailViewController.swift
//  Alayam
//
//  Created by Mala on 7/25/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class HomeDetailViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var imgViewDetailsImage: UIImageView!
    
    @IBOutlet weak var lblNewsTitle: UILabel!
    @IBOutlet weak var lblNewsTitle1: UILabel!
    @IBOutlet weak var txtViewDetails: UITextView!
    
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var constraintWebViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblNewsDate: UILabel!
    
    var isAlreadyInReaderList = false
    
    @IBOutlet weak var webViewDetails: UIWebView!
    @IBOutlet weak var imgViewOriginalImage: UIImageView!
    
    @IBOutlet weak var btnReader: UIButton!
    @IBOutlet weak var constraintsScrollViewContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constraintsImageViewContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constraintsLabelTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintsLabelSubTitleHeight: NSLayoutConstraint!
    //MARK:- Properties
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var index : Int! = 0
    var isFromNotification: Bool!
    
    var detailsTitle = ""
    var sliderNewsDetails: SliderNewsDTO!
    var ImageDetails: SliderNewsDTO!
    var ImageDetailsArr = NSMutableArray()
    var NewsURL = ""
    var imageViewHeight : CGFloat = 220
    
    //imageZoom
    @IBOutlet weak var viewImageZoom: UIView!
    @IBOutlet weak var scrollViewZoom: UIScrollView!
    var imageViewZoom: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    var selectedCell = CollectionViewCell()
    
    @IBOutlet var collectionView : UICollectionView!
    var selectedRow : NSInteger!
    var readNewsIds = NSMutableArray()
    
    var defaults  = ["textFontSize":18]
    var MainNewsID : NSString!
    var isTapToHide :Bool = true
    
    //MARK:- ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        webViewDetails.frame = UIScreen.mainScreen().bounds
        webViewDetails.center = self.view.center
        self.view.backgroundColor = UIColor.whiteColor()
        viewImageZoom.backgroundColor = UIColor.whiteColor()
        
        collectionView.hidden = true
        btnClose.hidden = true
        if isFromNotification != nil {
            if isFromNotification == true{
                
                isFromNotification = false
                
                //            model.getBreakingNewsByID(true, pageNumber: 1, numberOfNews: 1, category: <#String#>)
                WebServiceHandler().getMethod(true, url: "http://mobile.alayam.com/api/Content?MobileRequest=SearchNewsByID&MainNewsID=\(MainNewsID)", header: nil, body: nil) { (dict, error) -> Void in
                    
                    if dict != nil
                    {
                        let arr : NSMutableArray =  HomeSliderNewsResponseDTO().initWithJsonRootDictionary(dict).Data.NewsDetails
                        if arr.count != 0{
                            self.sliderNewsDetails = arr.objectAtIndex(0) as! SliderNewsDTO
                            self.LoadStartupDetails()
                        }else{
                            let breakingNewsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BreakingNewsViewController") as! BreakingNewsViewController
                            let breakNewsNavController = UINavigationController(rootViewController: breakingNewsViewController)
                            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegate.centerContainer!.centerViewController = breakNewsNavController
                            //            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
                            breakingNewsViewController.navigationController?.navigationBarHidden = true
                        }
                        
                    }else{
                        let breakingNewsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BreakingNewsViewController") as! BreakingNewsViewController
                        let breakNewsNavController = UINavigationController(rootViewController: breakingNewsViewController)
                        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.centerContainer!.centerViewController = breakNewsNavController
                        //            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
                        breakingNewsViewController.navigationController?.navigationBarHidden = true
                    }
                    
                }
            }else{
                LoadStartupDetails()
            }
            
        }else{
            if sliderNewsDetails != nil {
                 LoadStartupDetails()
            }
           
        }
        if sliderNewsDetails != nil {
        WebServiceHandler().getMethod(true, url: "http://mobile.alayam.com/api/Content?MobileRequest=ImagesByNewsID&MainNewsID=\(sliderNewsDetails.NewsMainID)", header: nil, body: nil) { (dict, error) -> Void in
            
            if dict != nil
            {
                let arr : NSMutableArray =  HomeSliderNewsResponseDTO().initWithJsonRootDictionary(dict).Data.ImageDetails
                if arr.count != 0{
                    self.ImageDetailsArr = arr
                    
                }
            }
            self.collectionView.reloadData()
        }
        }
        //        lblTitle.text = detailsTitle
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ImageDetailsArr.count > 0 {
            return self.ImageDetailsArr.count
        }else {
            if sliderNewsDetails != nil {
            return 1
            }else {
                return 0
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        if ImageDetailsArr.count > 0 {
            let dict = ImageDetailsArr.objectAtIndex(indexPath.row) as! SliderNewsDTO
            cell.lblTitle.text = "\(indexPath.row+1) of \(ImageDetailsArr.count)"
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:"imageTapped:")
            cell.imgView.addGestureRecognizer(tapGestureRecognizer)
            cell.configuredata(dict)

        }else {
//            cell.imgView.image = imgViewOriginalImage.image
            cell.lblTitle.text = "1 of 1"
            cell.imgView.setImageWithUrl(NSURL(string: sliderNewsDetails.ImageURL)!, placeHolderImage: UIImage(named: "placeholder"))
            print("caption :\(sliderNewsDetails.NewsPhotoCaption)", terminator: "")
            cell.lblNewsTitle1.text = sliderNewsDetails.NewsTitle
        }
        // Animation for Cell
        cell.transform = CGAffineTransformMakeScale(0.8, 0.8)
        UIView.animateWithDuration(0.5,
            delay: 0.2,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                cell.transform = CGAffineTransformIdentity
            }, completion: nil)
        selectedCell = cell
//        selectedRow = indexPath.row
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.collectionView.bounds.width, self.collectionView.bounds.height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        viewImageZoom.hidden = false
        
        scrollActions()
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
    }
    
    func LoadStartupDetails(){
        
//        readNewsIds = LocalCacheDataHandler().fetchAllReadedNews()
//        LocalCacheDataHandler().addToReadNewsForCache("\(sliderNewsDetails.NewsMainID)")
//        
//        if !readNewsIds.containsObject("\(sliderNewsDetails.NewsMainID)")
//        {
//            readNewsIds.addObject("\(sliderNewsDetails.NewsMainID)")
//        }
        
        lblTitle.text = ""
        if  LocalCacheDataHandler().isAlreadyInReadersList(sliderNewsDetails)
        {
            btnReader.setImage(UIImage(named: "fav_img_reader"), forState: UIControlState.Normal)
            isAlreadyInReaderList = true
        }
        else
        {
            btnReader.setImage(UIImage(named: "w_star"), forState: UIControlState.Normal)
            isAlreadyInReaderList = false
        }
        
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad
        {
            imageViewHeight = 470
        }
        
        constraintsImageViewContainerHeight.constant = imageViewHeight
        webViewDetails.scrollView.scrollEnabled = false
        self.view.layoutIfNeeded()
        
        configureViewController(sliderNewsDetails)
        self.view.userInteractionEnabled = true
        
        viewImageZoom.backgroundColor = UIColor.blackColor()
        viewImageZoom.hidden = true
        
        viewImageZoom.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        btnClose.layer.cornerRadius = btnClose.frame.size.width/1
        
        isTapToHide = true
        
        let height = heightForView(lblNewsTitle.text!, font: lblNewsTitle.font, width: self.view.frame.size.width-20)
        
        constraintsLabelTitleHeight.constant = height
        if(lblSubTitle.text == "")
        {
            constraintsLabelSubTitleHeight.constant = 0
        }
        else
        {
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                lblSubTitle.font = UIFont(name: "DroidArabicKufi-Bold", size: 20.0)!
            }else{
                lblSubTitle.font = UIFont(name: "DroidArabicKufi-Bold", size: 13.0)!
            }
            let height1 = heightForView(lblSubTitle.text!, font: lblSubTitle.font, width: self.view.frame.size.width-20)
            constraintsLabelSubTitleHeight.constant = height1
        }
        self.view.layoutIfNeeded()
        
        imageViewHeight += lblSubTitle.frame.size.height
        
        imageViewHeight += lblNewsTitle.frame.size.height
        
        
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        // Animation for self
//        self.view.transform = CGAffineTransformMakeScale(0.8, 0.8)
//        UIView.animateWithDuration(0.5,
//            delay: 0.2,
//            usingSpringWithDamping: 1.0,
//            initialSpringVelocity: 1.0,
//            options: UIViewAnimationOptions.AllowUserInteraction,
//            animations: {
//                self.view.transform = CGAffineTransformIdentity
//            }, completion: nil)
        

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:"imageTapped:")
        imgViewOriginalImage.addGestureRecognizer(tapGestureRecognizer)
        //imgViewDetailsImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Home Detail View Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func scrollViewDoubleTapped1(gestureRecognizer: UITapGestureRecognizer)
    {
        viewImageZoom.hidden = true
        
//        if(isTapToHide == true)
//        {
//            
//            //            UIView.animateWithDuration(1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//            self.isTapToHide = false
//            //                self.btnClose.hidden = true
//            //                self.lblNewsTitle1.hidden = true
//            
//            self.btnClose.alpha = 0
//            self.lblNewsTitle1.alpha = 0
//            //                }, completion: nil)
//            
//            
//        }
//        else
//        {
//            //            UIView.animateWithDuration(1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//            self.isTapToHide = true
//            //            self.btnClose.hidden = false
//            //            self.lblNewsTitle1.hidden = false
//            self.btnClose.alpha = 1
//            self.lblNewsTitle1.alpha = 1
//            //                }, completion: nil)
//        }
    }
    
    func imageTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        scrollActions()
    }
    
    func scrollActions(){
        // Your action
        collectionView.hidden = false
        btnClose.hidden = false
        
        if self.imageViewZoom != nil
        {
            self.imageViewZoom.removeFromSuperview()
        }
        
//        self.viewImageZoom.alpha = 1
//        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
//            self.viewImageZoom.alpha = 1
//            }, completion: nil)
        
        
        print("Tap Gesture recognized")
        
        
        // 1
        //let imgstr = imgViewOriginalImage.image
//        collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: selectedRow, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
//        let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: selectedRow, inSection: 0)) as! CollectionViewCell
        let image = selectedCell.imgView.image
        imageViewZoom = UIImageView(image: image)
        imageViewZoom.frame = CGRect(origin: CGPointMake(0.0, 0.0), size:image!.size)
        
        // 2
        scrollViewZoom.addSubview(imageViewZoom)
        scrollViewZoom.contentSize = image!.size
        
        // 3
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped1:")
        doubleTapRecognizer.numberOfTapsRequired = 1
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollViewZoom.addGestureRecognizer(doubleTapRecognizer)
        
        
        // 4
        let scrollViewFrame = scrollViewZoom.frame
        let scaleWidth = scrollViewFrame.size.width / scrollViewZoom.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollViewZoom.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollViewZoom.minimumZoomScale = minScale;
        
        // 5
        scrollViewZoom.maximumZoomScale = 10.0
        scrollViewZoom.zoomScale = minScale;
        
        // 6
        centerScrollViewContents()
    }
    
    // start of image zoom scroll
    func centerScrollViewContents() {
        let boundsSize = scrollViewZoom.bounds.size
        var contentsFrame = imageViewZoom.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageViewZoom.frame = contentsFrame
        
    }
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1
        let pointInView = recognizer.locationInView(imageViewZoom)
        
        // 2
        var newZoomScale = scrollViewZoom.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollViewZoom.maximumZoomScale)
        
        // 3
        let scrollViewSize = scrollViewZoom.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        scrollViewZoom.zoomToRect(rectToZoomTo, animated: true)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageViewZoom
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    //end of image zoom scroll
    
    func configureViewController(newsDetails : SliderNewsDTO)
    {
        // txtViewDetails.text = newsDetails.NewsDetails
        print(newsDetails.NEWSURL)
        NewsURL = newsDetails.NEWSURL
        lblNewsTitle.text = newsDetails.NewsTitle
        lblCommentCount.text = "\(newsDetails.CommentCount)"
        lblNewsTitle1.text = newsDetails.NewsPhotoCaption
        lblNewsDate.text = newsDetails.NewsDate
        lblSubTitle.text = newsDetails.NewsSubTitle
        var string = String()
        
        let bounds = UIScreen.mainScreen().bounds
        var width:Int = Int(bounds.size.width)
        width = width - 20
        let height: Int = width - 100
        
        let widthStr = NSString(format: "width=\"%d\" height=\"%d\"", width,height) as String
        
        let aString: String = newsDetails.NewsDetails
        //        var newString = aString.stringByReplacingOccurrencesOfString("<p", withString: "<p dir=\"rtl\" lang=\"ar\" ", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let newString = aString.stringByReplacingOccurrencesOfString("width=\"620\" height=\"350\"", withString: widthStr, options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            lblNewsTitle.font = UIFont(name: "DroidArabicKufi-Bold", size: 26.0)!
            lblNewsTitle1.font = UIFont(name: "DroidArabicKufi-Bold", size: 18.0)!
            lblNewsDate.font = UIFont(name: "DroidArabicKufi-Bold", size: 18.0)!
            lblSubTitle.font = UIFont(name: "DroidArabicKufi-Bold", size: 18.0)!
        }else{
            lblNewsTitle.font = UIFont(name: "DroidArabicKufi-Bold", size: 14.0)!
            //            string = NSString(format: "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"></head><body dir=\"rtl\" lang=\"ar\" style='color:#00183F' align='justify' text=\"#FFFFFF\" face=\"DroidArabicKufi-Regular\" size=\"18\"><div align='justify' size=\"18\"> %@ </div></body></html>",newString) as String
        }
        string = NSString(format: "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"><meta name=\"viewport\"content=\"width=device-width\" /><style type=\"text/css\">.newsdescription img{width:auto;display:block;align-content:center;max-height:%@px;margin:0 auto;max-width:%@px;height:auto}.newsdescription iframe{width:auto;display:block;align-content:center;max-height:%@px;margin:0 auto;max-width:%@px;height:auto}</style></head><body dir=\"rtl\" lang=\"ar\" style='color:#00183F' align='right' text=\"#FFFFFF\" face=\"DroidArabicKufi-Regular\" size=\"18\"><div class='newsdescription' align='right' dir='rtl' size=\"18\"> %@ </div></body></html>" ,String(height),String(width),String(height),String(width),newString.stringByReplacingOccurrencesOfString("&nbsp;",
            withString: " ",
            options: NSStringCompareOptions.LiteralSearch,
            range: newString.startIndex..<newString.endIndex)) as String
        
        webViewDetails.loadHTMLString(string, baseURL: nil)
        
        imgViewDetailsImage.setImageWithUrl(NSURL(string: newsDetails.ImageURL)!, placeHolderImage: UIImage(named: "placeholder"))
        imgViewOriginalImage.setImageWithUrl(NSURL(string: newsDetails.ImageURL)!, placeHolderImage: UIImage(named: "placeholder"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- IBAction
    @IBAction func btnCloseAction(sender: AnyObject) {
        
        //        UIView.animateWithDuration(1, animations: { () -> Void in
//        self.viewImageZoom.alpha = 0
//        self.imageViewZoom.alpha = 0
        collectionView.hidden = true
        btnClose.hidden = true
        //        })
        //        UIView.animateWithDuration(0, delay: 2, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
        //            self.viewImageZoom.hidden = true
        //            self.imageViewZoom.removeFromSuperview()
        //        }, completion: nil)
        
    }
    
    @IBAction func btnBackAction(sender: AnyObject) {
        if self.navigationController?.popViewControllerAnimated(true) != nil{
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            let breakingNewsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BreakingNewsViewController") as! BreakingNewsViewController
            let breakNewsNavController = UINavigationController(rootViewController: breakingNewsViewController)
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = breakNewsNavController
            //            appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
            breakingNewsViewController.navigationController?.navigationBarHidden = true
        }
        
    }
    
    @IBAction func btnMenuAction(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
    }
    
    @IBAction func btnAddToReadersListAction(sender: AnyObject) {
        
        LocalCacheDataHandler().addNewReaderList(sliderNewsDetails)
        
        if isAlreadyInReaderList
        {
            googleAnalyticsEvent("Reader List Button", action: "Add to Reader List", label:"" , value: 0)
            btnReader.setImage(UIImage(named: "w_star"), forState: UIControlState.Normal)
            isAlreadyInReaderList = false
        }
        else
        {
            googleAnalyticsEvent("Reader List Button", action: "Remove from Reader List", label: "", value:0)
            btnReader.setImage(UIImage(named: "fav_img_reader"), forState: UIControlState.Normal)
            isAlreadyInReaderList = true
        }
    }
    
    @IBAction func btnTagsAction(sender: AnyObject) {
        googleAnalyticsEvent("Home_Tag", action: "Tag Button", label: "", value: 0)
        let tagsViewController = getViewControllerInstance("Main", storyboardId: "TagsViewControllerID") as! TagsViewController
        self.presentViewController(tagsViewController, animated: true, completion: nil)
        //        self.navigationController?.pushViewController(tagsViewController, animated: true)
        
    }
    
    @IBAction func btnCommentsAction(sender: AnyObject) {
        
        
        CommentDataHandler().getCommentListWithPagination(true, pageNumber: 1, numberOfNews: 100, queryParameter: nil, newsID: "\(sliderNewsDetails.NewsMainID)", commentType: "NEWS", Completion: { (response) in
            
            if response != nil {
                
                let commentsViewController = self.getViewControllerInstance("Comment", storyboardId: "CommentListViewControllerID") as! CommentListViewController
                commentsViewController.delegate = self
                commentsViewController.comments = response.Data.Comments
                
                if self.sliderNewsDetails != nil {
                commentsViewController.newsMainId = "\(self.sliderNewsDetails.NewsMainID)"
                }
                commentsViewController.commentType = "NEWS"
                
                self.navigationController?.pushViewController(commentsViewController, animated: true)
                
//                self.presentViewController(commentsViewController, animated: true, completion: nil)
                
            }
            
        }) { (error) in
            
        }
        
        
        
    }
    
    
    @IBAction func btnFavouriteAction(sender: AnyObject) {
        
    }
    
    @IBAction func onClickshareButton(sender: UIButton)
    {
        googleAnalyticsEvent("Home_ Share", action: "Share Button", label: "", value: 0)
        let textToShare = sliderNewsDetails.NewsTitle
        
        if let myWebsite = NSURL(string: "http://www.alayam.com")
        {
            let str = NewsURL
            let url = NSURL(string: str.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
            //            str = "\(url)"
            
            let objectsToShare = [textToShare, str]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                // Change Rect to position Popover
                let popup = UIPopoverController(contentViewController: activityVC)
                popup.presentPopoverFromRect(CGRectMake(sender.frame.origin.x , 92, 0, 0), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Up, animated: true)
                
                
            }
                //if iPad
            else {
                self.presentViewController(activityVC, animated: true, completion: nil)
            }
            
            
        }
    }
    
    
    @IBAction func btnChangeTextFontSize(sender: AnyObject) {
        changeWebViewFontSize(sender.tag,webView: webViewDetails)
    }
    
    
    func changeWebViewFontSize(decOrInc: Int, webView: UIWebView)
    {
        //1 = decreace
        //2 = increace
        var textFontSizeTemp = defaults["textFontSize"]! as Int
        
        
        switch decOrInc
        {
        case 1: //when decrease
            textFontSizeTemp  = textFontSizeTemp - 1
        case 2: //when increase
            textFontSizeTemp = textFontSizeTemp + 1
        default:
            break
        }
        
        if textFontSizeTemp > 28
        {
            textFontSizeTemp = 28
        }
        else if textFontSizeTemp < 8
        {
            textFontSizeTemp = 8
        }
        
        let jsString = "document.getElementsByTagName('body')[0].style.fontSize='\(textFontSizeTemp)px'"
        webView.stringByEvaluatingJavaScriptFromString(jsString)
        
        //        self.view.layoutIfNeeded()
        //        webViewDetails.reload()
        let difference = getHeightForTitle(sliderNewsDetails.NewsDetails,fontSize: CGFloat(textFontSizeTemp))
        
        print(difference)
        
        constraintsScrollViewContentHeight.constant =  difference +   imageViewHeight + 160
        constraintWebViewHeight.constant = difference + 80
        self.view.layoutIfNeeded()
        
        defaults["textFontSize"] = textFontSizeTemp
    }
    
    func getHeightForTitle(postTitle: NSString,fontSize : CGFloat) -> CGFloat {
        // Get the height of the font
        let constraintSize = CGSizeMake(self.view.bounds.width, CGFloat.max)
        
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(fontSize + 5)]
        let labelSize = postTitle.boundingRectWithSize(constraintSize,
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: attributes,
            context: nil)
        
        return labelSize.height
    }
    
    
    
    //MARK:- BusinessLogic methods
    
    //MARK:- Delegate
    
    func webViewDidFinishLoad(webView: UIWebView) {
        resizeConstraints()
    }
    
    
    func resizeConstraints()
    {
        let height = webViewDetails.scrollView.contentSize.height
        constraintsScrollViewContentHeight.constant = height +   imageViewHeight + 160
        constraintWebViewHeight.constant = height + 80
        print(height)
        self.view.layoutIfNeeded()
    }
    
    func googleAnalyticsEvent(category: String, action: String, label: String, value: NSNumber)
    {
        let tracker = GAI.sharedInstance().defaultTracker
        let builder =  GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value)
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}


extension HomeDetailViewController: CommentListViewControllerDelegate {
    
    func commentListCount(count: Int) {
        lblCommentCount.text = "\(count)"
    }
    
}

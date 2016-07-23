//
//  PhotographyViewController.swift
//  Alayam
//
//  Created by Mala on 7/30/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class PhotographyViewController: UIViewController, PhotographyModelDelegate,UIScrollViewDelegate,UIWebViewDelegate {
    
    @IBOutlet weak var btnReader: UIButton!
    @IBOutlet weak var imgViewPhoto: UIImageView!
    
    var isAlreadyInReaderList = false
    
    @IBOutlet weak var constraintImageViewHeight: NSLayoutConstraint!
    
     @IBOutlet weak var webViewDetails: UIWebView!
     @IBOutlet weak var constraintWebViewHeight: NSLayoutConstraint!
     @IBOutlet weak var constraintsScrollViewContentHeight: NSLayoutConstraint!
    
    //imageZoom
    @IBOutlet weak var viewImageZoom: UIView!
    @IBOutlet weak var scrollViewZoom: UIScrollView!
    var imageViewZoom: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblNewsTitle1: UILabel!
    var isTapToHide :Bool = true
    @IBOutlet weak var viewHeaderblack: UIView!
    @IBOutlet weak var viewFooterblack: UIView!
    @IBOutlet weak var lblNavTitle: UILabel!
    var model = PhotographyModel()
    
    @IBOutlet weak var lblDate: UILabel!
    @IBAction func btnMenuAction(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
    }
    

    @IBOutlet weak var lblImageTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appdelegate = AppDelegate()
        appdelegate.Loadwebview(self.view, target: self)
        
        model.delegate = self
        model.getPhotosList()
        
        isTapToHide = true
        constraintImageViewHeight.constant = self.view.frame.size.height - 65
        self.view.layoutIfNeeded()
        
        viewImageZoom.hidden = true
        viewImageZoom.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(animated: Bool) {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:"imageTapped:")
        imgViewPhoto.addGestureRecognizer(tapGestureRecognizer)
        
        //Tracker 1 & 2
        let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
        tracker2.set(kGAIScreenName, value: "iOS-PhotographyView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker2.send(builder.build() as [NSObject : AnyObject])
//        var tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: "Photography Screen")
//        
//        var builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])

        
    }
    
    func imageTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        // Your action
        
        
        self.viewImageZoom.hidden = false
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.viewImageZoom.alpha = 1
            }, completion: nil)
        
        
        print("Tap Gesture recognized")
        
        
        // 1
        //let imgstr = imgViewOriginalImage.image
        let image = imgViewPhoto.image
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
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageViewZoom
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }

    
    //MARK:- IBAction
    @IBAction func btnCloseAction(sender: AnyObject) {
        viewImageZoom.hidden = true
        imageViewZoom.removeFromSuperview()
    }
  
    @IBAction func btnAddToReadersListAction(sender: AnyObject) {
        
        if model.photosList.count > 0
        {
            let photoDetails = model.photosList.objectAtIndex(0) as! PhotographyDTO
            
        
        LocalCacheDataHandler().addNewReaderList(photoDetails.categoryNewsDTO)
        
        if isAlreadyInReaderList
        {
            btnReader.setImage(UIImage(named: "w_star"), forState: UIControlState.Normal)
            isAlreadyInReaderList = false
        }
        else
        {
            btnReader.setImage(UIImage(named: "fav_img_reader"), forState: UIControlState.Normal)
            isAlreadyInReaderList = true
        }
        
        }
    }
    func scrollViewDoubleTapped1(gestureRecognizer: UITapGestureRecognizer)
    {
        if(isTapToHide == true)
        {
            
            UIView.animateWithDuration(1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.isTapToHide = false
                //                self.btnClose.hidden = true
                //                self.lblNewsTitle1.hidden = true
                
                self.btnClose.alpha = 0
                self.lblNewsTitle1.alpha = 0
                self.viewHeaderblack.alpha = 0
                self.viewFooterblack.alpha = 0
                }, completion: nil)
            
            
        }
        else
        {
            UIView.animateWithDuration(1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.isTapToHide = true
                //            self.btnClose.hidden = false
                //            self.lblNewsTitle1.hidden = false
                self.btnClose.alpha = 1
                self.lblNewsTitle1.alpha = 1
                self.viewHeaderblack.alpha = 0.3
                self.viewFooterblack.alpha = 0.3
                }, completion: nil)
        }
    }
    
    @IBAction func btnShareAction(sender: AnyObject) {
        
        let textToShare = "Alayam News Details"
        googleAnalyticsEvent("UI_Action", action: "Share", label: "", value: 0)
        if let myWebsite = NSURL(string: "http://www.alayam.com")
        {
            let objectsToShare = [textToShare, myWebsite]
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
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let height = webView.scrollView.contentSize.height
        constraintsScrollViewContentHeight.constant = height +   self.view.frame.size.height + 100
        constraintWebViewHeight.constant = height
        
        self.view.layoutIfNeeded()
    }
    
    
    
    
    func refreshPhoto()
    {
        if model.photosList.count > 0
        {
            let photoDetails = model.photosList.objectAtIndex(0) as! PhotographyDTO
            
            if  LocalCacheDataHandler().isAlreadyInReadersList(photoDetails.categoryNewsDTO)
            {
                btnReader.setImage(UIImage(named: "fav_img_reader"), forState: UIControlState.Normal)
                isAlreadyInReaderList = true
            }
            else
            {
                btnReader.setImage(UIImage(named: "w_star"), forState: UIControlState.Normal)
                isAlreadyInReaderList = false
            }
            
            imgViewPhoto.setImageWithUrl(NSURL(string: photoDetails.ImageURL_L)!, placeHolderImage: nil)
            
            lblImageTitle.text = photoDetails.NewsTitle
            lblNewsTitle1.text = photoDetails.NewsPhotoCaption
            lblDate.text = photoDetails.NewsDate
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
                lblImageTitle.font = UIFont(name: lblImageTitle.font.fontName, size: 18)
                lblNewsTitle1.font = UIFont(name: lblNewsTitle1.font.fontName, size: 18)
                lblDate.font = UIFont(name: lblDate.font.fontName, size: 18)
                lblNavTitle.font = UIFont(name: lblNavTitle.font.fontName, size: 25)
            }
            
            let string = NSString(format: "<html><body p style='color:#00183F' align='right' text=\"#FFFFFF\" face=\"Bookman Old Style, Book Antiqua, Garamond\" size=\"25\">%@</body></html>",photoDetails.NewsDetails) as String // .stringWithFormat:@, justifiedString
            
            webViewDetails.loadHTMLString(string, baseURL: nil)
            
            webViewDetails.backgroundColor = UIColor.orangeColor()
            
        }
    }
    
    func googleAnalyticsEvent(category: String, action: String, label: String, value: NSNumber)
    {
        let tracker = GAI.sharedInstance().defaultTracker
        let builder =  GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value)
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

}
